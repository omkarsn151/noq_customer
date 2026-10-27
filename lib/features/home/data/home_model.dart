import 'package:noq/features/categories/data/category_model.dart';

/// The shop on the Up Next card.
class UpNextBusinessModel {
  final String id;
  final String name;
  final String categoryName;

  /// Null when the shop has no photo.
  final String? thumbnailUrl;

  const UpNextBusinessModel({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.thumbnailUrl,
  });

  factory UpNextBusinessModel.fromJson(Map<String, dynamic> json) =>
      UpNextBusinessModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        categoryName: json['category_name'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String?,
      );
}

/// The customer's next accepted visit — only ever `confirmed` or
/// `in_progress`.
class UpNextModel {
  final String bookingId;
  final String reference;
  final String status;

  /// UTC instant; format it in the phone's timezone before showing it.
  final DateTime startsAt;

  final List<String> services;
  final UpNextBusinessModel business;

  const UpNextModel({
    required this.bookingId,
    required this.reference,
    required this.status,
    required this.startsAt,
    required this.services,
    required this.business,
  });

  factory UpNextModel.fromJson(Map<String, dynamic> json) => UpNextModel(
    bookingId: json['booking_id'] as String? ?? '',
    reference: json['reference'] as String? ?? '',
    status: json['status'] as String? ?? '',
    startsAt:
        DateTime.tryParse(json['starts_at'] as String? ?? '') ?? DateTime.now(),
    services: (json['services'] as List<dynamic>? ?? const [])
        .map((e) => e as String)
        .toList(),
    business: UpNextBusinessModel.fromJson(
      json['business'] as Map<String, dynamic>? ?? const {},
    ),
  );

  bool get isInProgress => status == 'in_progress';
}

/// At most 4 categories, already in display order.
class HomeCategoriesModel {
  final int total;
  final List<CategoryModel> items;

  const HomeCategoriesModel({required this.total, required this.items});

  factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) =>
      HomeCategoriesModel(
        total: (json['total'] as num? ?? 0).toInt(),
        items: (json['items'] as List<dynamic>? ?? const [])
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Show "View All" only when there are more categories than shown.
  bool get hasMore => total > items.length;
}

/// Always empty today. Items stay opaque until the backend publishes a shape.
class HomeSpecialOffersModel {
  final int total;
  final List<dynamic> items;

  const HomeSpecialOffersModel({required this.total, required this.items});

  factory HomeSpecialOffersModel.fromJson(Map<String, dynamic> json) =>
      HomeSpecialOffersModel(
        total: (json['total'] as num? ?? 0).toInt(),
        items: json['items'] as List<dynamic>? ?? const [],
      );
}

/// Price range of a shop's live services. Decimal strings on the wire.
class NearbyPricingModel {
  final String currencyCode;
  final String minPrice;
  final String maxPrice;

  const NearbyPricingModel({
    required this.currencyCode,
    required this.minPrice,
    required this.maxPrice,
  });

  factory NearbyPricingModel.fromJson(Map<String, dynamic> json) =>
      NearbyPricingModel(
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
class BusinessRating {
  final double average;
  final int totalReviews;

  const BusinessRating({required this.average, required this.totalReviews});

  factory BusinessRating.fromJson(Map<String, dynamic> json) => BusinessRating(
    average: (json['average'] as num? ?? 0).toDouble(),
    totalReviews: (json['total_reviews'] as num? ?? 0).toInt(),
  );
}

/// One card in the "Fastest Nearby" list.
class NearbyBusinessModel {
  final String id;
  final String name;

  /// Null when the shop has no photo.
  final String? thumbnailUrl;

  final List<String> services;

  /// Null when the shop has no live services — hide the price.
  final NearbyPricingModel? pricing;

  final BusinessRating rating;

  /// Null when the shop hasn't set its slot settings — hide the chip.
  final int? waitMinutes;

  final String? address;

  /// Null when no GPS was sent or the shop has no map pin.
  final double? distanceKm;

  final bool isFavorited;

  const NearbyBusinessModel({
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

  factory NearbyBusinessModel.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] as Map<String, dynamic>?;
    final wait = json['wait'] as Map<String, dynamic>?;
    return NearbyBusinessModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      services: (json['services'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      pricing: pricing == null ? null : NearbyPricingModel.fromJson(pricing),
      rating: BusinessRating.fromJson(
        json['rating'] as Map<String, dynamic>? ?? const {},
      ),
      waitMinutes: (wait?['minutes'] as num?)?.toInt(),
      address: json['address'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }

  NearbyBusinessModel copyWith({bool? isFavorited}) => NearbyBusinessModel(
    id: id,
    name: name,
    thumbnailUrl: thumbnailUrl,
    services: services,
    pricing: pricing,
    rating: rating,
    waitMinutes: waitMinutes,
    address: address,
    distanceKm: distanceKm,
    isFavorited: isFavorited ?? this.isFavorited,
  );

  String get servicesLabel => services.join(', ');

  /// '1.5 km', or null when the distance is unknown.
  String? get distanceLabel {
    final km = distanceKm;
    if (km == null) return null;
    return '${km.toStringAsFixed(1)} km';
  }
}

/// At most 6 shops, already ordered by the server.
class HomeNearbyModel {
  final int total;

  /// True only when lat/lng were sent; otherwise the list is best-rated first.
  final bool isSortedByDistance;

  final List<NearbyBusinessModel> items;

  const HomeNearbyModel({
    required this.total,
    required this.isSortedByDistance,
    required this.items,
  });

  factory HomeNearbyModel.fromJson(Map<String, dynamic> json) =>
      HomeNearbyModel(
        total: (json['total'] as num? ?? 0).toInt(),
        isSortedByDistance: json['is_sorted_by_distance'] as bool? ?? false,
        items: (json['items'] as List<dynamic>? ?? const [])
            .map((e) => NearbyBusinessModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  HomeNearbyModel copyWith({List<NearbyBusinessModel>? items}) =>
      HomeNearbyModel(
        total: total,
        isSortedByDistance: isSortedByDistance,
        items: items ?? this.items,
      );

  /// Show "View All" only when there are more shops than shown.
  bool get hasMore => total > items.length;
}

/// Payload of GET /customer/home — the whole Home tab, in screen order.
class HomeModel {
  /// Null when the customer has nothing coming up — hide the card.
  final UpNextModel? upNext;

  final HomeCategoriesModel categories;
  final HomeSpecialOffersModel specialOffers;
  final HomeNearbyModel nearby;

  const HomeModel({
    required this.upNext,
    required this.categories,
    required this.specialOffers,
    required this.nearby,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final upNext = json['up_next'] as Map<String, dynamic>?;
    return HomeModel(
      upNext: upNext == null ? null : UpNextModel.fromJson(upNext),
      categories: HomeCategoriesModel.fromJson(
        json['categories'] as Map<String, dynamic>? ?? const {},
      ),
      specialOffers: HomeSpecialOffersModel.fromJson(
        json['special_offers'] as Map<String, dynamic>? ?? const {},
      ),
      nearby: HomeNearbyModel.fromJson(
        json['nearby'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  HomeModel copyWith({HomeNearbyModel? nearby}) => HomeModel(
    upNext: upNext,
    categories: categories,
    specialOffers: specialOffers,
    nearby: nearby ?? this.nearby,
  );
}
