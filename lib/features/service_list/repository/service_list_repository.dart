import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/service_list/data/service_list_model.dart';

class ServiceListRepository {
  final DioClient _dioClient;

  ServiceListRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// The shop's sections in display order. Not paginated.
  Future<List<ShopSectionModel>> getSections(String businessId) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getBusinessDetails}/$businessId/sub-categories',
    );
    final data = response.data['data'] as Map<String, dynamic>? ?? const {};
    return (data['items'] as List<dynamic>? ?? const [])
        .map((e) => ShopSectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Every service in one section. Not paginated.
  Future<ShopSectionServicesModel> getSectionServices({
    required String businessId,
    required String subCategoryId,
  }) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getBusinessDetails}/$businessId/sub-categories/$subCategoryId/services',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ShopSectionServicesModel.fromJson(data);
  }
}
