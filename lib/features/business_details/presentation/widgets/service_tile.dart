import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class ServiceItem {
  final String name;
  final String description;
  final int durationMinutes;
  final int price;
  final String thumbnail;

  const ServiceItem({
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    this.thumbnail = AppAssets.serviceThumbnail,
  });
}

class ServiceTile extends StatelessWidget {
  final ServiceItem service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push('/service-details'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: Image.asset(
              service.thumbnail,
              width: 18.w,
              height: 25.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: textTheme.bodyLarge),
                SizedBox(height: 0.4.h),
                Text(
                  service.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Text(
                        '${service.durationMinutes} min',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const _AddToCartButton(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Text('₹${service.price}', style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Text(
        'ADD TO CART',
        style: Theme.of(
          context,
        ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
