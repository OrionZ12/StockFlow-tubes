import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/routes.dart';

class ChangePasswordSuccessScreen extends StatelessWidget {
  const ChangePasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EDFE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol back
              GestureDetector(
                onTap: () => context.go(AppRoutes.profile),
                child: Container(
                  width: 40,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A6ACF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Icon centang besar di tengah
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A6ACF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Teks konfirmasi
              const Center(
                child: Text(
                  'Pengajuan kata sandi berhasil\n'
                      'Silahkan tunggu konfirmasi melalui email\n'
                      'atau nomor HP anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
