import 'package:equatable/equatable.dart';
import 'package:noq/features/bookings/data/booking_created_model.dart';
import 'package:noq/features/bookings/data/booking_rescheduled_model.dart';
import 'package:noq/features/slot/data/slot_math.dart';
import 'package:noq/features/slot/data/slot_model.dart';

/// Sentinel used by [SlotLoaded.copyWith] so that nullable fields can be
/// cleared as well as replaced.
const Object _unset = Object();

abstract class SlotState extends Equatable {
  const SlotState();

  @override
  List<Object?> get props => [];
}

class SlotInitial extends SlotState {
  const SlotInitial();
}

class SlotLoading extends SlotState {
  const SlotLoading();
}

class SlotLoaded extends SlotState {
  final SlotModel model;

  /// The date whose slots are shown; drives the date-strip highlight.
  final String selectedDate;

  /// True when the selected date is a closed day, in which case no slots were
  /// requested from the API.
  final bool isDayClosed;

  /// True while a date change is being fetched; only the time section shows a
  /// spinner, the rest of the screen stays put.
  final bool isTimesLoading;

  /// Inline error for a failed date change; a first-load failure emits
  /// [SlotFailure] instead.
  final String? timesError;

  /// Start of the highlighted run of chips. A visit can span several
  /// consecutive chips; this is the first one and the rest is derived.
  final DateTime? selectedStart;

  /// Null means "Anyone".
  final String? selectedStaffId;

  /// True while the create-booking call is in flight; Proceed is disabled and
  /// shows a spinner.
  final bool isSubmitting;

  /// Message for a failed create-booking call, shown as a snackbar.
  final String? submitError;

  /// True when [submitError] means the cart itself is no longer bookable here
  /// (emptied, or its shop is no longer public). Nothing on this screen can
  /// recover from that, so the customer is sent back to the cart.
  final bool isCartInvalid;

  /// Set once the booking exists — the screen listens for this and navigates to
  /// the confirmation. The cart is empty by then, so there is no going back.
  final BookingCreatedModel? createdBooking;

  /// Set once a reschedule call succeeds. The screen listens for this; see
  /// [BookingRescheduledModel.outcome] for whether the booking actually moved.
  final BookingRescheduledModel? rescheduled;

  /// True when [submitError] means this booking can no longer be moved from
  /// here (not confirmed any more, a request already waiting, expired, gone, or
  /// the shop went private). The screen leaves; the caller refreshes.
  final bool isBookingInvalid;

  const SlotLoaded({
    required this.model,
    required this.selectedDate,
    this.isDayClosed = false,
    this.isTimesLoading = false,
    this.timesError,
    this.selectedStart,
    this.selectedStaffId,
    this.isSubmitting = false,
    this.submitError,
    this.isCartInvalid = false,
    this.createdBooking,
    this.rescheduled,
    this.isBookingInvalid = false,
  });

  SlotLoaded copyWith({
    SlotModel? model,
    String? selectedDate,
    bool? isDayClosed,
    bool? isTimesLoading,
    Object? timesError = _unset,
    Object? selectedStart = _unset,
    Object? selectedStaffId = _unset,
    bool? isSubmitting,
    Object? submitError = _unset,
    bool? isCartInvalid,
    Object? createdBooking = _unset,
    Object? rescheduled = _unset,
    bool? isBookingInvalid,
  }) {
    return SlotLoaded(
      model: model ?? this.model,
      selectedDate: selectedDate ?? this.selectedDate,
      isDayClosed: isDayClosed ?? this.isDayClosed,
      isTimesLoading: isTimesLoading ?? this.isTimesLoading,
      timesError: identical(timesError, _unset)
          ? this.timesError
          : timesError as String?,
      selectedStart: identical(selectedStart, _unset)
          ? this.selectedStart
          : selectedStart as DateTime?,
      selectedStaffId: identical(selectedStaffId, _unset)
          ? this.selectedStaffId
          : selectedStaffId as String?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: identical(submitError, _unset)
          ? this.submitError
          : submitError as String?,
      isCartInvalid: isCartInvalid ?? this.isCartInvalid,
      createdBooking: identical(createdBooking, _unset)
          ? this.createdBooking
          : createdBooking as BookingCreatedModel?,
      rescheduled: identical(rescheduled, _unset)
          ? this.rescheduled
          : rescheduled as BookingRescheduledModel?,
      isBookingInvalid: isBookingInvalid ?? this.isBookingInvalid,
    );
  }

  int get blockMinutes => model.business.operations.blockMinutes;

  /// How many back-to-back chips this visit needs.
  int get requiredSlots => requiredSlotCount(
    totalDurationMinutes: model.summary.totalDurationMinutes,
    blockMinutes: blockMinutes,
    bufferMinutes: model.business.operations.bufferMinutes,
  );

  /// Index into `model.times` where the run starts, or -1 if there is no
  /// selection or the stored start no longer matches a chip.
  int get _startIndex => selectedStart == null
      ? -1
      : model.times.indexWhere((t) => t.start == selectedStart);

  /// The indexes to paint as selected. Empty when there is no selection OR the
  /// stored run is no longer valid (cart total grew, a chip went `full`, the
  /// date changed) — which also disables the Proceed button.
  Set<int> get selectedIndexes {
    final i = _startIndex;
    if (i < 0 || !canStartRunAt(model.times, i, requiredSlots, blockMinutes)) {
      return const {};
    }
    return {for (var k = i; k < i + requiredSlots; k++) k};
  }

  /// Chip starts to send to the booking API, in order. The first is the start
  /// of the visit.
  List<DateTime> get selectedStarts => (selectedIndexes.toList()..sort())
      .map((k) => model.times[k].start)
      .toList();

  /// `end` of the last chip in the run. A chip's `end` is already
  /// `start + block + buffer`, so never add the buffer again on top of this.
  DateTime? get selectedEnd {
    final idx = selectedIndexes;
    if (idx.isEmpty) return null;
    return model.times[idx.reduce((a, b) => a > b ? a : b)].end;
  }

  @override
  List<Object?> get props => [
    model,
    selectedDate,
    isDayClosed,
    isTimesLoading,
    timesError,
    selectedStart,
    selectedStaffId,
    isSubmitting,
    submitError,
    isCartInvalid,
    createdBooking,
    rescheduled,
    isBookingInvalid,
  ];
}

class SlotFailure extends SlotState {
  final String message;

  /// The API error code, so the screen can tell a booking that can no longer
  /// be rescheduled from a network error.
  final String? code;

  const SlotFailure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
