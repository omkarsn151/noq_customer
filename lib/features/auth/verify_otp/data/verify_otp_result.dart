class VerifyOtpResult {
  final String? fullName;
  final bool isProfileComplete;
  final String accessToken;
  final String refreshToken;

  const VerifyOtpResult({
    this.fullName,
    required this.isProfileComplete,
    required this.accessToken,
    required this.refreshToken,
  });

  factory VerifyOtpResult.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final tokens = json['tokens'] as Map<String, dynamic>;
    return VerifyOtpResult(
      fullName: user?['full_name'] as String?,
      isProfileComplete: user?['is_profile_complete'] as bool? ?? false,
      accessToken: tokens['access_token'] as String,
      refreshToken: tokens['refresh_token'] as String,
    );
  }
}
