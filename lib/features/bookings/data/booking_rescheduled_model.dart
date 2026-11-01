/// What the server did with a reschedule. Always branch on this, never on
/// whether `scheduled_start` changed: for [requestPending] the schedule is
/// still the old one.
enum RescheduleOutcome {
  moved('moved'),
  requestPending('request_pending'),
  unchanged('unchanged');

  final String value;

  const RescheduleOutcome(this.value);

  /// Unknown values fall back to [requestPending]: assuming the booking did
  /// NOT move is the safe misread.
  static RescheduleOutcome fromValue(String? value) {
    for (final outcome in values) {
      if (outcome.value == value) return outcome;
    }
    return requestPending;
  }
}

/// Result of `POST v1/customer/bookings/{id}/reschedule`.
class BookingRescheduledModel {
  final String bookingId;

  /// "auto" or "manual".
  final String approvalMode;

  /// The new time when [outcome] is `moved`, the old one otherwise.
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;

  /// "Anyone" when the customer has no preference.
  final String? requestedStaffName;

  final RescheduleOutcome outcome;
  final DateTime? previousStart;
  final DateTime? previousEnd;

  /// The asked-for time; only set for `request_pending`.
  final DateTime? proposedStart;
  final DateTime? proposedEnd;

  final String message;

  const BookingRescheduledModel({
    required this.bookingId,
    required this.approvalMode,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.requestedStaffName,
    required this.outcome,
    required this.previousStart,
    required this.previousEnd,
    required this.proposedStart,
    required this.proposedEnd,
    required this.message,
  });

  factory BookingRescheduledModel.fromJson(
    Map<String, dynamic> json, {
    required String message,
  }) {
    final booking = json['booking'] as Map<String, dynamic>? ?? const {};
    final schedule = json['schedule'] as Map<String, dynamic>? ?? const {};
    final staff = json['staff'] as Map<String, dynamic>? ?? const {};
    final reschedule = json['reschedule'] as Map<String, dynamic>? ?? const {};
    final request = reschedule['request'] as Map<String, dynamic>? ?? const {};

    return BookingRescheduledModel(
      bookingId: booking['id'] as String? ?? '',
      approvalMode: booking['approval_mode'] as String? ?? '',
      scheduledStart: _date(schedule['scheduled_start']),
      scheduledEnd: _date(schedule['scheduled_end']),
      requestedStaffName: staff['requested_staff_name'] as String?,
      outcome: RescheduleOutcome.fromValue(reschedule['outcome'] as String?),
      previousStart: _date(reschedule['previous_start']),
      previousEnd: _date(reschedule['previous_end']),
      proposedStart: _date(request['proposed_start']),
      proposedEnd: _date(request['proposed_end']),
      message: message,
    );
  }

  static DateTime? _date(Object? value) =>
      DateTime.tryParse(value as String? ?? '');
}
