import 'package:noq/features/bookings/data/booking_tone.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';

/// `GET /customer/bookings/{id}` — everything the Booking Details screen shows.
///
/// Keys are always present; the nullable blocks ([cancellation], [rejection],
/// [reschedule]) are null unless they apply.
class BookingDetailsModel {
  final BookingDetailsInfo booking;
  final BookingDetailsBusiness business;

  /// Every service in the booking — render a row per entry.
  final List<BookingDetailsService> services;
  final BookingDetailsSchedule schedule;
  final BookingDetailsPayment payment;
  final BookingCancellation? cancellation;
  final BookingRejection? rejection;
  final BookingReschedule? reschedule;
  final BookingDetailsActions actions;

  const BookingDetailsModel({
    required this.booking,
    required this.business,
    required this.services,
    required this.schedule,
    required this.payment,
    required this.cancellation,
    required this.rejection,
    required this.reschedule,
    required this.actions,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    final cancellation = json['cancellation'] as Map<String, dynamic>?;
    final rejection = json['rejection'] as Map<String, dynamic>?;
    final reschedule = json['reschedule'] as Map<String, dynamic>?;
    return BookingDetailsModel(
      booking: BookingDetailsInfo.fromJson(
        json['booking'] as Map<String, dynamic>? ?? const {},
      ),
      business: BookingDetailsBusiness.fromJson(
        json['business'] as Map<String, dynamic>? ?? const {},
      ),
      services: (json['services'] as List<dynamic>? ?? const [])
          .map((e) => BookingDetailsService.fromJson(e as Map<String, dynamic>))
          .toList(),
      schedule: BookingDetailsSchedule.fromJson(
        json['schedule'] as Map<String, dynamic>? ?? const {},
      ),
      payment: BookingDetailsPayment.fromJson(
        json['payment'] as Map<String, dynamic>? ?? const {},
      ),
      cancellation: cancellation == null
          ? null
          : BookingCancellation.fromJson(cancellation),
      rejection: rejection == null
          ? null
          : BookingRejection.fromJson(rejection),
      reschedule: reschedule == null
          ? null
          : BookingReschedule.fromJson(reschedule),
      actions: BookingDetailsActions.fromJson(
        json['actions'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class BookingDetailsInfo {
  final String id;

  /// e.g. `BK-7KQ4M2` — the header and the Booking Reference row.
  final String reference;
  final String status;

  /// Server-written copy — print as-is, never derive from [status].
  final String statusLabel;
  final String statusMessage;
  final BookingTone tone;

  /// Null outside `confirmed` / `in_progress` — hide the code card.
  final String? verificationCode;
  final bool hasPendingReschedule;
  final bool hasReviewed;

  const BookingDetailsInfo({
    required this.id,
    required this.reference,
    required this.status,
    required this.statusLabel,
    required this.statusMessage,
    required this.tone,
    required this.verificationCode,
    required this.hasPendingReschedule,
    required this.hasReviewed,
  });

  factory BookingDetailsInfo.fromJson(Map<String, dynamic> json) =>
      BookingDetailsInfo(
        id: json['id'] as String? ?? '',
        reference: json['reference'] as String? ?? '',
        status: json['status'] as String? ?? '',
        statusLabel: json['status_label'] as String? ?? '',
        statusMessage: json['status_message'] as String? ?? '',
        tone: BookingTone.fromString(json['tone'] as String?),
        verificationCode: json['verification_code'] as String?,
        hasPendingReschedule: json['has_pending_reschedule'] as bool? ?? false,
        hasReviewed: json['has_reviewed'] as bool? ?? false,
      );
}

class BookingDetailsBusiness {
  final String id;
  final String name;
  final String? thumbnailUrl;
  final BusinessDetailsLocation location;

  /// Null when no GPS was sent or the shop has no map pin — hide the line.
  final double? distanceKm;

  /// Closing time on the booking's day as `HH:MM` in the shop's timezone.
  /// Null when closed that day or hours are unset — hide the line.
  final String? closesAt;

  const BookingDetailsBusiness({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.location,
    required this.distanceKm,
    required this.closesAt,
  });

  factory BookingDetailsBusiness.fromJson(Map<String, dynamic> json) =>
      BookingDetailsBusiness(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String?,
        location: BusinessDetailsLocation.fromJson(
          json['location'] as Map<String, dynamic>? ?? const {},
        ),
        distanceKm: (json['distance_km'] as num?)?.toDouble(),
        closesAt: json['closes_at'] as String?,
      );
}

/// One booked service. [price] and [durationMinutes] are frozen at booking
/// time — don't refresh them from the catalogue.
class BookingDetailsService {
  final String id;
  final String name;

  /// Decimal string as sent by the server, e.g. '800.00'.
  final String price;
  final int durationMinutes;

  /// The staff the customer *requested*; null means Anyone.
  final BookingStaff? staff;

  const BookingDetailsService({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.staff,
  });

  factory BookingDetailsService.fromJson(Map<String, dynamic> json) {
    final staff = json['staff'] as Map<String, dynamic>?;
    return BookingDetailsService(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      durationMinutes: (json['duration_minutes'] as num? ?? 0).toInt(),
      staff: staff == null ? null : BookingStaff.fromJson(staff),
    );
  }
}

class BookingStaff {
  final String id;
  final String name;

  const BookingStaff({required this.id, required this.name});

  factory BookingStaff.fromJson(Map<String, dynamic> json) => BookingStaff(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
  );
}

class BookingDetailsSchedule {
  /// UTC — convert to local before display.
  final DateTime? startsAt;
  final DateTime? endsAt;

  /// The whole visit, all services added up.
  final int totalDurationMinutes;

  const BookingDetailsSchedule({
    required this.startsAt,
    required this.endsAt,
    required this.totalDurationMinutes,
  });

  factory BookingDetailsSchedule.fromJson(Map<String, dynamic> json) =>
      BookingDetailsSchedule(
        startsAt: DateTime.tryParse(json['starts_at'] as String? ?? ''),
        endsAt: DateTime.tryParse(json['ends_at'] as String? ?? ''),
        totalDurationMinutes: (json['total_duration_minutes'] as num? ?? 0)
            .toInt(),
      );
}

/// No paid / unpaid state exists — money changes hands at the shop.
class BookingDetailsPayment {
  /// Decimal strings as sent by the server, e.g. '800.00'.
  final String subtotal;
  final String discount;
  final String total;
  final String currencyCode;
  final BookingPromo? promo;

  const BookingDetailsPayment({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.currencyCode,
    required this.promo,
  });

  factory BookingDetailsPayment.fromJson(Map<String, dynamic> json) {
    final promo = json['promo'] as Map<String, dynamic>?;
    return BookingDetailsPayment(
      subtotal: json['subtotal'] as String? ?? '0',
      discount: json['discount'] as String? ?? '0',
      total: json['total'] as String? ?? '0',
      currencyCode: json['currency_code'] as String? ?? '',
      promo: promo == null ? null : BookingPromo.fromJson(promo),
    );
  }

  /// Hide the Discount row when this is false.
  bool get hasDiscount => (double.tryParse(discount) ?? 0) > 0;

  /// The amount exactly as sent, prefixed with the currency: '₹800.00'.
  String format(String amount) => switch (currencyCode) {
    'INR' => '₹$amount',
    '' => amount,
    _ => '$currencyCode $amount',
  };
}

class BookingPromo {
  final String code;

  /// Ready to print, e.g. `10% off`.
  final String label;

  const BookingPromo({required this.code, required this.label});

  factory BookingPromo.fromJson(Map<String, dynamic> json) => BookingPromo(
    code: json['code'] as String? ?? '',
    label: json['label'] as String? ?? '',
  );
}

class BookingCancellation {
  /// `customer` or `business`.
  final String cancelledBy;
  final DateTime? cancelledAt;
  final String? reason;
  final String fee;

  const BookingCancellation({
    required this.cancelledBy,
    required this.cancelledAt,
    required this.reason,
    required this.fee,
  });

  factory BookingCancellation.fromJson(Map<String, dynamic> json) =>
      BookingCancellation(
        cancelledBy: json['cancelled_by'] as String? ?? '',
        cancelledAt: DateTime.tryParse(json['cancelled_at'] as String? ?? ''),
        reason: json['reason'] as String?,
        fee: json['fee'] as String? ?? '0',
      );

  /// Hide the fee line when this is false (normally '0.00').
  bool get hasFee => (double.tryParse(fee) ?? 0) > 0;
}

class BookingRejection {
  final String? reason;

  const BookingRejection({required this.reason});

  factory BookingRejection.fromJson(Map<String, dynamic> json) =>
      BookingRejection(reason: json['reason'] as String?);
}

class BookingReschedule {
  /// `pending`, `approved` or `rejected`.
  final String status;

  /// `customer` or `business`.
  final String requestedByRole;
  final String requestedByName;
  final DateTime? requestedAt;
  final DateTime? proposedStart;
  final DateTime? proposedEnd;

  const BookingReschedule({
    required this.status,
    required this.requestedByRole,
    required this.requestedByName,
    required this.requestedAt,
    required this.proposedStart,
    required this.proposedEnd,
  });

  factory BookingReschedule.fromJson(Map<String, dynamic> json) {
    final requestedBy =
        json['requested_by'] as Map<String, dynamic>? ?? const {};
    return BookingReschedule(
      status: json['status'] as String? ?? '',
      requestedByRole: requestedBy['role'] as String? ?? '',
      requestedByName: requestedBy['name'] as String? ?? '',
      requestedAt: DateTime.tryParse(json['requested_at'] as String? ?? ''),
      proposedStart: DateTime.tryParse(json['proposed_start'] as String? ?? ''),
      proposedEnd: DateTime.tryParse(json['proposed_end'] as String? ?? ''),
    );
  }
}

/// The server's live answer for the Manage Booking rows.
class BookingDetailsActions {
  final bool canReschedule;
  final bool canCancel;
  final bool canReview;

  const BookingDetailsActions({
    required this.canReschedule,
    required this.canCancel,
    required this.canReview,
  });

  factory BookingDetailsActions.fromJson(Map<String, dynamic> json) =>
      BookingDetailsActions(
        canReschedule: json['can_reschedule'] as bool? ?? false,
        canCancel: json['can_cancel'] as bool? ?? false,
        canReview: json['can_review'] as bool? ?? false,
      );

  /// Hide the whole Manage Booking card when false.
  bool get any => canReschedule || canCancel || canReview;
}
