import 'package:noq/features/slot/data/slot_model.dart';

/// Chips needed for a visit. One chip covers [blockMinutes]; the buffer applies
/// once to the whole booking, not per chip. Returns the smallest N satisfying
/// `N * blockMinutes + bufferMinutes >= totalDurationMinutes`.
///
/// Do NOT use the per-chip formula `ceil(total / (block + buffer))` — it counts
/// the buffer once per chip and under-counts long visits.
int requiredSlotCount({
  required int totalDurationMinutes,
  required int blockMinutes,
  required int bufferMinutes,
}) {
  if (blockMinutes <= 0) return 1;
  final needed = totalDurationMinutes - bufferMinutes;
  if (needed <= 0) return 1;
  return (needed + blockMinutes - 1) ~/ blockMinutes; // ceil
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
