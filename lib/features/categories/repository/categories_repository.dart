import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/categories/data/category_model.dart';

class CategoriesRepository {
  static const int defaultPageSize = 20;

  final DioClient _dioClient;

  CategoriesRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Public list of categories, already sorted by the admins. No token needed.
  Future<PaginatedResponse<CategoryModel>> getCategories({
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.getCategories,
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      CategoryModel.fromJson,
    );
  }
}
