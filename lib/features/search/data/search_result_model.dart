import 'package:noq/features/categories/data/category_model.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';
import 'package:noq/features/search/data/search_service_model.dart';

/// One result group of the search preview. [items] is capped by the server;
/// [total] is the real number of matches.
class SearchGroup<T> {
  final int total;
  final List<T> items;

  const SearchGroup({required this.total, required this.items});

  const SearchGroup.empty() : total = 0, items = const [];

  /// A missing group is read as empty rather than failing the whole search.
  factory SearchGroup.fromJson(
    Map<String, dynamic>? json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    if (json == null) return SearchGroup<T>.empty();
    return SearchGroup(
      total: (json['total'] as num? ?? 0).toInt(),
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get isEmpty => total == 0;

  /// The preview holds only some of the matches — show "See all [total]".
  bool get hasMore => total > items.length;
}

/// `GET /customer/search?q=…` — a grouped preview, not the full list.
class SearchResultModel {
  /// The query that produced these results. Compare it with the search box
  /// to drop responses that arrive out of order.
  final String query;

  final SearchGroup<CategoryModel> categories;

  /// Same shop card as Home and the browse screens. `distanceKm` is always
  /// null here, because search takes no coordinates.
  final SearchGroup<BusinessListModel> businesses;

  final SearchGroup<SearchServiceItem> services;

  const SearchResultModel({
    required this.query,
    required this.categories,
    required this.businesses,
    required this.services,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel(
        query: json['query'] as String? ?? '',
        categories: SearchGroup.fromJson(
          json['categories'] as Map<String, dynamic>?,
          CategoryModel.fromJson,
        ),
        businesses: SearchGroup.fromJson(
          json['businesses'] as Map<String, dynamic>?,
          BusinessListModel.fromJson,
        ),
        services: SearchGroup.fromJson(
          json['services'] as Map<String, dynamic>?,
          SearchServiceItem.fromJson,
        ),
      );

  /// Nothing matched in any group. This is a normal result, not an error.
  bool get isEmpty =>
      categories.isEmpty && businesses.isEmpty && services.isEmpty;

  /// Same results with one shop's heart flipped, after a favourite change.
  SearchResultModel withFavorite(String businessId, bool isFavorited) =>
      SearchResultModel(
        query: query,
        categories: categories,
        businesses: SearchGroup(
          total: businesses.total,
          items: [
            for (final item in businesses.items)
              item.id == businessId
                  ? item.copyWith(isFavorited: isFavorited)
                  : item,
          ],
        ),
        services: services,
      );
}
