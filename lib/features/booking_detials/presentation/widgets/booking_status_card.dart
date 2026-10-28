import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';
import 'package:noq/features/bookings/data/booking_tone.dart';
import 'package:noq/features/bookings/presentation/widgets/booking_status_label.dart';

/// [label] and [message] are the server's `status_label` / `status_message`,
/// printed as-is; [tone] alone picks the colour.
class BookingStatusCard extends StatelessWidget {
  final String label;
  final String message;
  final BookingTone tone;

  const BookingStatusCard({
    super.key,
    required this.label,
    required this.message,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (icon, color) = BookingStatusLabel.styleOf(tone);

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Booking Status'),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Icon(icon, size: 18.sp, color: color),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(color: color),
                ),
              ),
            ],
          ),
          if (message.isNotEmpty) ...[
            SizedBox(height: 0.6.h),
            Padding(
              padding: EdgeInsets.only(left: 9.w),
              child: Text(
                message,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
