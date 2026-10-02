import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class CategoryItem {
  final String title;
  final String subtitle;
  final String image;

  const CategoryItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

const List<CategoryItem> categoryItems = [
  CategoryItem(
    title: 'Haircuts',
    subtitle: 'Quick trims',
    image: AppAssets.category1,
  ),
  CategoryItem(
    title: 'Health',
    subtitle: 'Clinic walk-ins',
    image: AppAssets.category2,
  ),
  CategoryItem(
    title: 'Auto Care',
    subtitle: 'Oil & repairs',
    image: AppAssets.category3,
  ),
  CategoryItem(
    title: 'SPA',
    subtitle: 'Rejuvenate',
    image: AppAssets.category4,
  ),
];

class CategoryGrid extends StatelessWidget {
  final List<CategoryItem> items;

  const CategoryGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) => CategoryCard(item: items[index]),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryItem item;

  const CategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(5.w),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 16),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.w),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(item.image, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.background,
                    AppColors.background,
                    Color(0x00FFFFFF),
                  ],
                  stops: [0.0, 0.3, 0.75],
                ),
              ),
            ),
            Positioned(
              left: 4.w,
              right: 3.w,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
