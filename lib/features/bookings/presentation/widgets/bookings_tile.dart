import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';
import 'package:noq/features/bookings/presentation/widgets/booking_status_label.dart';

class BookingsTile extends StatelessWidget {
  final BookingModel booking;

  const BookingsTile({super.key, required this.booking});

  void _onTap(BuildContext context) {
    context.push('/booking-details/${booking.booking.id}');
  }

  void _onReschedule(BuildContext context) {
    context.push('/reschedule-slot');
  }

  void _onCancel(BuildContext context) {
    AppSnackbar.info(context, 'Cancelling bookings is not available yet.');
  }

  void _onReview(BuildContext context) {
    AppSnackbar.info(context, 'Reviews are not available yet.');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final startsAt = booking.schedule.startsAt;
    final servicesLabel = booking.servicesLabel;

    return InkWell(
      borderRadius: BorderRadius.circular(16.sp),
      onTap: () => _onTap(context),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.sp),
                  child: _thumbnail(),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.business.name,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (servicesLabel.isNotEmpty) ...[
                        SizedBox(height: 0.3.h),
                        Text(
                          servicesLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (booking.booking.hasPendingReschedule) ...[
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 13.sp,
                              color: AppColors.orange,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Reschedule requested',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (booking.hasMenu) _menu(context),
              ],
            ),
            SizedBox(height: 1.5.h),
            Divider(height: 1, color: AppColors.borderLight),
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      startsAt == null
                          ? '--'
                          : DateTimeUtils.formatBookingDateTime(
                              startsAt,
                              // Today/Tomorrow only reads well on the to-do
                              // list; history tabs write the date out.
                              relative:
                                  booking.booking.tab ==
                                  BookingTab.upcoming.value,
                            ),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                BookingStatusLabel(
                  label: booking.booking.statusLabel,
                  tone: booking.booking.tone,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnail() {
    final url = booking.business.thumbnailUrl;
    if (url == null || url.isEmpty) return _fallbackThumbnail();
    return Image.network(
      url,
      width: 12.w,
      height: 12.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _fallbackThumbnail(),
    );
  }

  Widget _fallbackThumbnail() {
    return Image.asset(
      AppAssets.businessThumbnail,
      width: 12.w,
      height: 12.w,
      fit: BoxFit.cover,
    );
  }

  Widget _menu(BuildContext context) {
    final items = <PopupMenuEntry<String>>[
      if (booking.showReschedule)
        _menuItem(
          context,
          value: 'reschedule',
          icon: Icons.calendar_month_outlined,
          label: 'Reschedule Booking',
        ),
      if (booking.actions.canReview)
        _menuItem(
          context,
          value: 'review',
          icon: Icons.star_outline_rounded,
          label: booking.booking.hasReviewed ? 'Edit review' : 'Leave a review',
        ),
      if (booking.showCancel)
        _menuItem(
          context,
          value: 'cancel',
          icon: Icons.cancel_outlined,
          label: 'Cancel Booking',
          color: AppColors.error,
        ),
    ];

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.sp),
      ),
      menuPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      color: AppColors.background,
      surfaceTintColor: AppColors.background,
      elevation: 4,
      shadowColor: AppColors.borderLight,
      position: PopupMenuPosition.under,
      icon: Icon(Icons.more_vert, size: 18.sp, color: AppColors.textPrimary),
      onSelected: (value) {
        switch (value) {
          case 'reschedule':
            _onReschedule(context);
          case 'review':
            _onReview(context);
          case 'cancel':
            _onCancel(context);
        }
      },
      itemBuilder: (context) => [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const PopupMenuDivider(height: 1, color: AppColors.border),
          items[i],
        ],
      ],
    );
  }

  PopupMenuItem<String> _menuItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    Color color = AppColors.textPrimary,
  }) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 2.w),
          Text(
            label,
            style: color == AppColors.textPrimary
                ? textStyle
                : textStyle?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
