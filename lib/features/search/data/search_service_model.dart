import 'package:noq/features/business_details/data/business_details_model.dart';

/// The shop a [SearchServiceItem] belongs to. Needed to open the service
/// screen, which lives under its business.
class SearchServiceBusiness {
  final String id;
  final String name;

  const SearchServiceBusiness({required this.id, required this.name});

  factory SearchServiceBusiness.fromJson(Map<String, dynamic> json) =>
      SearchServiceBusiness(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );
}

/// A service row, as sent in the search preview's `services` group and by
/// `GET /customer/search/services`.
class SearchServiceItem {
  final String id;
  final String name;
  final int durationMinutes;
  final ServicePricing pricing;

  /// Null when the service has no picture — show a placeholder.
  final String? thumbnailUrl;

  final SearchServiceBusiness business;

  const SearchServiceItem({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.pricing,
    required this.thumbnailUrl,
    required this.business,
  });

  factory SearchServiceItem.fromJson(Map<String, dynamic> json) =>
      SearchServiceItem(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        durationMinutes: (json['duration_minutes'] as num? ?? 0).toInt(),
        pricing: ServicePricing.fromJson(
          json['pricing'] as Map<String, dynamic>? ?? const {},
        ),
        thumbnailUrl: json['thumbnail_url'] as String?,
        business: SearchServiceBusiness.fromJson(
          json['business'] as Map<String, dynamic>? ?? const {},
        ),
      );
}
