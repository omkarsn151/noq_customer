import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/search/data/search_result_model.dart';
import 'package:noq/features/search/data/search_service_model.dart';
import 'package:noq/features/search/presentation/widgets/search_section_header.dart';
import 'package:noq/features/search/presentation/widgets/search_service_tile.dart';

class SearchServicesSection extends StatelessWidget {
  final SearchGroup<SearchServiceItem> group;

  /// The query these results belong to; "See all" continues it.
  final String query;

  /// Called when a service is opened.
  final VoidCallback onSelected;

  const SearchServicesSection({
    super.key,
    required this.group,
    required this.query,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (group.isEmpty) return const SizedBox.shrink();

    final items = group.items;
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchSectionHeader(
            title: 'Services',
            total: group.total,
            onSeeAll: group.hasMore
                ? () {
                    onSelected();
                    context.push(
                      Uri(
                        path: '/search/services',
                        queryParameters: {'q': query},
                      ).toString(),
                    );
                  }
                : null,
          ),
          for (int i = 0; i < items.length; i++) ...[
            SearchServiceTile(service: items[i], onSelected: onSelected),
            if (i != items.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: const Divider(height: 1, color: AppColors.borderLight),
              ),
          ],
        ],
      ),
    );
  }
}
