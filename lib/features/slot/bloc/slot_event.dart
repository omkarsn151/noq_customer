import 'package:equatable/equatable.dart';
import 'package:noq/features/slot/data/slot_model.dart';

abstract class SlotEvent extends Equatable {
  const SlotEvent();

  @override
  List<Object?> get props => [];
}

class SlotRequested extends SlotEvent {
  final String businessId;

  const SlotRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}

class SlotDateSelected extends SlotEvent {
  final SlotDate date;

  const SlotDateSelected(this.date);

  @override
  List<Object?> get props => [date.date];
}

/// The customer tapped a chip that can start a run; [start] is that chip's
/// start. The run of `requiredSlots` chips from here is selected.
class SlotRunSelected extends SlotEvent {
  final DateTime start;

  const SlotRunSelected(this.start);

  @override
  List<Object?> get props => [start];
}

/// The customer tapped a chip inside the current run; the whole run is cleared.
class SlotSelectionCleared extends SlotEvent {
  const SlotSelectionCleared();
}

/// [staffId] is null when the customer picks "Anyone".
class SlotStaffSelected extends SlotEvent {
  final String? staffId;

  const SlotStaffSelected(this.staffId);

  @override
  List<Object?> get props => [staffId];
}
