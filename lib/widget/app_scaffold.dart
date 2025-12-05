import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav_bar.dart';
import '../config/routes.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  /// Menentukan index menu berdasarkan lokasi router
  int _indexFromLocation(String location) {
    // Semua halaman profil termasuk /profile dan /account
    if (location.startsWith(AppRoutes.profile) ||
        location.startsWith(AppRoutes.account)) {
      return 2;
    }

    if (location.startsWith(AppRoutes.history)) return 1;

    return 0; // Default beranda
  }

  /// Navigasi bottom nav
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
    // Ambil lokasi route aktif
    final routerState = GoRouterState.of(context);
    final currentIndex = _indexFromLocation(routerState.uri.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),

      // Tampilan halaman dinamis
      body: SafeArea(child: child),

      // Bottom Navigation Bar (TIDAK DOUBLE)
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
