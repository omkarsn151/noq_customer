import 'package:noq/features/business_details/data/business_details_model.dart';

/// One collapsible section (sub-category) on the All Services screen.
class ShopSectionModel {
  final String id;
  final String name;

  /// Null when no admin picture is set.
  final String? imageUrl;

  /// Always 1 or more — empty sections are never returned.
  final int serviceCount;

  const ShopSectionModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.serviceCount,
  });

  factory ShopSectionModel.fromJson(Map<String, dynamic> json) =>
      ShopSectionModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        imageUrl: json['image_url'] as String?,
        serviceCount: (json['service_count'] as num? ?? 0).toInt(),
      );
}

/// A section with its services. Returned by "open one section" and by every
/// entry of the in-shop search result.
class ShopSectionServicesModel {
  final ShopSectionModel subCategory;

  /// The whole section, sorted by name. No paging.
  final List<BusinessServiceModel> items;

  const ShopSectionServicesModel({
    required this.subCategory,
    required this.items,
  });

  factory ShopSectionServicesModel.fromJson(Map<String, dynamic> json) =>
      ShopSectionServicesModel(
        subCategory: ShopSectionModel.fromJson(
          json['sub_category'] as Map<String, dynamic>? ?? const {},
        ),
        items: (json['items'] as List<dynamic>? ?? const [])
            .map(
              (e) => BusinessServiceModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
}
