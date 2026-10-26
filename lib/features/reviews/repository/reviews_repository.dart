import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/reviews/data/review_model.dart';

class ReviewsRepository {
  static const int defaultPageSize = 20;

  final DioClient _dioClient;

  ReviewsRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// All reviews for [businessId], newest first. Includes star-only reviews
  /// (`comment: null`). Pagination is nested at `meta.pagination`.
  Future<PaginatedResponse<ReviewModel>> getReviews({
    required String businessId,
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getBusinessDetails}/$businessId/reviews',
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      ReviewModel.fromJson,
    );
  }
}
