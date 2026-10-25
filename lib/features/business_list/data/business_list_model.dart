/// Price range of a shop's live services. Decimal strings on the wire.
class BusinessListPricingModel {
  final String currencyCode;
  final String minPrice;
  final String maxPrice;

  const BusinessListPricingModel({
    required this.currencyCode,
    required this.minPrice,
    required this.maxPrice,
  });

  factory BusinessListPricingModel.fromJson(Map<String, dynamic> json) =>
      BusinessListPricingModel(
        currencyCode: json['currency_code'] as String? ?? '',
        minPrice: json['min_price'] as String? ?? '0',
        maxPrice: json['max_price'] as String? ?? '0',
      );

  /// '₹50 - ₹200', or a single price when the shop has one price point.
  String get priceLabel {
    final min = '$_symbol${_trimDecimals(minPrice)}';
    if (minPrice == maxPrice) return min;
    return '$min - $_symbol${_trimDecimals(maxPrice)}';
  }

  String get _symbol => switch (currencyCode) {
    'INR' => '₹',
    _ => '$currencyCode ',
  };

  /// '50.00' reads better as '50' on a card.
  static String _trimDecimals(String amount) {
    if (!amount.contains('.')) return amount;
    final trimmed = amount
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}

/// A shop's rating. Both values are never null; `totalReviews == 0` means
/// nobody has reviewed yet ("New").
class BusinessListRating {
  final double average;
  final int totalReviews;

  const BusinessListRating({required this.average, required this.totalReviews});

  factory BusinessListRating.fromJson(Map<String, dynamic> json) =>
      BusinessListRating(
        average: (json['average'] as num? ?? 0).toDouble(),
        totalReviews: (json['total_reviews'] as num? ?? 0).toInt(),
      );
}

/// One shop in `GET /customer/businesses`.
class BusinessListModel {
  final String id;
  final String name;

  /// Null when the shop has no photo.
  final String? thumbnailUrl;

  final List<String> services;

  /// Null when the shop has no live services — hide the price.
  final BusinessListPricingModel? pricing;

  final BusinessListRating rating;

  /// Null when the shop hasn't set its slot settings — hide the chip.
  final int? waitMinutes;

  final String? address;

  /// Null when no GPS was sent or the shop has no map pin.
  final double? distanceKm;

  final bool isFavorited;

  const BusinessListModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.services,
    required this.pricing,
    required this.rating,
    required this.waitMinutes,
    required this.address,
    required this.distanceKm,
    required this.isFavorited,
  });

  factory BusinessListModel.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] as Map<String, dynamic>?;
    final wait = json['wait'] as Map<String, dynamic>?;
    return BusinessListModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      services: (json['services'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      pricing: pricing == null
          ? null
          : BusinessListPricingModel.fromJson(pricing),
      rating: BusinessListRating.fromJson(
        json['rating'] as Map<String, dynamic>? ?? const {},
      ),
      waitMinutes: (wait?['minutes'] as num?)?.toInt(),
      address: json['address'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }

  String get servicesLabel => services.join(', ');

  /// '1.5 km', or null when the distance is unknown.
  String? get distanceLabel {
    final km = distanceKm;
    if (km == null) return null;
    return '${km.toStringAsFixed(1)} km';
  }
}
