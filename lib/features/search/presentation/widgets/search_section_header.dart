import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

/// Title of a search result group, with "See all [total]" when the preview
/// holds only some of the matches.
class SearchSectionHeader extends StatelessWidget {
  final String title;
  final int total;

  /// Null hides "See all" — pass it only when `group.hasMore`.
  final VoidCallback? onSeeAll;

  const SearchSectionHeader({
    super.key,
    required this.title,
    required this.total,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSeeAll = this.onSeeAll;

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (onSeeAll != null)
            InkWell(
              onTap: onSeeAll,
              child: Text(
                'See all $total',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
