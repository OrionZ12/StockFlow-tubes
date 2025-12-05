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
      case 0: context.go(AppRoutes.home); break;
      case 1: context.go(AppRoutes.history); break;
      case 2: context.go(AppRoutes.profile); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final index = _indexFromLocation(state.uri.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF), // supaya mirip UI awal
      body: SafeArea(
        child: child, // jangan dibungkus yang aneh-aneh di sini
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: index,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
