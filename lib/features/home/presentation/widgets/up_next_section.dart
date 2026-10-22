import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/home/data/home_model.dart';

class UpNextSection extends StatelessWidget {
  final UpNextModel upNext;

  const UpNextSection({super.key, required this.upNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Up Next',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.5.h),
          _UpNextCard(upNext: upNext),
        ],
      ),
    );
  }
}

class _UpNextCard extends StatelessWidget {
  final UpNextModel upNext;

  const _UpNextCard({required this.upNext});

  @override
  Widget build(BuildContext context) {
    final business = upNext.business;
    final thumbnailUrl = business.thumbnailUrl;
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(5.w);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: radius,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 16),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      heightFactor: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (thumbnailUrl != null)
                            Image.network(
                              thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.background,
                                  Color(0x00FFFFFF),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upNext.isInProgress
                            ? 'In progress'
                            : DateTimeUtils.formatBookingDateTime(
                                upNext.startsAt,
                              ),
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        upNext.services.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: radius,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: radius,
                              // Not in the API yet — placeholder until it is.
                              child: Container(
                                width: 12.5.w,
                                height: 12.5.w,
                                color: AppColors.borderLight,
                                child: Icon(
                                  Icons.storefront_outlined,
                                  size: 18.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  business.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  business.categoryName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Details',
                      height: 5.5.h,
                      onPressed: () =>
                          context.push('/booking-details/${upNext.bookingId}'),
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: AppButton(
                      label: "I'm Here",
                      height: 5.5.h,
                      // No backend for check-in yet — only the shop starts a visit.
                      onPressed: null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
