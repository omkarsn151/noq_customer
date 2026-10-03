import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/presentation/widgets/booking_status_label.dart';
import 'package:noq/features/dummy/service_slot.dart';

class BookingsTile extends StatelessWidget {
  final BookingModel booking;

  const BookingsTile({super.key, required this.booking});

  void _onTap(BuildContext context) {
    context.push('/booking-details/${booking.booking.id}');
  }

  void _onReschedule(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const ServiceSlot(isReschedule: true)),
    );
  }

  void _onCancel(BuildContext context) {
    AppSnackbar.info(context, 'Cancelling bookings is not available yet.');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final startsAt = booking.schedule.startsAt;
    final serviceLabel = booking.servicePreview.label;

    return InkWell(
      borderRadius: BorderRadius.circular(16.sp),
      onTap: () => _onTap(context),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
                  child: Image.asset(
                    AppAssets.businessThumbnail,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
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
                      SizedBox(height: 0.3.h),
                      Text(
                        'Haircut, Hair Color',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (booking.actions.hasAny)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.sp),
                    ),
                    color: Colors.white,
                    onSelected: (value) {
                      if (value == 'reschedule') {
                        _onReschedule(context);
                      } else if (value == 'cancel') {
                        _onCancel(context);
                      }
                    },
                    itemBuilder: (context) => [
                      if (booking.actions.canReschedule)
                        PopupMenuItem(
                          value: 'reschedule',
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 16.sp,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Reschedule Booking',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      if (booking.actions.canReschedule &&
                          booking.actions.canCancel)
                        const PopupMenuDivider(height: 1),
                      if (booking.actions.canCancel)
                        PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 16.sp,
                                color: AppColors.error,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Cancel Booking',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
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
                          : DateTimeUtils.formatBookingDateTime(startsAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                BookingStatusLabel(status: booking.booking.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
