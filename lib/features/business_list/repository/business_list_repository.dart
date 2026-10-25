import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';

class BusinessListRepository {
  static const int defaultPageSize = 20;

  final DioClient _dioClient;

  BusinessListRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Public shops, optionally only those in [categoryId]. With [lat] and [lng]
  /// (sent only together) they come back nearest first; otherwise best rated.
  Future<PaginatedResponse<BusinessListModel>> getBusinesses({
    String? categoryId,
    double? lat,
    double? lng,
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.getBusinesses,
      queryParameters: {
        'category_id': ?categoryId,
        if (lat != null && lng != null) ...{'lat': lat, 'lng': lng},
        'page': page,
        'page_size': pageSize,
      },
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      BusinessListModel.fromJson,
    );
  }
}
