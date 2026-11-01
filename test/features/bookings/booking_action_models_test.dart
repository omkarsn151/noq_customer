import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:noq/features/bookings/data/booking_cancelled_model.dart';
import 'package:noq/features/bookings/data/booking_rescheduled_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

// JSON round-trip so nested maps are Map<String, dynamic>, like a real response.
Map<String, dynamic> _json(Map<String, dynamic> value) =>
    jsonDecode(jsonEncode(value)) as Map<String, dynamic>;

/// The cancel example from docs/booking-reschedule-cancel/00-overview.md.
Map<String, dynamic> _cancelSample({
  bool isLate = true,
  String amount = '199.50',
  String? reason = 'Change of plans',
  String toTab = 'cancelled',
}) => _json({
  'booking': {
    'id': 'b-1',
    'status': 'cancelled',
    'cancelled_by': 'customer',
    'cancelled_at': '2026-08-20T03:30:00Z',
  },
  'cancellation': {
    'reason': reason,
    'is_late_cancellation': isLate,
    'fee': {'currency_code': 'INR', 'amount': amount},
  },
  'tabs_hint': {'from_tab': 'upcoming', 'to_tab': toTab},
});

/// The reschedule examples from docs/booking-reschedule-cancel/00-overview.md.
Map<String, dynamic> _movedSample() => _json({
  'booking': {'id': 'b-1', 'status': 'confirmed', 'approval_mode': 'auto'},
  'schedule': {
    'scheduled_start': '2026-08-27T04:30:00Z',
    'scheduled_end': '2026-08-27T05:15:00Z',
    'slots': ['2026-08-27T04:30:00Z'],
    'timezone': 'Asia/Kolkata',
  },
  'staff': {
    'requested_staff_id': 's-1',
    'requested_staff_name': 'Priya Sharma',
  },
  'reschedule': {
    'outcome': 'moved',
    'rescheduled_at': '2026-08-25T12:00:00Z',
    'previous_start': '2026-08-26T04:30:00Z',
    'previous_end': '2026-08-26T05:15:00Z',
  },
});

Map<String, dynamic> _pendingSample() => _json({
  'booking': {'id': 'b-1', 'status': 'confirmed', 'approval_mode': 'manual'},
  'schedule': {
    'scheduled_start': '2026-08-26T04:30:00Z',
    'scheduled_end': '2026-08-26T05:15:00Z',
    'slots': ['2026-08-27T04:30:00Z'],
    'timezone': 'Asia/Kolkata',
  },
  'staff': {'requested_staff_name': 'Anyone'},
  'reschedule': {
    'outcome': 'request_pending',
    'previous_start': '2026-08-26T04:30:00Z',
    'previous_end': '2026-08-26T05:15:00Z',
    'request': {
      'id': 'r-1',
      'status': 'pending',
      'proposed_start': '2026-08-27T04:30:00Z',
      'proposed_end': '2026-08-27T05:15:00Z',
      'created_at': '2026-08-25T12:00:00Z',
    },
  },
});

Map<String, dynamic> _unchangedSample() => _json({
  'booking': {'id': 'b-1', 'status': 'confirmed', 'approval_mode': 'auto'},
  'schedule': {
    'scheduled_start': '2026-08-26T04:30:00Z',
    'scheduled_end': '2026-08-26T05:15:00Z',
  },
  'staff': {'requested_staff_name': 'Anyone'},
  'reschedule': {
    'outcome': 'unchanged',
    'previous_start': '2026-08-26T04:30:00Z',
    'previous_end': '2026-08-26T05:15:00Z',
  },
});

void main() {
  group('BookingCancelledModel', () {
    test('late cancel carries the fee and the tab move', () {
      final model = BookingCancelledModel.fromJson(
        _cancelSample(),
        message: 'Your booking has been cancelled successfully.',
      );

      expect(model.bookingId, 'b-1');
      expect(model.status, 'cancelled');
      expect(model.cancelledBy, 'customer');
      expect(model.cancelledAt, DateTime.utc(2026, 8, 20, 3, 30));
      expect(model.reason, 'Change of plans');
      expect(model.isLateCancellation, isTrue);
      expect(model.hasFee, isTrue);
      expect(model.feeAmount, '199.50');
      expect(model.currencyCode, 'INR');
      expect(model.fromTab, BookingTab.upcoming);
      expect(model.toTab, BookingTab.cancelled);
      expect(model.message, 'Your booking has been cancelled successfully.');
    });

    test('on-time cancel has no fee and may have no reason', () {
      final model = BookingCancelledModel.fromJson(
        _cancelSample(isLate: false, amount: '0.00', reason: null),
        message: '',
      );

      expect(model.hasFee, isFalse);
      expect(model.reason, isNull);
    });

    test('late cancel at a zero percent shop has no fee', () {
      final model = BookingCancelledModel.fromJson(
        _cancelSample(amount: '0.00'),
        message: '',
      );

      expect(model.isLateCancellation, isTrue);
      expect(model.hasFee, isFalse);
    });

    test('unknown tab hint parses to null', () {
      final model = BookingCancelledModel.fromJson(
        _cancelSample(toTab: 'archived'),
        message: '',
      );

      expect(model.toTab, isNull);
    });
  });

  group('BookingRescheduledModel', () {
    test('moved carries the new time and no request', () {
      final model = BookingRescheduledModel.fromJson(
        _movedSample(),
        message: 'Your booking has been rescheduled successfully.',
      );

      expect(model.outcome, RescheduleOutcome.moved);
      expect(model.approvalMode, 'auto');
      expect(model.scheduledStart, DateTime.utc(2026, 8, 27, 4, 30));
      expect(model.previousStart, DateTime.utc(2026, 8, 26, 4, 30));
      expect(model.proposedStart, isNull);
      expect(model.requestedStaffName, 'Priya Sharma');
    });

    test('request_pending keeps the old time and carries the proposal', () {
      final model = BookingRescheduledModel.fromJson(
        _pendingSample(),
        message: 'Your reschedule request has been sent to the shop.',
      );

      expect(model.outcome, RescheduleOutcome.requestPending);
      expect(model.proposedStart, DateTime.utc(2026, 8, 27, 4, 30));
      expect(model.proposedEnd, DateTime.utc(2026, 8, 27, 5, 15));
      expect(model.scheduledStart, model.previousStart);
      expect(model.requestedStaffName, 'Anyone');
    });

    test('unchanged has no request', () {
      final model = BookingRescheduledModel.fromJson(
        _unchangedSample(),
        message: 'Your booking is already at that time.',
      );

      expect(model.outcome, RescheduleOutcome.unchanged);
      expect(model.proposedStart, isNull);
      expect(model.message, 'Your booking is already at that time.');
    });

    test('unknown or missing outcome falls back to requestPending', () {
      expect(
        RescheduleOutcome.fromValue('weird'),
        RescheduleOutcome.requestPending,
      );
      expect(
        RescheduleOutcome.fromValue(null),
        RescheduleOutcome.requestPending,
      );
    });
  });
}
