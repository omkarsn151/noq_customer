import 'package:noq/features/bookings/data/booking_tab.dart';

/// Result of `POST v1/customer/bookings/{id}/cancel`.
class BookingCancelledModel {
  final String bookingId;
  final String status;
  final String cancelledBy;
  final DateTime? cancelledAt;
  final String? reason;
  final bool isLateCancellation;

  /// Kept as the server's string ("199.50"), like the payment amounts.
  final String feeAmount;
  final String currencyCode;

  /// Where the card was and where it now lives, from `tabs_hint`.
  final BookingTab? fromTab;
  final BookingTab? toTab;

  final String message;

  const BookingCancelledModel({
    required this.bookingId,
    required this.status,
    required this.cancelledBy,
    required this.cancelledAt,
    required this.reason,
    required this.isLateCancellation,
    required this.feeAmount,
    required this.currencyCode,
    required this.fromTab,
    required this.toTab,
    required this.message,
  });

  /// A fee is only worth mentioning when it is late *and* non-zero; the server
  /// sends "0.00" outside the cutoff or when the shop's percent is zero.
  bool get hasFee =>
      isLateCancellation && (double.tryParse(feeAmount) ?? 0) > 0;

  factory BookingCancelledModel.fromJson(
    Map<String, dynamic> json, {
    required String message,
  }) {
    final booking = json['booking'] as Map<String, dynamic>? ?? const {};
    final cancellation =
        json['cancellation'] as Map<String, dynamic>? ?? const {};
    final fee = cancellation['fee'] as Map<String, dynamic>? ?? const {};
    final tabsHint = json['tabs_hint'] as Map<String, dynamic>? ?? const {};

    return BookingCancelledModel(
      bookingId: booking['id'] as String? ?? '',
      status: booking['status'] as String? ?? '',
      cancelledBy: booking['cancelled_by'] as String? ?? '',
      cancelledAt: DateTime.tryParse(booking['cancelled_at'] as String? ?? ''),
      reason: cancellation['reason'] as String?,
      isLateCancellation:
          cancellation['is_late_cancellation'] as bool? ?? false,
      feeAmount: fee['amount'] as String? ?? '0.00',
      currencyCode: fee['currency_code'] as String? ?? '',
      fromTab: BookingTab.fromValue(tabsHint['from_tab'] as String?),
      toTab: BookingTab.fromValue(tabsHint['to_tab'] as String?),
      message: message,
    );
  }
}
