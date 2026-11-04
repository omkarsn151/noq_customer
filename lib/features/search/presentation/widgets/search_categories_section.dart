import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/features/categories/data/category_model.dart';
import 'package:noq/features/categories/presentation/widgets/category_card.dart';
import 'package:noq/features/search/data/search_result_model.dart';
import 'package:noq/features/search/presentation/widgets/search_section_header.dart';

/// Matching categories. Never has "See all": the preview already holds every
/// match.
class SearchCategoriesSection extends StatelessWidget {
  final SearchGroup<CategoryModel> group;

  /// Called when a category is opened.
  final VoidCallback onSelected;

  const SearchCategoriesSection({
    super.key,
    required this.group,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (group.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchSectionHeader(title: 'Categories', total: group.total),
          CategoryGrid(items: group.items, onSelected: (_) => onSelected()),
        ],
      ),
    );
  }
}
