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
    return 0; // default: home
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
    // Ambil lokasi rute dari GoRouterState
    final state = GoRouterState.of(context);
    final index = _indexFromLocation(state.uri.toString());

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: index,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
