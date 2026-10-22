import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/categories/presentation/widgets/category_card.dart';
import 'package:noq/features/home/data/home_model.dart';

class CategoriesSection extends StatelessWidget {
  final HomeCategoriesModel categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              if (categories.hasMore)
                GestureDetector(
                  onTap: () => context.push('/categories'),
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
          CategoryGrid(items: categories.items),
        ],
      ),
    );
  }
}
