import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/routes.dart';
import '../provider/auth_provider.dart';
import '../theme/app_colors.dart';

class LogoutConfirmScreen extends StatelessWidget {
  const LogoutConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF9FA3AD), // abu2 seperti figma
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Stock',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: 'Flow',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5A6ACF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                  _menuBackground('Ganti Kata Sandi'),
                  const SizedBox(height: 12),
                  _menuBackground('Keluar Akun'),
                ],
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width * 0.78,
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Apakah anda yakin ingin keluar dari akun?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.32,
                        height: 48,
                        child: GestureDetector(
                          onTap: () async {
                            await context.read<AuthProvider>().signOut();
                            if (!context.mounted) return;
                            context.go(AppRoutes.login);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7CF269), // hijau bright
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'YA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                      SizedBox(
                        width: width * 0.32,
                        height: 48,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3D2E), // merah bright
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'TIDAK',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _menuBackground(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.softBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
