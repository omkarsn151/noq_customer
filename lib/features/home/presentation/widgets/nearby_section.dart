import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/home/data/home_model.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';

class NearbySection extends StatelessWidget {
  final HomeNearbyModel nearby;

  const NearbySection({super.key, required this.nearby});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nearby.isSortedByDistance ? 'Fastest Nearby' : 'Top Rated',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          if (nearby.items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No businesses found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          for (final item in nearby.items) ...[
            BusinessCardWidget(
              imageUrl: item.thumbnailUrl,
              name: item.name,
              services: item.servicesLabel,
              priceRange: item.pricing?.priceLabel,
              rating: item.rating.average,
              totalReviews: item.rating.totalReviews,
              address: item.address,
              distance: item.distanceLabel,
              waitMinutes: item.waitMinutes,
              isFavorite: item.isFavorited,
              onTap: () => context.push('/business-details/${item.id}'),
            ),
            SizedBox(height: 2.h),
          ],
        ],
      ),
    );
  }
}
