import 'package:noq/features/slot/data/slot_model.dart';

/// Chips needed for a visit: `ceil(total / (blockMinutes + bufferMinutes))`.
///
/// One cell covers `blockMinutes + bufferMinutes` of real time — the buffer is
/// padding baked *inside* every cell, not a gap between cells and not slack on
/// the booking as a whole. Cells are still stepped every [blockMinutes], so they
/// overlap: with block 30 / buffer 15 the grid runs 9:00-9:45, 9:30-10:15,
/// 10:00-10:45, and a 90-minute visit takes two of them (9:00 + 9:30, ending
/// 10:15).
///
/// This is the count `POST /v1/customer/bookings` validates `slots` against;
/// too few is `SLOTS_INSUFFICIENT`.
int requiredSlotCount({
  required int totalDurationMinutes,
  required int blockMinutes,
  required int bufferMinutes,
}) {
  // Guard against degenerate operations data rather than dividing by zero.
  if (blockMinutes <= 0) return 1;
  if (totalDurationMinutes <= 0) return 1;
  final cellMinutes = blockMinutes + bufferMinutes;
  return (totalDurationMinutes + cellMinutes - 1) ~/ cellMinutes; // ceil
}

/// Whether a run of [count] consecutive chips can START at [index] in [times].
///
/// All of these must hold:
/// 1. The run fits: `index + count <= times.length`.
/// 2. Every chip in the run is available (`full`/`past` chips block a run).
/// 3. Every chip starts exactly [blockMinutes] after the previous one.
///
/// Rule 3 matters because lunch-break and off-hours cells are omitted from
/// [times] entirely — two list-adjacent entries are not necessarily adjacent on
/// the clock, so compare `start` timestamps rather than trusting list order.
bool canStartRunAt(
  List<SlotTime> times,
  int index,
  int count,
  int blockMinutes,
) {
  if (count <= 0 || index < 0 || index + count > times.length) return false;
  for (var i = index; i < index + count; i++) {
    if (!times[i].isAvailable) return false;
    if (i > index &&
        times[i].start.difference(times[i - 1].start).inMinutes !=
            blockMinutes) {
      return false;
    }
  }
  return true;
}
