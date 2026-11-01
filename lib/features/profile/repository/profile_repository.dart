import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/profile/data/profile_model.dart';

class ProfileRepository {
  final DioClient _dioClient;

  ProfileRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  Future<ProfileModel> getProfile() async {
    final response = await _dioClient.get(ApiEndpoints.getProfile);
    return ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
