import 'package:flutter_test/flutter_test.dart';
import 'package:noq/features/slot/data/slot_math.dart';
import 'package:noq/features/slot/data/slot_model.dart';

SlotTime _slot(String hhmm, {String status = 'available'}) {
  final parts = hhmm.split(':');
  final start = DateTime.utc(
    2026,
    1,
    1,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
  return SlotTime(
    start: start,
    end: start.add(const Duration(minutes: 30)),
    status: status,
  );
}

void main() {
  group('requiredSlotCount', () {
    int count(int total, {int block = 30, int buffer = 15}) =>
        requiredSlotCount(
          totalDurationMinutes: total,
          blockMinutes: block,
          bufferMinutes: buffer,
        );

    test('block 30, buffer 15 — every row of the spec table', () {
      expect(count(30), 1, reason: 'fits in one block');
      expect(count(40), 1, reason: '30 + 15 buffer = 45 >= 40');
      expect(count(45), 1, reason: 'exactly 45');
      expect(count(46), 2, reason: 'exceeds 45');
      expect(count(60), 2, reason: 'one chip only covers 45');
      expect(
        count(70),
        2,
        reason: '2*30 + 15 = 75 >= 70 — buffer counted once',
      );
      expect(count(80), 3, reason: '75 < 80');
      expect(count(90), 3, reason: '75 < 90');
    });

    test('buffer 0', () {
      expect(count(30, buffer: 0), 1);
      expect(count(31, buffer: 0), 2);
    });

    test('different block size (block 20, buffer 10)', () {
      expect(count(30, block: 20, buffer: 10), 1); // 20 + 10 = 30
      expect(count(31, block: 20, buffer: 10), 2);
      expect(count(50, block: 20, buffer: 10), 2); // 2*20 + 10 = 50
      expect(count(51, block: 20, buffer: 10), 3);
    });

    test('degenerate blockMinutes: 0 guard returns 1', () {
      expect(count(120, block: 0), 1);
    });
  });

  group('canStartRunAt', () {
    test('rejects a run that overruns the end of the list', () {
      final times = [_slot('09:00'), _slot('09:30'), _slot('10:00')];
      expect(canStartRunAt(times, 2, 2, 30), isFalse);
    });

    test('rejects a run containing a full chip', () {
      final times = [
        _slot('09:00'),
        _slot('09:30', status: 'full'),
        _slot('10:00'),
      ];
      expect(canStartRunAt(times, 0, 3, 30), isFalse);
    });

    test('rejects a run containing a past chip', () {
      final times = [
        _slot('09:00', status: 'past'),
        _slot('09:30'),
        _slot('10:00'),
      ];
      expect(canStartRunAt(times, 0, 2, 30), isFalse);
    });

    test('rejects a run spanning a gap; accepts contiguous runs', () {
      // 10:00 cell omitted (e.g. off-hours), so 09:30 and 10:30 are
      // list-adjacent but 60 minutes apart.
      final times = [
        _slot('09:00'),
        _slot('09:30'),
        _slot('10:30'),
        _slot('11:00'),
        _slot('11:30'),
      ];
      expect(canStartRunAt(times, 1, 2, 30), isFalse, reason: 'spans the gap');
      expect(canStartRunAt(times, 0, 2, 30), isTrue, reason: '09:00 -> 09:30');
      expect(canStartRunAt(times, 2, 2, 30), isTrue, reason: '10:30 -> 11:00');
    });
  });
}
