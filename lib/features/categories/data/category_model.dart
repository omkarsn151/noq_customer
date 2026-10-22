/// One category tile — shared by Home (`categories.items[]`) and the
/// View All list (`GET /categories`).
class CategoryModel {
  final String id;
  final String name;

  /// Small grey line, e.g. "Quick trims"; null when the admin hasn't set one.
  final String? description;

  /// Tile background; null when the admin hasn't set one.
  final String? imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  /// `GET /categories` calls the grey line `description`; the Home payload
  /// calls the same value `subtitle`.
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? json['subtitle'] as String?,
    imageUrl: json['image_url'] as String?,
  );
}
