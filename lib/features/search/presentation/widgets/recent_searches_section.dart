import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

const _recentSearches = [
  'City Health Clinic',
  'Barbershops near me',
  'DMV Walk-in',
];

class RecentSearchesSection extends StatelessWidget {
  const RecentSearchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Searches',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                'Clear',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          for (final search in _recentSearches)
            _RecentSearchTile(label: search),
        ],
      ),
    );
  }
}

class _RecentSearchTile extends StatelessWidget {
  final String label;

  const _RecentSearchTile({required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.4.h),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 17.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            Icon(
              Icons.north_west_rounded,
              size: 15.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
