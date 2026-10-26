class BusinessDetailsInfo {
  final String name;

  /// Null when the shop has no hero picture — show a placeholder.
  final String? heroUrl;

  final List<String> thumbnailUrls;

  /// Up to 3 service names for the subtitle line.
  final List<String> services;

  final String phone;
  final String? description;

  const BusinessDetailsInfo({
    required this.name,
    required this.heroUrl,
    required this.thumbnailUrls,
    required this.services,
    required this.phone,
    required this.description,
  });

  factory BusinessDetailsInfo.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsInfo(
        name: json['name'] as String? ?? '',
        heroUrl: json['hero_url'] as String?,
        thumbnailUrls: (json['thumbnail_urls'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        services: (json['services'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        phone: json['phone'] as String? ?? '',
        description: json['description'] as String?,
      );

  String get servicesLabel => services.join(', ');
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

  /// No reviews yet — show "New" instead of "0.0".
  bool get isNew => totalReviews == 0;

  /// '4.8 (230)', or 'New' when the shop has no reviews.
  String get label =>
      isNew ? 'New' : '${average.toStringAsFixed(1)} ($totalReviews)';
}

class BusinessDetailsWait {
  /// Null when the shop has no slot settings — hide the wait chip.
  final int? minutes;

  const BusinessDetailsWait({required this.minutes});

  factory BusinessDetailsWait.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsWait(minutes: (json['minutes'] as num?)?.toInt());
}

class BusinessDetailsLocation {
  final String? address;
  final String? addressLine;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? countryCode;

  /// Null when the address was never located — hide the map icon.
  final double? latitude;
  final double? longitude;

  /// Null whenever [latitude] is null.
  final String? mapUrl;
  final String? directionsUrl;

  const BusinessDetailsLocation({
    this.address,
    this.addressLine,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.directionsUrl,
  });

  factory BusinessDetailsLocation.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsLocation(
        address: json['address'] as String?,
        addressLine: json['address_line'] as String?,
        addressLine2: json['address_line_2'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        postalCode: json['postal_code'] as String?,
        countryCode: json['country_code'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        mapUrl: json['map_url'] as String?,
        directionsUrl: json['directions_url'] as String?,
      );
}

class BusinessReviewModel {
  final String id;
  final String reviewerName;
  final String? reviewerPhotoUrl;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  const BusinessReviewModel({
    required this.id,
    required this.reviewerName,
    required this.reviewerPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory BusinessReviewModel.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] as Map<String, dynamic>? ?? const {};
    return BusinessReviewModel(
      id: json['id'] as String? ?? '',
      reviewerName: reviewer['name'] as String? ?? '',
      reviewerPhotoUrl: reviewer['photo_url'] as String?,
      rating: (json['rating'] as num? ?? 0).toInt(),
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }
}

class ServicePricing {
  final String currencyCode;

  /// Decimal string as sent by the server, e.g. '499.00'.
  final String price;

  const ServicePricing({required this.currencyCode, required this.price});

  factory ServicePricing.fromJson(Map<String, dynamic> json) => ServicePricing(
    currencyCode: json['currency_code'] as String? ?? '',
    price: json['price'] as String? ?? '0',
  );

  /// '₹499.00' for INR, otherwise prefixed with the ISO code.
  String get label => switch (currencyCode) {
    'INR' => '₹$price',
    '' => price,
    _ => '$currencyCode $price',
  };
}

class BusinessServiceModel {
  final String id;
  final String name;

  /// Null when the shop left it blank — hide the subtitle.
  final String? description;

  /// Null when the service has no picture — show a placeholder.
  final String? thumbnailUrl;

  final int durationMinutes;
  final ServicePricing pricing;
  final bool isInCart;

  /// Id of the cart item holding this service; null when not in the cart.
  final String? cartItemId;

  const BusinessServiceModel({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    required this.durationMinutes,
    required this.pricing,
    this.isInCart = false,
    this.cartItemId,
  });

  factory BusinessServiceModel.fromJson(Map<String, dynamic> json) =>
      BusinessServiceModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        thumbnailUrl: json['thumbnail_url'] as String?,
        durationMinutes: (json['duration_minutes'] as num? ?? 0).toInt(),
        pricing: ServicePricing.fromJson(
          json['pricing'] as Map<String, dynamic>? ?? const {},
        ),
        isInCart: json['is_in_cart'] as bool? ?? false,
        cartItemId: json['cart_item_id'] as String?,
      );
}

/// The shop page's Popular Services block (max 5, already in display order).
class PopularServicesModel {
  /// True when the shop picked none and the server chose them.
  /// For logging/QA only — never shown to the customer.
  final bool isAutoSelected;

  final List<BusinessServiceModel> items;

  const PopularServicesModel({
    required this.isAutoSelected,
    required this.items,
  });

  factory PopularServicesModel.fromJson(Map<String, dynamic> json) =>
      PopularServicesModel(
        isAutoSelected: json['is_auto_selected'] as bool? ?? false,
        items: (json['items'] as List<dynamic>? ?? const [])
            .map(
              (e) => BusinessServiceModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
}

class BusinessDetailsModel {
  final String id;
  final BusinessDetailsInfo business;
  final BusinessDetailsRating rating;
  final BusinessDetailsWait wait;
  final bool isFavorited;
  final BusinessDetailsLocation location;

  /// Preview only; may be empty.
  final List<BusinessReviewModel> reviews;

  final PopularServicesModel services;

  const BusinessDetailsModel({
    required this.id,
    required this.business,
    required this.rating,
    required this.wait,
    required this.isFavorited,
    required this.location,
    required this.reviews,
    required this.services,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    final favorite = json['favorite'] as Map<String, dynamic>?;
    final reviews = json['reviews'] as Map<String, dynamic>?;
    return BusinessDetailsModel(
      id: json['id'] as String? ?? '',
      business: BusinessDetailsInfo.fromJson(
        json['business'] as Map<String, dynamic>? ?? const {},
      ),
      rating: BusinessDetailsRating.fromJson(
        json['rating'] as Map<String, dynamic>? ?? const {},
      ),
      wait: BusinessDetailsWait.fromJson(
        json['wait'] as Map<String, dynamic>? ?? const {},
      ),
      isFavorited: favorite?['is_favorited'] as bool? ?? false,
      location: BusinessDetailsLocation.fromJson(
        json['location'] as Map<String, dynamic>? ?? const {},
      ),
      reviews: (reviews?['items'] as List<dynamic>? ?? const [])
          .map((e) => BusinessReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      // An object since the popular-services release, not a list.
      services: PopularServicesModel.fromJson(
        json['services'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
