/// One chip in `GET /customer/search/quick-filters`.
///
/// A chip is an exact category filter, not a text search: tapping it opens the
/// shop list for [categoryId].
class QuickFilterModel {
  final String label;
  final String categoryId;
  final int businessCount;

  const QuickFilterModel({
    required this.label,
    required this.categoryId,
    required this.businessCount,
  });

  factory QuickFilterModel.fromJson(Map<String, dynamic> json) =>
      QuickFilterModel(
        label: json['label'] as String? ?? '',
        categoryId: json['category_id'] as String? ?? '',
        businessCount: (json['business_count'] as num? ?? 0).toInt(),
      );
}
