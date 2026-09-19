import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noq/core/services/secure_storage_service.dart';
import 'package:noq/core/utils/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final accessToken = await SecureStorageService().getAccessToken();
    final fullName = await SecureStorageService().getFullName();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (accessToken == null || accessToken.isEmpty) {
      context.go('/welcome');
      return;
    }

    if (fullName == null) {
      context.go('/register');
      return;
    }

    context.go('/dashboard');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset(AppAssets.appLogo)));
  }
}
