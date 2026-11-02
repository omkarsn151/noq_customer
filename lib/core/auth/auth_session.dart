import 'package:flutter/foundation.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/core/services/secure_storage_service.dart';

class AuthSession {
  AuthSession._();

  static VoidCallback? _onLoggedOut;

  static void registerLogoutHandler(VoidCallback handler) {
    _onLoggedOut = handler;
  }

  static Future<void> logout() async {
    await SecureStorageService().clearTokens();
    await LocationService().clear();
    _onLoggedOut?.call();
  }
}
