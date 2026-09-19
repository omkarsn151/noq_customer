import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/business/data/business_model.dart';

class BusinessRepository {
  final DioClient _dioClient;

  BusinessRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<BusinessModel>> getBusinessList() async {
    final response = await _dioClient.get(ApiEndpoints.getBusinessList);
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => BusinessModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
