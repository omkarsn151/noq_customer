import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';
import 'package:noq/features/favorites/bloc/favorite_bloc.dart';
import 'package:noq/features/favorites/bloc/favorite_event.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';
import 'package:noq/features/search/data/search_result_model.dart';
import 'package:noq/features/search/presentation/widgets/search_section_header.dart';

/// Matching shops, drawn with the same card as Home and the browse screens.
class SearchBusinessesSection extends StatelessWidget {
  final SearchGroup<BusinessListModel> group;

  /// The query these results belong to; "See all" continues it.
  final String query;

  /// Called when a shop is opened.
  final VoidCallback onSelected;

  const SearchBusinessesSection({
    super.key,
    required this.group,
    required this.query,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (group.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchSectionHeader(
          title: 'Shops',
          total: group.total,
          onSeeAll: group.hasMore
              ? () {
                  onSelected();
                  context.push(
                    Uri(
                      path: '/search/businesses',
                      queryParameters: {'q': query},
                    ).toString(),
                  );
                }
              : null,
        ),
        // Each card carries its own bottom gap, which also spaces the section.
        for (final item in group.items) ...[
          BusinessCardWidget(
            imageUrl: item.thumbnailUrl,
            name: item.name,
            services: item.servicesLabel,
            priceRange: item.pricing?.priceLabel,
            rating: item.rating.average,
            totalReviews: item.rating.totalReviews,
            address: item.address,
            // Search takes no coordinates, so there is never a distance.
            distance: null,
            waitMinutes: item.waitMinutes,
            isFavorite: item.isFavorited,
            onFavoriteTap: () => context.read<FavoriteBloc>().add(
              FavoriteToggled(
                businessId: item.id,
                isFavorited: item.isFavorited,
              ),
            ),
            onTap: () {
              onSelected();
              context.push('/business-details/${item.id}');
            },
          ),
          SizedBox(height: 3.h),
        ],
      ],
    );
  }
}
