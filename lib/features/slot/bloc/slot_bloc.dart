import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/slot/bloc/slot_event.dart';
import 'package:noq/features/slot/bloc/slot_state.dart';
import 'package:noq/features/slot/repository/slot_repository.dart';

class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final SlotRepository _repository;

  String _businessId = '';

  SlotBloc(this._repository) : super(const SlotInitial()) {
    on<SlotRequested>(_onSlotRequested);
    on<SlotDateSelected>(_onSlotDateSelected);
    on<SlotRunSelected>(_onSlotRunSelected);
    on<SlotSelectionCleared>(_onSlotSelectionCleared);
    on<SlotStaffSelected>(_onSlotStaffSelected);
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

    try {
      final model = await _repository.getSlots(
        _businessId,
        date: event.date.date,
      );
      final latest = state;
      // Drop the response if the customer has since picked another date.
      if (latest is! SlotLoaded || latest.selectedDate != event.date.date) {
        return;
      }
      // `selectedStart` was already nulled when this date change began. Any
      // future path that swaps `model` must also null `selectedStart`, since a
      // changed cart total can invalidate an existing run.
      emit(latest.copyWith(model: model, isTimesLoading: false));
    } on ApiException catch (e) {
      _emitTimesError(emit, event.date.date, e.message);
    } catch (e) {
      _emitTimesError(emit, event.date.date, e.toString());
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
}
