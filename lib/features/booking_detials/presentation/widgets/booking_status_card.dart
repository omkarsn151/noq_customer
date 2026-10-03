import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';

class BookingStatusCard extends StatelessWidget {
  final String status;
  final String message;

  const BookingStatusCard({
    super.key,
    required this.status,
    required this.message,
  });

  ({IconData icon, Color color, String label}) get _style {
    switch (status.toLowerCase()) {
      case 'pending':
        return (
          icon: Icons.access_time_rounded,
          color: AppColors.primary,
          label: 'Pending',
        );
      case 'completed':
        return (
          icon: Icons.check_rounded,
          color: AppColors.blue,
          label: 'Completed',
        );
      case 'cancelled':
      case 'canceled':
        return (
          icon: Icons.close_rounded,
          color: AppColors.error,
          label: 'Cancelled',
        );
      default:
        return (
          icon: Icons.check_rounded,
          color: AppColors.success,
          label: 'Confirmed',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _style;

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Booking Status'),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Icon(style.icon, size: 18.sp, color: style.color),
              SizedBox(width: 3.w),
              Text(
                style.label,
                style: textTheme.bodyLarge?.copyWith(color: style.color),
              ),
            ],
          ),
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
      ),
    );
  }
}
