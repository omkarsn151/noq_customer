import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noq/core/common/app_search_field.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 2.h,
              left: 5.w,
              right: 5.w,
              bottom: 1.5.h,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello Rohan',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: AppColors.background.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: AppColors.background,
                                size: 16.sp,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'San Francisco, CA',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.background,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: AppColors.background,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.background,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        hintText: 'Search clinics, barbers, DMV...',
                        onChanged: (value) {},
                        onClear: () {},
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.background),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: AppColors.background,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
