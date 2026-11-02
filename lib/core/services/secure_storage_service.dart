import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._internal();

  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;

  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _fullNameKey = 'full_name';
  static const _latitudeKey = 'latitude';
  static const _longitudeKey = 'longitude';

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveFullName(String? fullName) async {
    if (fullName == null) {
      await _storage.delete(key: _fullNameKey);
    } else {
      await _storage.write(key: _fullNameKey, value: fullName);
    }
  }



  Future<String?> getFullName() => _storage.read(key: _fullNameKey);

  Future<void> saveLocation({required double latitude, required double longitude}) async {
    await _storage.write(key: _latitudeKey, value: latitude.toString());
    await _storage.write(key: _longitudeKey, value: longitude.toString());
  }

  /// Null unless both values are stored and readable.
  Future<({double latitude, double longitude})?> getLocation() async {
    final latitude = double.tryParse(await _storage.read(key: _latitudeKey) ?? '');
    final longitude = double.tryParse(await _storage.read(key: _longitudeKey) ?? '');
    if (latitude == null || longitude == null) return null;
    return (latitude: latitude, longitude: longitude);
  }

  Future<void> clearLocation() async {
    await _storage.delete(key: _latitudeKey);
    await _storage.delete(key: _longitudeKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _fullNameKey);
    await clearLocation();
  }
}
