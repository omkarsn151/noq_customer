import 'package:flutter/material.dart';
import 'package:noq/app.dart';
import 'package:noq/core/auth/auth_session.dart';
import 'package:noq/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthSession.registerLogoutHandler(() => AppRouter.router.go('/login'));
  runApp(const MyApp());
}
