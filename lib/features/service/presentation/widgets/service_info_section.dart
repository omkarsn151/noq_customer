import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/service/data/service_details_model.dart';

class ServiceInfoSection extends StatelessWidget {
  final ServiceDetailsModel service;

  const ServiceInfoSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = service.description;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service.name, style: textTheme.displayLarge),
          if (service.business.name.isNotEmpty) ...[
            SizedBox(height: 0.5.h),
            Text(
              service.business.name,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20.sp),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${service.durationMinutes} min',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Hidden when the shop has not written one.
          if (description != null && description.isNotEmpty) ...[
            SizedBox(height: 2.5.h),
            Text('About this service', style: textTheme.titleMedium),
            SizedBox(height: 1.h),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
