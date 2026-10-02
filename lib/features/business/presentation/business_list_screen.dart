import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';

class _BusinessItem {
  final String image;
  final String? tag;
  final String name;
  final String services;
  final String priceRange;
  final double rating;
  final String address;
  final String distance;
  final int waitMinutes;

  const _BusinessItem({
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

class BusinessListScreen extends StatelessWidget {
  final String categoryName;

  const BusinessListScreen({super.key, required this.categoryName});

  static const List<_BusinessItem> _items = [
    _BusinessItem(
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
    _BusinessItem(
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
    return Scaffold(
      appBar: AppAppBar(title: categoryName),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
        itemCount: _items.length,
        separatorBuilder: (_, _) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final item = _items[index];
          return BusinessCardWidget(
            image: item.image,
            tag: item.tag,
            name: item.name,
            services: item.services,
            priceRange: item.priceRange,
            rating: item.rating,
            address: item.address,
            distance: item.distance,
            waitMinutes: item.waitMinutes,
          );
        },
      ),
    );
  }
}
