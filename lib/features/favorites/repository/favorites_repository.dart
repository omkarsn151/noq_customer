import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';

class FavoritesRepository {
  static const int defaultPageSize = 20;

  final DioClient _dioClient;

  FavoritesRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// The customer's saved shops, most recently saved first. Each one is the
  /// same card `GET /customer/businesses` returns.
  Future<PaginatedResponse<BusinessListModel>> getFavorites({
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.favorites,
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      BusinessListModel.fromJson,
    );
  }

  Future<String> addFavorite(String businessId) async {
    final response = await _dioClient.post(
      '${ApiEndpoints.favorites}/$businessId',
    );

    return response.data['message'] as String? ?? 'Saved to favourites';
  }

  Future<String> removeFavorite(String businessId) async {
    final response = await _dioClient.delete(
      '${ApiEndpoints.favorites}/$businessId',
    );

    return response.data['message'] as String? ?? 'Removed from favourites';
  }
}
