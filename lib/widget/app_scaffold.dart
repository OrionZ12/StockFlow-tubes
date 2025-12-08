import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav_bar.dart';
import '../config/routes.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  // Menentukan index menu berdasarkan lokasi router
  int _indexFromLocation(String location) {
    // Semua halaman yang masih “bagian dari profil”
    if (location.startsWith(AppRoutes.profile) ||
        location.startsWith(AppRoutes.account) ||
        location.startsWith(AppRoutes.notificationSettings) ||
        location.startsWith(AppRoutes.changePassword)) {
      return 2; // Profil
    }

    // Halaman riwayat
    if (location.startsWith(AppRoutes.history)) return 1;

    // Default: beranda
    return 0;
  }

  // Navigasi bottom nav
  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.history);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final currentIndex = _indexFromLocation(routerState.uri.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
