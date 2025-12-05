import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==== Import Screens ====
import 'package:tubes/screen/history_screen.dart';
import 'package:tubes/screen/notification_screen.dart';
import 'package:tubes/screen/profile_screen.dart';
import 'package:tubes/screen/account_screen.dart';
import 'package:tubes/screen/signup_screen.dart';
import 'package:tubes/screen/logout_confirm_screen.dart';

import '../screen/splash_screen.dart';
import '../screen/firstime_screen.dart';
import '../screen/login_screen.dart';
import '../screen/signsuc_screen.dart';
import '../screen/home_screen.dart';
import '../widget/app_scaffold.dart';

// =========================
// ROUTES
// =========================
class AppRoutes {
  static const String splash = '/splash';
  static const String firstTime = '/firstime';
  static const String login = '/login';
  static const String signSuccess = '/signsuccess';
  static const String signUp = '/signup';

  // Pages inside Bottom NavBar
  static const String home = '/home';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String account = '/account';
  static const String notification = '/notification';

  // Other pages
  static const String logoutConfirm = '/logout-confirm';
}

// =========================
// ROUTER CREATOR
// =========================
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      // ============================
      // AUTH & ONBOARDING
      // ============================
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),

      GoRoute(
        path: AppRoutes.firstTime,
        builder: (_, __) => const FirstTimeScreen(),
      ),

      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),

      GoRoute(path: AppRoutes.signUp, builder: (_, __) => const SignUpScreen()),

      GoRoute(
        path: AppRoutes.signSuccess,
        builder: (_, __) => const SuccessScreen(),
      ),

      // ============================
      // 🔥 SHELL ROUTE (BOTTOM NAVBAR)
      // ============================
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.history,
            builder: (_, __) => const HistoryPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.account,
            builder: (_, __) => const AccountPage(),
          ),
        ],
      ),

      // ============================
      // ROUTE DI LUAR NAVBAR
      // ============================
      GoRoute(
        path: AppRoutes.notification,
        builder: (_, __) => const NotificationStaffPage(),
      ),

      GoRoute(
        path: AppRoutes.logoutConfirm,
        builder: (_, __) => const LogoutConfirmScreen(),
      ),
    ],

    // ============================
    // ERROR PAGE
    // ============================
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          '404 - Page Not Found\n${state.uri.path}',
          style: const TextStyle(fontSize: 16, color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
