/// The logged-in customer, from `data.user` of `GET v1/customer/auth/profile`.
class ProfileModel {
  final String id;
  final String phone;

  /// Null until the customer has finished profile setup.
  final String? fullName;

  /// Null when the customer has no photo.
  final String? photoUrl;

  const ProfileModel({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.photoUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? const {};
    return ProfileModel(
      id: user['id'] as String? ?? '',
      phone: user['phone'] as String? ?? '',
      fullName: user['full_name'] as String?,
      photoUrl: user['photo_url'] as String?,
    );
  }
}
