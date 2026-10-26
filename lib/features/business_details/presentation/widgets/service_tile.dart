import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';

class ServiceTile extends StatelessWidget {
  final BusinessServiceModel service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = service.description;

    return InkWell(
      onTap: () => context.push('/service-details'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: _buildThumbnail(),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: textTheme.bodyLarge),
                if (description != null && description.isNotEmpty) ...[
                  SizedBox(height: 0.4.h),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
                    _AddToCartButton(isInCart: service.isInCart),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Text(service.pricing.label, style: textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    Widget placeholder() => Container(
      width: 18.w,
      height: 25.w,
      color: AppColors.borderLight,
      child: Icon(
        Icons.content_cut_rounded,
        size: 18.sp,
        color: AppColors.textSecondary,
      ),
    );

    final url = service.thumbnailUrl;
    if (url == null) return placeholder();
    return Image.network(
      url,
      width: 18.w,
      height: 25.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}

/// Display only for now; add/remove is wired up in a later change.
class _AddToCartButton extends StatelessWidget {
  final bool isInCart;

  const _AddToCartButton({required this.isInCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Text(
        isInCart ? 'REMOVE' : 'ADD TO CART',
        style: Theme.of(
          context,
        ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
