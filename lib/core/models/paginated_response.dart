/// Pagination block from the API envelope's `meta.pagination`.
class PageMeta {
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  const PageMeta({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  const PageMeta.empty()
    : page = 1,
      pageSize = 0,
      totalItems = 0,
      totalPages = 0;

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      page: (json['page'] as num? ?? 1).toInt(),
      pageSize: (json['page_size'] as num? ?? 0).toInt(),
      totalItems: (json['total_items'] as num? ?? 0).toInt(),
      totalPages: (json['total_pages'] as num? ?? 0).toInt(),
    );
  }

  bool get hasNextPage => page < totalPages;
}

/// Wraps a `{ data: [...], meta: { pagination: {...} } }` response body. Some
/// endpoints (e.g. `GET /categories`) send the pagination fields flat on
/// `meta` instead; both shapes are read.
class PaginatedResponse<T> {
  final List<T> items;
  final PageMeta meta;

  const PaginatedResponse({required this.items, required this.meta});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final pagination = meta['pagination'] as Map<String, dynamic>? ?? meta;

    return PaginatedResponse(
      items: (json['data'] as List<dynamic>? ?? const [])
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMeta.fromJson(pagination),
    );
  }
}
