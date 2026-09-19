import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';

class BusinessDetailsRepository {
  final DioClient _dioClient;

  BusinessDetailsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<BusinessDetailsModel> getBusinessDetails(String id) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getBusinessDetails}/$id',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return BusinessDetailsModel.fromJson(data);
  }
}
