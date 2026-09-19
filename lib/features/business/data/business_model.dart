class BusinessInfo {
  final String name;
  final String thumbnailUrl;
  final List<String> services;

  const BusinessInfo({
    required this.name,
    required this.thumbnailUrl,
    required this.services,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) => BusinessInfo(
        name: json['name'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
        services: (json['services'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
      );
}

class BusinessRating {
  final double average;
  final int totalReviews;

  const BusinessRating({
    required this.average,
    required this.totalReviews,
  });

  factory BusinessRating.fromJson(Map<String, dynamic> json) => BusinessRating(
        average: (json['average'] as num? ?? 0).toDouble(),
        totalReviews: (json['total_reviews'] as num? ?? 0).toInt(),
      );
}

class BusinessWait {
  final int minutes;

  const BusinessWait({required this.minutes});

  factory BusinessWait.fromJson(Map<String, dynamic> json) =>
      BusinessWait(minutes: (json['minutes'] as num? ?? 0).toInt());
}

class BusinessModel {
  final String id;
  final BusinessInfo business;
  final BusinessRating rating;
  final BusinessWait wait;

  const BusinessModel({
    required this.id,
    required this.business,
    required this.rating,
    required this.wait,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        id: json['id'] as String? ?? '',
        business: BusinessInfo.fromJson(
          json['business'] as Map<String, dynamic>? ?? {},
        ),
        rating: BusinessRating.fromJson(
          json['rating'] as Map<String, dynamic>? ?? {},
        ),
        wait: BusinessWait.fromJson(
          json['wait'] as Map<String, dynamic>? ?? {},
        ),
      );
}
