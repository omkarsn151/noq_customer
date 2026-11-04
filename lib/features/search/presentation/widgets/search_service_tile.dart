import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/search/data/search_service_model.dart';

/// A service found by search. Shows which shop offers it, because a service
/// name alone doesn't tell the customer where to go.
class SearchServiceTile extends StatelessWidget {
  final SearchServiceItem service;

  /// Called just before the service screen is opened.
  final VoidCallback? onSelected;

  const SearchServiceTile({super.key, required this.service, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        onSelected?.call();
        context.push(
          '/business-details/${service.business.id}/services/${service.id}',
        );
      },
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
                Text(
                  service.name,
                  style: textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.4.h),
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        service.business.name,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.6.h),
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
      height: 18.w,
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
      height: 18.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}
