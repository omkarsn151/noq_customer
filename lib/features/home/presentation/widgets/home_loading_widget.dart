import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/categories/data/category_model.dart';
import 'package:noq/features/home/data/home_model.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';
import 'package:noq/features/home/presentation/widgets/categories_section.dart';

/// Placeholder Home content shaped like the categories grid and nearby list
/// while the Home payload is loading.
class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  static const _category = CategoryModel(
    id: '',
    name: 'Category',
    description: 'Category description',
    imageUrl: null,
  );

  static const _categories = HomeCategoriesModel(
    total: 4,
    items: [_category, _category, _category, _category],
  );

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    );

    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoriesSection(categories: _categories),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fastest Nearby', style: titleStyle),
                SizedBox(height: 1.5.h),
                for (var i = 0; i < 2; i++) ...[
                  const BusinessCardWidget(
                    name: 'Business name placeholder',
                    services: 'Service one, Service two',
                    priceRange: '₹000 - ₹000',
                    rating: 4.5,
                    totalReviews: 10,
                    address: 'Area, City',
                    distance: '0.0 km',
                    waitMinutes: 10,
                  ),
                  SizedBox(height: 2.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
