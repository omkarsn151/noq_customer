import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';
import 'package:noq/features/bookings/data/booking_tone.dart';

/// The sample response from docs/customer-booking-details.md.
// JSON round-trip so nested maps are Map<String, dynamic>, like a real response.
Map<String, dynamic> _sample() =>
    jsonDecode(
          jsonEncode({
            'booking': {
              'id': '0198f7c0-1a2b-7c3d-8e4f-5a6b7c8d9e0f',
              'reference': 'BK-7KQ4M2',
              'status': 'confirmed',
              'status_label': 'Confirmed',
              'status_message':
                  'Your slot is secured, please arrive 10 mins earlier.',
              'tone': 'success',
              'verification_code': '482917',
              'has_pending_reschedule': false,
              'has_reviewed': false,
            },
            'business': {
              'id': '0198f0a1-2b3c-7d4e-8f5a-6b7c8d9e0f1a',
              'name': 'Dentistry Dental',
              'thumbnail_url':
                  'http://localhost:8000/api/v1/uploads/0198c1/file',
              'location': {
                'address':
                    '12 North Main Road, Koregaon Park, Pune, Maharashtra 411001',
                'address_line': '12 North Main Road',
                'address_line_2': 'Koregaon Park',
                'city': 'Pune',
                'state': 'Maharashtra',
                'postal_code': '411001',
                'country_code': 'IN',
                'latitude': 18.5362,
                'longitude': 73.8939,
                'map_url':
                    'https://www.google.com/maps/search/?api=1&query=18.5362,73.8939',
                'directions_url':
                    'https://www.google.com/maps/dir/?api=1&destination=18.5362,73.8939',
              },
              'distance_km': 1.2,
              'closes_at': '20:00',
            },
            'services': [
              {
                'id': '0198f0b2-3c4d-7e5f-8a6b-7c8d9e0f1a2b',
                'name': 'Teeth Cleaning',
                'price': '800.00',
                'duration_minutes': 45,
                'staff': {
                  'id': '0198f0f6-7081-7293-ae9f-1a2b3c4d5e6f',
                  'name': 'Dr. Sharma',
                },
              },
            ],
            'schedule': {
              'starts_at': '2026-10-12T10:30:00Z',
              'ends_at': '2026-10-12T11:15:00Z',
              'total_duration_minutes': 45,
            },
            'payment': {
              'subtotal': '800.00',
              'discount': '80.00',
              'total': '720.00',
              'currency_code': 'INR',
              'promo': {'code': 'FIRST10', 'label': '10% off'},
            },
            'cancellation': null,
            'rejection': null,
            'reschedule': null,
            'actions': {
              'can_reschedule': true,
              'can_cancel': true,
              'can_review': false,
            },
          }),
        )
        as Map<String, dynamic>;

void main() {
  group('BookingDetailsModel.fromJson', () {
    test('parses the documented sample response', () {
      final model = BookingDetailsModel.fromJson(_sample());

      expect(model.booking.reference, 'BK-7KQ4M2');
      expect(model.booking.tone, BookingTone.success);
      expect(model.booking.verificationCode, '482917');
      expect(model.business.distanceKm, 1.2);
      expect(model.business.closesAt, '20:00');
      expect(model.business.location.directionsUrl, isNotNull);
      expect(model.services, hasLength(1));
      expect(model.services.single.price, '800.00');
      expect(model.services.single.staff?.name, 'Dr. Sharma');
      expect(model.schedule.startsAt, DateTime.utc(2026, 10, 12, 10, 30));
      expect(model.schedule.totalDurationMinutes, 45);
      expect(model.payment.total, '720.00');
      expect(model.payment.format(model.payment.total), '₹720.00');
      expect(model.payment.hasDiscount, isTrue);
      expect(model.payment.promo?.label, '10% off');
      expect(model.cancellation, isNull);
      expect(model.actions.any, isTrue);
    });

    test('handles every nullable value being null and a cancellation', () {
      final json = _sample();
      json['booking']['status'] = 'cancelled';
      json['booking']['tone'] = 'danger';
      json['booking']['verification_code'] = null;
      json['business']['thumbnail_url'] = null;
      json['business']['distance_km'] = null;
      json['business']['closes_at'] = null;
      json['business']['location'] = <String, dynamic>{
        for (final key
            in (json['business']['location'] as Map<String, dynamic>).keys)
          key: null,
      };
      json['services'] = [
        for (final s in json['services'] as List) {...s, 'staff': null},
        {
          'id': 'b',
          'name': 'Whitening',
          'price': '1500.50',
          'duration_minutes': 30,
          'staff': null,
        },
      ];
      json['payment']['discount'] = '0.00';
      json['payment']['promo'] = null;
      json['cancellation'] = {
        'cancelled_by': 'business',
        'cancelled_at': '2026-10-11T08:00:00Z',
        'reason': null,
        'fee': '0.00',
      };
      json['actions'] = {
        'can_reschedule': false,
        'can_cancel': false,
        'can_review': false,
      };

      final model = BookingDetailsModel.fromJson(_asResponse(json));

      expect(model.booking.verificationCode, isNull);
      expect(model.business.thumbnailUrl, isNull);
      expect(model.business.distanceKm, isNull);
      expect(model.business.location.latitude, isNull);
      expect(model.business.location.directionsUrl, isNull);
      expect(model.services, hasLength(2));
      expect(model.services.every((s) => s.staff == null), isTrue);
      expect(model.services.last.price, '1500.50');
      expect(model.payment.hasDiscount, isFalse);
      expect(model.payment.promo, isNull);
      expect(model.cancellation?.cancelledBy, 'business');
      expect(model.cancellation?.hasFee, isFalse);
      expect(model.actions.any, isFalse);
    });

    test('parses a reschedule block', () {
      final json = _sample();
      json['booking']['has_pending_reschedule'] = true;
      json['reschedule'] = {
        'status': 'pending',
        'requested_by': {'role': 'customer', 'name': 'Omkar'},
        'requested_at': '2026-10-10T08:00:00Z',
        'proposed_start': '2026-10-13T10:30:00Z',
        'proposed_end': '2026-10-13T11:15:00Z',
      };

      final reschedule = BookingDetailsModel.fromJson(
        _asResponse(json),
      ).reschedule!;

      expect(reschedule.status, 'pending');
      expect(reschedule.requestedByRole, 'customer');
      expect(reschedule.requestedByName, 'Omkar');
      expect(reschedule.proposedStart, DateTime.utc(2026, 10, 13, 10, 30));
    });
  });

  group('DateTimeUtils', () {
    test('formatFullDate', () {
      expect(
        DateTimeUtils.formatFullDate(DateTime(2026, 10, 2)),
        '02 Oct 2026',
      );
    });

    test('formatDuration', () {
      expect(DateTimeUtils.formatDuration(45), '45 mins');
      expect(DateTimeUtils.formatDuration(60), '1 hr');
      expect(DateTimeUtils.formatDuration(75), '1 hr 15 mins');
      expect(DateTimeUtils.formatDuration(150), '2 hrs 30 mins');
    });

    test('formatClockString', () {
      expect(DateTimeUtils.formatClockString('20:00'), '8 PM');
      expect(DateTimeUtils.formatClockString('20:30'), '8:30 PM');
      expect(DateTimeUtils.formatClockString('00:00'), '12 AM');
      expect(DateTimeUtils.formatClockString('12:15'), '12:15 PM');
      expect(DateTimeUtils.formatClockString('bad'), isNull);
    });
  });
}

/// Re-types a mutated fixture the way a decoded response would be.
Map<String, dynamic> _asResponse(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
