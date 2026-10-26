import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/bookings/data/booking_tone.dart';

/// Icon + label pair for a booking's status. [label] is printed as given and
/// [tone] alone picks the colour, so the list and Booking Details agree.
class BookingStatusLabel extends StatelessWidget {
  final String label;
  final BookingTone tone;

  const BookingStatusLabel({
    super.key,
    required this.label,
    required this.tone,
  });

  /// For responses that only carry a raw `status` (e.g. the booking just
  /// created). Uses the same wording the server sends as `status_label`.
  factory BookingStatusLabel.fromStatus(String status, {Key? key}) {
    final (label, tone) = switch (status.toLowerCase()) {
      'pending' => ('Pending', BookingTone.info),
      'confirmed' => ('Confirmed', BookingTone.success),
      'in_progress' => ('In progress', BookingTone.info),
      'completed' => ('Completed', BookingTone.success),
      'no_show' => ('Missed', BookingTone.warning),
      'cancelled' || 'canceled' => ('Cancelled', BookingTone.danger),
      'rejected' => ('Declined', BookingTone.danger),
      'dismissed' => ('Expired', BookingTone.warning),
      _ => (_titleCase(status), BookingTone.info),
    };
    return BookingStatusLabel(key: key, label: label, tone: tone);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (icon, color) = switch (tone) {
      BookingTone.success => (Icons.check_circle_rounded, AppColors.success),
      BookingTone.info => (Icons.access_time_rounded, AppColors.blue),
      BookingTone.warning => (Icons.error_outline_rounded, AppColors.orange),
      BookingTone.danger => (Icons.cancel_rounded, AppColors.error),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: color),
        SizedBox(width: 1.w),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return 'Unknown';
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
