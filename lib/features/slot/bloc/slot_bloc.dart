import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/bookings/repository/bookings_repository.dart';
import 'package:noq/features/slot/bloc/slot_event.dart';
import 'package:noq/features/slot/bloc/slot_state.dart';
import 'package:noq/features/slot/repository/slot_repository.dart';

/// Error codes that mean our copy of the grid no longer matches the shop's, so
/// the selection is void and the day has to be reloaded before the customer can
/// try again. `SLOT_FULL` is the common one: the listing holds no chair, so
/// somebody can take the last one between the GET and the POST.
const Set<String> _staleGridCodes = {
  'SLOT_FULL',
  'SLOTS_NOT_CONSECUTIVE',
  'SLOTS_INSUFFICIENT',
  'SLOT_IN_PAST',
  'SLOT_DAY_CLOSED',
  'SLOT_DATE_OUT_OF_WINDOW',
};

/// Nothing bookable is left on this screen — the cart emptied or moved shop
/// underneath us, so the customer has to go back and rebuild it.
const Set<String> _cartInvalidCodes = {'CART_EMPTY', 'CART_BUSINESS_MISMATCH'};

class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final SlotRepository _repository;
  final BookingsRepository _bookingsRepository;

  String _businessId = '';

  SlotBloc(this._repository, {BookingsRepository? bookingsRepository})
    : _bookingsRepository = bookingsRepository ?? BookingsRepository(),
      super(const SlotInitial()) {
    on<SlotRequested>(_onSlotRequested);
    on<SlotDateSelected>(_onSlotDateSelected);
    on<SlotRunSelected>(_onSlotRunSelected);
    on<SlotSelectionCleared>(_onSlotSelectionCleared);
    on<SlotStaffSelected>(_onSlotStaffSelected);
    on<SlotBookingSubmitted>(_onSlotBookingSubmitted);
  }

  Future<void> _onSlotRequested(
    SlotRequested event,
    Emitter<SlotState> emit,
  ) async {
    _businessId = event.businessId;
    emit(const SlotLoading());
    try {
      // No date is sent on the first load so the backend defaults to today.
      final model = await _repository.getSlots(event.businessId);
      emit(SlotLoaded(model: model, selectedDate: model.window.selectedDate));
    } on ApiException catch (e) {
      emit(SlotFailure(message: e.message));
    } catch (e) {
      emit(SlotFailure(message: e.toString()));
    }
  }

  Future<void> _onSlotDateSelected(
    SlotDateSelected event,
    Emitter<SlotState> emit,
  ) async {
    final current = state;
    if (current is! SlotLoaded) return;

    // A closed day needs no round trip; the UI shows a closed message instead.
    if (event.date.isClosed) {
      emit(
        current.copyWith(
          selectedDate: event.date.date,
          isDayClosed: true,
          isTimesLoading: false,
          timesError: null,
          selectedStart: null,
        ),
      );
      return;
    }

    emit(
      current.copyWith(
        selectedDate: event.date.date,
        isDayClosed: false,
        isTimesLoading: true,
        timesError: null,
        selectedStart: null,
      ),
    );

    await _loadDate(event.date.date, emit);
  }

  /// Fetches one day's grid into the current [SlotLoaded].
  ///
  /// Callers must already have emitted `isTimesLoading: true` and nulled
  /// `selectedStart` — swapping `model` can invalidate an existing run, since the
  /// cart total or a chip's status may have changed.
  Future<void> _loadDate(String date, Emitter<SlotState> emit) async {
    try {
      final model = await _repository.getSlots(_businessId, date: date);
      final latest = state;
      // Drop the response if the customer has since picked another date.
      if (latest is! SlotLoaded || latest.selectedDate != date) return;
      emit(latest.copyWith(model: model, isTimesLoading: false));
    } on ApiException catch (e) {
      _emitTimesError(emit, date, e.message);
    } catch (e) {
      _emitTimesError(emit, date, e.toString());
    }
  }

  void _emitTimesError(Emitter<SlotState> emit, String date, String message) {
    final latest = state;
    if (latest is! SlotLoaded || latest.selectedDate != date) return;
    emit(latest.copyWith(isTimesLoading: false, timesError: message));
  }

  void _onSlotRunSelected(SlotRunSelected event, Emitter<SlotState> emit) {
    final current = state;
    if (current is! SlotLoaded) return;
    emit(current.copyWith(selectedStart: event.start));
  }

  void _onSlotSelectionCleared(
    SlotSelectionCleared event,
    Emitter<SlotState> emit,
  ) {
    final current = state;
    if (current is! SlotLoaded) return;
    emit(current.copyWith(selectedStart: null));
  }

  void _onSlotStaffSelected(SlotStaffSelected event, Emitter<SlotState> emit) {
    final current = state;
    if (current is! SlotLoaded) return;
    emit(current.copyWith(selectedStaffId: event.staffId));
  }

  Future<void> _onSlotBookingSubmitted(
    SlotBookingSubmitted event,
    Emitter<SlotState> emit,
  ) async {
    final current = state;
    if (current is! SlotLoaded || current.isSubmitting) return;

    // Same gate as the footer button: a partial run is not bookable.
    final slots = current.selectedStarts;
    if (slots.isEmpty || slots.length != current.requiredSlots) return;

    // submitError goes back to null on every attempt so a repeat of the same
    // failure is still a state change the screen can show a snackbar for.
    emit(
      current.copyWith(
        isSubmitting: true,
        submitError: null,
        isCartInvalid: false,
      ),
    );

    try {
      final booking = await _bookingsRepository.createBooking(
        slots: slots,
        staffId: current.selectedStaffId,
      );
      final latest = state;
      if (latest is! SlotLoaded) return;
      emit(latest.copyWith(isSubmitting: false, createdBooking: booking));
    } on ApiException catch (e) {
      await _emitSubmitFailure(emit, e.code, e.message);
    } catch (e) {
      await _emitSubmitFailure(emit, null, e.toString());
    }
  }

  Future<void> _emitSubmitFailure(
    Emitter<SlotState> emit,
    String? code,
    String message,
  ) async {
    final latest = state;
    if (latest is! SlotLoaded) return;

    // The chosen run is gone or was never legal. Drop it and pull the day again
    // so the customer picks from a fresh grid — never retry the same starts.
    if (code != null && _staleGridCodes.contains(code)) {
      emit(
        latest.copyWith(
          isSubmitting: false,
          submitError: message,
          selectedStart: null,
          isTimesLoading: true,
          timesError: null,
        ),
      );
      await _loadDate(latest.selectedDate, emit);
      return;
    }

    // That staff member cannot do every service in the cart. Fall back to
    // Anyone and refresh so `staff.members` matches what the shop allows now.
    if (code == 'STAFF_SERVICE_MISMATCH') {
      emit(
        latest.copyWith(
          isSubmitting: false,
          submitError: message,
          selectedStaffId: null,
          selectedStart: null,
          isTimesLoading: true,
          timesError: null,
        ),
      );
      await _loadDate(latest.selectedDate, emit);
      return;
    }

    emit(
      latest.copyWith(
        isSubmitting: false,
        submitError: message,
        isCartInvalid: code != null && _cartInvalidCodes.contains(code),
      ),
    );
  }
}
