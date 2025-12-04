import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes/screen/history_screen.dart';
import 'package:tubes/screen/notification_screen.dart';
import 'package:tubes/screen/profile_screen.dart';
import 'package:tubes/screen/account_screen.dart';
import 'package:tubes/screen/signup_screen.dart';

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
  // HAPUS BARIS INI KARENA TIDAK DIPAKAI DAN BIKIN ERROR:
  // static const String signIn = '/signin';

  static const String signSuccess = '/signsuccess';
  static const String home = '/home';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String profile = '/profile';
  static const String account = '/account';
  static const String signUp = '/signup';
}

GoRouter createRouter() {
  final GlobalKey<NavigatorState> rootNavigatorKey =
  GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Rute SignUp sudah benar ada di sini
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.firstTime,
        builder: (context, state) => const FirstTimeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signSuccess,
        builder: (context, state) => const SuccessScreen(),
      ),

      // ========== SCREEN UTAMA ==========
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) =>
        const AppScaffold(child: HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) =>
        const AppScaffold(child: HistoryPage()),
      ),
      GoRoute(
        path: AppRoutes.notification,
        builder: (context, state) =>
        const AppScaffold(child: NotificationStaffPage()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) =>
        const AppScaffold(child: ProfilePage()),
      ),
      GoRoute(
        path: AppRoutes.account,
        builder: (context, state) =>
        const AppScaffold(child: AccountPage()),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('404 Page not found: ${state.uri.path}')),
    ),
  );
}