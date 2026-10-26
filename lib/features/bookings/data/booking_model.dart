import 'package:noq/features/bookings/data/booking_tone.dart';

class BookingModel {
  final BookingInfo booking;
  final BookingBusiness business;
  final List<BookingService> services;
  final BookingSchedule schedule;
  final BookingActions actions;

  const BookingModel({
    required this.booking,
    required this.business,
    required this.services,
    required this.schedule,
    required this.actions,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      booking: BookingInfo.fromJson(
        json['booking'] as Map<String, dynamic>? ?? const {},
      ),
      business: BookingBusiness.fromJson(
        json['business'] as Map<String, dynamic>? ?? const {},
      ),
      services: (json['services'] as List<dynamic>? ?? const [])
          .map((e) => BookingService.fromJson(e as Map<String, dynamic>))
          .toList(),
      schedule: BookingSchedule.fromJson(
        json['schedule'] as Map<String, dynamic>? ?? const {},
      ),
      actions: BookingActions.fromJson(
        json['actions'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  /// `Haircut, Hair Color`; empty when the booking lists no services.
  String get servicesLabel => services.map((s) => s.name).join(', ');

  // An in-progress booking can still report `can_reschedule` / `can_cancel`,
  // but the server rejects both (409), so they are hidden on that status.
  bool get showReschedule => actions.canReschedule && !booking.isInProgress;
  bool get showCancel => actions.canCancel && !booking.isInProgress;

  /// Whether the card's ⋮ menu has anything to offer.
  bool get hasMenu => showReschedule || showCancel || actions.canReview;
}

class BookingInfo {
  final String id;
  final String reference;

  /// Raw status, used only for behaviour (e.g. [isInProgress]). The badge
  /// prints [statusLabel] and [tone] so it matches Booking Details.
  final String status;
  final String statusLabel;
  final BookingTone tone;
  final String tab;
  final String? verificationCode;

  /// A time change is waiting on the shop; the schedule is still the old time.
  final bool hasPendingReschedule;
  final bool hasReviewed;

  const BookingInfo({
    required this.id,
    required this.reference,
    required this.status,
    required this.statusLabel,
    required this.tone,
    required this.tab,
    this.verificationCode,
    required this.hasPendingReschedule,
    required this.hasReviewed,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      id: json['id'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      tone: BookingTone.fromString(json['tone'] as String?),
      tab: json['tab'] as String? ?? '',
      verificationCode: json['verification_code'] as String?,
      hasPendingReschedule: json['has_pending_reschedule'] as bool? ?? false,
      hasReviewed: json['has_reviewed'] as bool? ?? false,
    );
  }

  bool get isInProgress => status == 'in_progress';
}

class BookingBusiness {
  final String id;
  final String name;

  /// Null when the shop has no photo.
  final String? thumbnailUrl;

  const BookingBusiness({
    required this.id,
    required this.name,
    this.thumbnailUrl,
  });

  factory BookingBusiness.fromJson(Map<String, dynamic> json) {
    return BookingBusiness(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}

class BookingService {
  final String id;
  final String name;

  const BookingService({required this.id, required this.name});

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class BookingSchedule {
  /// Null when the API omits or sends an unparseable timestamp.
  final DateTime? startsAt;

  const BookingSchedule({this.startsAt});

  factory BookingSchedule.fromJson(Map<String, dynamic> json) {
    return BookingSchedule(
      startsAt: DateTime.tryParse(json['starts_at'] as String? ?? ''),
    );
  }
}

class BookingActions {
  final bool canReschedule;
  final bool canCancel;

  /// True once the shop has served the visit, and stays true after reviewing.
  final bool canReview;

  const BookingActions({
    required this.canReschedule,
    required this.canCancel,
    required this.canReview,
  });

  factory BookingActions.fromJson(Map<String, dynamic> json) {
    return BookingActions(
      canReschedule: json['can_reschedule'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
      canReview: json['can_review'] as bool? ?? false,
    );
  }
}
