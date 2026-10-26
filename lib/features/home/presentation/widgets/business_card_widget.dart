import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class BusinessCardWidget extends StatelessWidget {
  /// Remote thumbnail from the API; a placeholder is shown when null.
  final String? imageUrl;

  final String name;
  final String services;

  /// Hidden when null (shop has no live services).
  final String? priceRange;

  final double rating;

  /// When 0 the card shows "New" instead of stars; null keeps the plain
  /// average.
  final int? totalReviews;

  final String? address;
  final String? distance;

  /// Hidden when null (shop hasn't set its slot settings).
  final int? waitMinutes;

  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const BusinessCardWidget({
    super.key,
    this.imageUrl,
    required this.name,
    required this.services,
    this.priceRange,
    required this.rating,
    this.totalReviews,
    this.address,
    this.distance,
    this.waitMinutes,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = 5.w;
    final location = [address, distance].whereType<String>().join(' • ');

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(radius),
                  ),
                  child: _buildImage(),
                ),
                Positioned(
                  top: 2.5.w,
                  right: 2.5.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16.sp,
                        color: isFavorite
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(2.5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (priceRange != null) ...[
                        SizedBox(width: 2.w),
                        Text(
                          priceRange!,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 0.5.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          services,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      if (totalReviews == 0)
                        Text(
                          'New',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 17.sp,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              totalReviews == null
                                  ? rating.toStringAsFixed(1)
                                  : '${rating.toStringAsFixed(1)} ($totalReviews)',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  Divider(color: AppColors.borderLight, thickness: 1),

                  if (location.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            location,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (waitMinutes != null) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.7.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 15.sp,
                            color: AppColors.blue,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '$waitMinutes MIN WAIT',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    Widget placeholder() => Container(
      width: double.infinity,
      height: 20.h,
      color: AppColors.borderLight,
      child: Icon(
        Icons.storefront_outlined,
        size: 28.sp,
        color: AppColors.textSecondary,
      ),
    );

    final url = imageUrl;
    if (url == null) return placeholder();
    return Image.network(
      url,
      width: double.infinity,
      height: 20.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}
