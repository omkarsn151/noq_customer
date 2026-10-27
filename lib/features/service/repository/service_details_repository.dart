import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/service/data/service_details_model.dart';

class ServiceDetailsRepository {
  final DioClient _dioClient;

  ServiceDetailsRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  Future<ServiceDetailsModel> getServiceDetails({
    required String businessId,
    required String serviceId,
  }) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getBusinessDetails}/$businessId/services/$serviceId',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ServiceDetailsModel.fromJson(data);
  }
}
