import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';

class _NearbyItem {
  final String image;
  final String? tag;
  final String name;
  final String services;
  final String priceRange;
  final double rating;
  final String address;
  final String distance;
  final int waitMinutes;

  const _NearbyItem({
    required this.image,
    this.tag,
    required this.name,
    required this.services,
    required this.priceRange,
    required this.rating,
    required this.address,
    required this.distance,
    required this.waitMinutes,
  });
}

class NearbySection extends StatelessWidget {
  const NearbySection({super.key});

  static const List<_NearbyItem> _items = [
    _NearbyItem(
      image: AppAssets.businessThumbnail,
      tag: '10% Off',
      name: 'Radiance & Elegance Studio',
      services: 'Haircuts, Make Up, Massage',
      priceRange: '\$50 - \$200',
      rating: 4.8,
      address: '4321 Parkside Blvd Miami, FL 33101',
      distance: '1.5 mi',
      waitMinutes: 12,
    ),
    _NearbyItem(
      image: AppAssets.businessThumbnail2,
      tag: 'Fast Track',
      name: 'QuickCare Clinic',
      services: 'Consultation, Vaccination',
      priceRange: '\$20 - \$80',
      rating: 4.6,
      address: '120 Main Street Miami, FL 33101',
      distance: '2.1 mi',
      waitMinutes: 8,
    ),
  ];

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
                'Fastest Nearby',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          for (final item in _items) ...[
            BusinessCardWidget(
              image: item.image,
              tag: item.tag,
              name: item.name,
              services: item.services,
              priceRange: item.priceRange,
              rating: item.rating,
              address: item.address,
              distance: item.distance,
              waitMinutes: item.waitMinutes,
            ),
            SizedBox(height: 2.h),
          ],
        ],
      ),
    );
  }
}
