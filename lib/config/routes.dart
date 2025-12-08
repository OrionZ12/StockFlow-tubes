import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tubes/screen/history_screen.dart';
import 'package:tubes/screen/notification_screen.dart';
import 'package:tubes/screen/profile_screen.dart';
import 'package:tubes/screen/account_screen.dart';
import 'package:tubes/screen/signup_screen.dart';
import 'package:tubes/screen/logout_confirm_screen.dart';
import 'package:tubes/screen/notification_settings_page.dart';
import 'package:tubes/screen/change_password_screen.dart';
import 'package:tubes/screen/change_password_success_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/firstime_screen.dart';
import '../screen/login_screen.dart';
import '../screen/signsuc_screen.dart';
import '../screen/home_screen.dart';
import '../widget/app_scaffold.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String firstTime = '/firstime';
  static const String login = '/login';
  static const String signSuccess = '/signsuccess';
  static const String signUp = '/signup';

  static const String home = '/home';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String account = '/account';
  static const String notification = '/notification';

  static const String logoutConfirm = '/logout-confirm';
  static const String notificationSettings = '/notification-settings';
  static const String changePassword = '/change-password';
  static const String changePasswordSuccess = '/change-password-success';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // 🟦 Halaman Awal
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.firstTime,
        builder: (_, __) => const FirstTimeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.signSuccess,
        builder: (_, __) => const SuccessScreen(),
      ),

      // 🟩 Halaman utama dengan bottom nav bar
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
          GoRoute(
            path: AppRoutes.changePassword,
            builder: (_, __) => const ChangePasswordScreen(),
          ),
        ],
      ),

      // 🟨 Halaman lain tanpa bottom nav
      GoRoute(
        path: AppRoutes.notification,
        builder: (_, __) => const NotificationStaffPage(),
      ),
      GoRoute(
        path: AppRoutes.logoutConfirm,
        builder: (_, __) => const LogoutConfirmScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (_, __) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.changePasswordSuccess,
        builder: (_, __) => const ChangePasswordSuccessScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          '404 - Page Not Found\n${state.uri.path}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent),
        ),
      ),
    ),
  );
}
