import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/search/data/quick_filter_model.dart';
import 'package:noq/features/search/data/search_result_model.dart';
import 'package:noq/features/search/data/search_service_model.dart';

class SearchRepository {
  static const int defaultPageSize = 20;

  /// Server rejects larger pages with a 422.
  static const int maxPageSize = 50;

  final DioClient _dioClient;

  SearchRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Quick filters only change as shops join, so they're fetched once per app
  /// session. Static because each visit to the Search screen creates a new
  /// repository along with its BLoC.
  static List<QuickFilterModel>? _quickFiltersCache;

  /// Up to 8 category chips, busiest first. Empty when the platform has no
  /// public shops.
  Future<List<QuickFilterModel>> getQuickFilters() async {
    final cached = _quickFiltersCache;
    if (cached != null) return cached;

    final response = await _dioClient.get(ApiEndpoints.searchQuickFilters);
    final data = response.data['data'] as Map<String, dynamic>;

    return _quickFiltersCache = (data['items'] as List<dynamic>? ?? const [])
        .map((e) => QuickFilterModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Grouped preview for [q] (2–100 characters). Has no paging: use
  /// [searchServices] or the shop list for "See all".
  Future<SearchResultModel> search(String q) async {
    final response = await _dioClient.get(
      ApiEndpoints.search,
      queryParameters: {'q': q},
    );

    return SearchResultModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Every service matching [q], ordered by name.
  Future<PaginatedResponse<SearchServiceItem>> searchServices({
    required String q,
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.searchServices,
      queryParameters: {
        'q': q,
        'page': page,
        'page_size': pageSize.clamp(1, maxPageSize),
      },
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      SearchServiceItem.fromJson,
    );
  }
}
