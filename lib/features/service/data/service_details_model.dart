import 'package:noq/features/business_details/data/business_details_model.dart';

/// The shop that offers a service.
class ServiceShopModel {
  final String id;
  final String name;

  const ServiceShopModel({required this.id, required this.name});

  factory ServiceShopModel.fromJson(Map<String, dynamic> json) =>
      ServiceShopModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );
}

/// Everything the service details screen draws.
class ServiceDetailsModel {
  final String id;
  final String name;

  /// Null when the shop has not written one — hide "About this service".
  final String? description;

  final int durationMinutes;
  final ServicePricing pricing;

  /// Null when the service has no picture — show a placeholder.
  final String? heroUrl;

  /// Every other picture, hero excluded. Empty → hide the Gallery section.
  final List<String> gallery;

  final bool isInCart;

  /// Id of the cart item holding this service; non-null exactly when
  /// [isInCart] is true.
  final String? cartItemId;

  final ServiceShopModel business;

  const ServiceDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.pricing,
    required this.heroUrl,
    required this.gallery,
    required this.isInCart,
    required this.cartItemId,
    required this.business,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      ServiceDetailsModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        durationMinutes: (json['duration_minutes'] as num? ?? 0).toInt(),
        pricing: ServicePricing.fromJson(
          json['pricing'] as Map<String, dynamic>? ?? const {},
        ),
        heroUrl: json['hero_url'] as String?,
        gallery: (json['gallery'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        isInCart: json['is_in_cart'] as bool? ?? false,
        cartItemId: json['cart_item_id'] as String?,
        business: ServiceShopModel.fromJson(
          json['business'] as Map<String, dynamic>? ?? const {},
        ),
      );
}
