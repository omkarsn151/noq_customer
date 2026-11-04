import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/search/data/quick_filter_model.dart';

/// Category chips. A chip is an exact category filter, not a text search, so
/// tapping one opens that category's shops and never touches the search box.
class QuickFiltersSection extends StatelessWidget {
  final List<QuickFilterModel> filters;

  const QuickFiltersSection({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    // No chips means the platform has no public shops: hide the whole row.
    if (filters.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Filters',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.5.h),
          Wrap(
            spacing: 2.5.w,
            runSpacing: 1.2.h,
            children: [
              for (final filter in filters)
                _FilterChip(
                  label: filter.label,
                  onTap: () => context.push(
                    '/categories/${filter.categoryId}/businesses',
                    extra: filter.label,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.sp),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20.sp),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
