import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==== Import Screens ====
import 'package:tubes/screen/history_screen.dart';
import 'package:tubes/screen/notification_screen.dart';
import 'package:tubes/screen/profile_screen.dart';
import 'package:tubes/screen/account_screen.dart';
import 'package:tubes/screen/signup_screen.dart';
import 'package:tubes/screen/logout_confirm_screen.dart';
import 'package:tubes/screen/notification_settings_page.dart';
import 'package:tubes/screen/change_password_screen.dart';
import 'package:tubes/screen/change_password_success_screen.dart';
import 'package:tubes/screen/addstock_screen.dart';
import 'package:tubes/screen/signsuc_screen.dart';

import '../screen/splash_screen.dart';
import '../screen/firstime_screen.dart';
import '../screen/login_screen.dart';
import '../screen/userverification_screen.dart';
import '../screen/home_screen.dart';

import '../widget/app_scaffold.dart';

// =========================
// ROUTES CONST
// =========================
class AppRoutes {
  static const splash = '/splash';
  static const firstTime = '/firstime';
  static const login = '/login';
  static const signUp = '/signup';
  static const signSuccess = '/signsuccess';

  // Bottom Nav
  static const home = '/home';
  static const history = '/history';
  static const profile = '/profile';

  // Profile children
  static const account = '/account';
  static const changePassword = '/change-password';

  // Other
  static const notification = '/notification';
  static const notificationSettings = '/notification-settings';
  static const changePasswordSuccess = '/change-password-success';
  static const logoutConfirm = '/logout-confirm';
  static const userVerification = '/user-verification';
  static const addStock = '/addstock';
}

// =========================
// ROUTER
// =========================
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [

      // =============================
      // NO NAVBAR SCREENS
      // =============================
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
        builder: (_, __) => const SignsucScreen(),
      ),
      GoRoute(
        path: AppRoutes.userVerification,
        builder: (_, __) => const UserVerificationPage(),
      ),

      // =============================
      // MAIN AREA (WITH BOTTOM NAV)
      // =============================
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [

          // TAB 0 — HOME
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),

          // TAB 1 — HISTORY
          GoRoute(
            path: AppRoutes.history,
            builder: (_, __) => const HistoryPage(),
          ),

          // TAB 2 — PROFILE
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfilePage(),
          ),

          // STILL PROFILE TAB
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

      // =============================
      // OUTSIDE NAVBAR
      // =============================
      GoRoute(
        path: AppRoutes.notification,
        builder: (_, __) => const NotificationStaffPage(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (_, __) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.changePasswordSuccess,
        builder: (_, __) => const ChangePasswordSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.logoutConfirm,
        builder: (_, __) => const LogoutConfirmScreen(),
      ),
      GoRoute(
        path: AppRoutes.addStock,
        builder: (_, __) => const AddStockPage(),
      ),
    ],

    // =============================
    // ERROR PAGE
    // =============================
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          "404 - Page Not Found\n${state.uri.path}",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      ),
    ),
  );
}
