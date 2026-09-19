class BusinessDetailsInfo {
  final String name;
  final String heroUrl;
  final List<String> services;
  final String phone;
  final String description;

  const BusinessDetailsInfo({
    required this.name,
    required this.heroUrl,
    required this.services,
    required this.phone,
    required this.description,
  });

  factory BusinessDetailsInfo.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsInfo(
        name: json['name'] as String? ?? '',
        heroUrl: json['hero_url'] as String? ?? '',
        services: (json['services'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
        phone: json['phone'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
}

class BusinessDetailsRating {
  final double average;
  final int totalReviews;

  const BusinessDetailsRating({
    required this.average,
    required this.totalReviews,
  });

  factory BusinessDetailsRating.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsRating(
        average: (json['average'] as num? ?? 0).toDouble(),
        totalReviews: (json['total_reviews'] as num? ?? 0).toInt(),
      );
}

class BusinessDetailsWait {
  final int minutes;

  const BusinessDetailsWait({required this.minutes});

  factory BusinessDetailsWait.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsWait(minutes: (json['minutes'] as num? ?? 0).toInt());
}

class ServicePricing {
  final String price;

  const ServicePricing({required this.price});

  factory ServicePricing.fromJson(Map<String, dynamic> json) =>
      ServicePricing(price: json['price'] as String? ?? '0');
}

class BusinessServiceModel {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final int durationMinutes;
  final ServicePricing pricing;
  final bool isInCart;
  /// Id of the cart item holding this service; null when not in the cart.
  final String? cartItemId;

  const BusinessServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.durationMinutes,
    required this.pricing,
    required this.isInCart,
    this.cartItemId,
  });

  factory BusinessServiceModel.fromJson(Map<String, dynamic> json) =>
      BusinessServiceModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
        durationMinutes: (json['duration_minutes'] as num? ?? 0).toInt(),
        pricing: ServicePricing.fromJson(
          json['pricing'] as Map<String, dynamic>? ?? {},
        ),
        isInCart: json['is_in_cart'] ?? false,
        cartItemId: json['cart_item_id'] as String?,
      );
}

class BusinessDetailsModel {
  final String id;
  final BusinessDetailsInfo business;
  final BusinessDetailsRating rating;
  final BusinessDetailsWait wait;
  final List<BusinessServiceModel> services;

  const BusinessDetailsModel({
    required this.id,
    required this.business,
    required this.rating,
    required this.wait,
    required this.services,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsModel(
        id: json['id'] as String? ?? '',
        business: BusinessDetailsInfo.fromJson(
          json['business'] as Map<String, dynamic>? ?? {},
        ),
        rating: BusinessDetailsRating.fromJson(
          json['rating'] as Map<String, dynamic>? ?? {},
        ),
        wait: BusinessDetailsWait.fromJson(
          json['wait'] as Map<String, dynamic>? ?? {},
        ),
        services: (json['services'] as List<dynamic>? ?? [])
            .map((e) => BusinessServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
