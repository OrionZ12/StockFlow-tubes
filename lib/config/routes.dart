import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes/screen/history_screen.dart';
import 'package:tubes/screen/notification_screen.dart';
import 'package:tubes/screen/profile_screen.dart';

import '../screen/splash_screen.dart';
import '../screen/firstime_screen.dart';
import '../screen/login_screen.dart';
import '../screen/signin_screen.dart';
import '../screen/signsuc_screen.dart';
import '../screen/home_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String firstTime = '/firstime';
  static const String login = '/login';
  static const String signIn = '/signin';
  static const String signSuccess = '/signsuccess';
  static const String home = '/home';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String profile = '/profile';
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
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.firstTime,
        name: 'firstime',
        builder: (context, state) => const FirstTimeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signin',
        builder: (context, state) => const SigninScreen(),
      ),
      GoRoute(
        path: AppRoutes.signSuccess,
        name: 'signsuccess',
        builder: (context, state) => const SuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        name: 'history',
        builder: (context, state) => RiwayatPage(),
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: 'notification',
        builder: (context, state) => const NotificationStaffPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('Path: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
