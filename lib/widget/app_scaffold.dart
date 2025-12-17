import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav_bar.dart';
import '../config/routes.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const AppScaffold({
    super.key,
    required this.child,
    required this.state,
  });

  int _indexFromLocation(String location) {
  if (location.startsWith(AppRoutes.home)) return 0;

  if (location.startsWith(AppRoutes.history)) return 1;

  if (location.startsWith(AppRoutes.profile) ||
      location.startsWith(AppRoutes.account) ||
      location.startsWith(AppRoutes.changePassword) ||
      location.startsWith(AppRoutes.notification)) {
    return 2; // ✅ PROFIL
  }

  return 0;
}


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
    final currentIndex = _indexFromLocation(state.uri.toString());

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

