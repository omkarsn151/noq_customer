import 'package:go_router/go_router.dart';
import 'package:noq/features/auth/request_otp/presentation/screens/login_screen.dart';
import 'package:noq/features/auth/verify_otp/presentation/screens/otp_verification_scren.dart';
import 'package:noq/features/auth/register/presentation/screens/register_screen.dart';
import 'package:noq/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:noq/features/business_details/presentation/screen/business_details_screen.dart';
import 'package:noq/features/cart/presentation/screens/cart_screen.dart';
import 'package:noq/features/dashboard/dashboard_screen.dart';
import 'package:noq/features/main_screen/main_screen.dart';
import 'package:noq/features/privacy/privacy_policy_screen.dart';
import 'package:noq/features/profile/profile_screen.dart';
import 'package:noq/features/splash/splash_screen.dart';
import 'package:noq/features/tnc/tnc_screen.dart';
import 'package:noq/features/welcome/welcome_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/splash'),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return OtpVerificationScren(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(path: '/tnc', builder: (context, state) => const TncScreen()),
      GoRoute(
        path: '/business/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BusinessDetailsScreen(businessId: id);
        },
      ),

      // Bottom nav shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/home',
          //       builder: (context, state) => const HomeScreen(),
          //       routes: [
          //         // nested screens within Home tab go here, e.g.:
          //         GoRoute(
          //           path: 'details/:id', // -> /home/details/123
          //           builder: (context, state) {
          //             final id = state.pathParameters['id']!;
          //             return HomeDetailsScreen(id: id);
          //           },
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DasboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                builder: (context, state) => const BookingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
