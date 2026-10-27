import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';

class FavoritesRepository {
  final DioClient _dioClient;

  FavoritesRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

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
