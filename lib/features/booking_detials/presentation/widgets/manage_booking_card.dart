import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';

class ManageBookingCard extends StatelessWidget {
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const ManageBookingCard({super.key, this.onReschedule, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Manage Booking'),
          SizedBox(height: 1.h),
          _ManageRow(
            icon: Icons.calendar_month_outlined,
            label: 'Reschedule Booking',
            onTap: onReschedule,
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.borderLight),
          _ManageRow(
            icon: Icons.cancel_outlined,
            label: 'Cancel Booking',
            color: AppColors.error,
            onTap: onCancel,
          ),
        ],
      ),
    );
  }
}

class _ManageRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _ManageRow({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: color ?? AppColors.textSecondary),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
