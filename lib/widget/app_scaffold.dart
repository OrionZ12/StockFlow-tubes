import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav_bar.dart';
import '../config/routes.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.history)) return 1;
    if (location.startsWith(AppRoutes.profile)) return 2;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        if ((GoRouter.of(context) as dynamic).location != AppRoutes.home) {
          context.go(AppRoutes.home);
        }
        break;
      case 1:
        if ((GoRouter.of(context) as dynamic).location != AppRoutes.history) {
          context.go(AppRoutes.history);
        }
        break;
      case 2:
        if ((GoRouter.of(context) as dynamic).location != AppRoutes.profile) {
          context.go(AppRoutes.profile);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil location dengan aman: coba GoRouter, fallback ke Uri.base.path
    final router = GoRouter.of(context);
    final String location = ((router as dynamic).location as String?) ?? Uri.base.path;

    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}
