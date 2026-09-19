import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/services/secure_storage_service.dart';
import 'package:noq/features/auth/verify_otp/data/verify_otp_result.dart';

class VerifyOtpRepository {
  final DioClient _dioClient;
  final SecureStorageService _secureStorageService;

  VerifyOtpRepository({DioClient? dioClient, SecureStorageService? secureStorageService})
      : _dioClient = dioClient ?? DioClient(),
        _secureStorageService = secureStorageService ?? SecureStorageService();

  Future<VerifyOtpResult> verifyOtp({required String phone, required String code}) async {
    final response = await _dioClient.post(
      ApiEndpoints.verifyOtp,
      data: {'phone': phone, 'code': code},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final result = VerifyOtpResult.fromJson(data);

    await _secureStorageService.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    await _secureStorageService.saveFullName(result.fullName);

    return result;
  }
}
