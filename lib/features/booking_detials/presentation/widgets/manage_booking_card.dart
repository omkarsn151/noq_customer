import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';

/// Rows are drawn from the server's [actions]; the caller hides the whole
/// card when none apply.
class ManageBookingCard extends StatelessWidget {
  final BookingDetailsActions actions;

  /// Picks "Edit review" over "Leave a review".
  final bool hasReviewed;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onReview;

  const ManageBookingCard({
    super.key,
    required this.actions,
    required this.hasReviewed,
    this.onReschedule,
    this.onCancel,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      if (actions.canReschedule)
        _ManageRow(
          icon: Icons.calendar_month_outlined,
          label: 'Reschedule Booking',
          onTap: onReschedule,
        ),
      if (actions.canReview)
        _ManageRow(
          icon: Icons.rate_review_outlined,
          label: hasReviewed ? 'Edit review' : 'Leave a review',
          onTap: onReview,
        ),
      if (actions.canCancel)
        _ManageRow(
          icon: Icons.cancel_outlined,
          label: 'Cancel Booking',
          color: AppColors.error,
          onTap: onCancel,
        ),
    ];

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Manage Booking'),
          SizedBox(height: 1.h),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight,
              ),
            rows[i],
          ],
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
