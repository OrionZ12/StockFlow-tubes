import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EDFE), // Sesuai dengan warna di Figma
      appBar: AppBar(
        title: const Text('Profile Page'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul "StockFlow"
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Stock',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Flow',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5A6ACF), // Sesuai dengan warna Figma
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4 Pilihan Menu Profile (Informasi Akun, Kelola Notifikasi, Ganti Kata Sandi, Keluar Akun)
              Column(
                children: const [
                  _ProfileOptionCard(
                    title: 'Informasi Akun',
                  ),
                  SizedBox(height: 8),
                  _ProfileOptionCard(
                    title: 'Kelola Notifikasi',
                  ),
                  SizedBox(height: 8),
                  _ProfileOptionCard(
                    title: 'Ganti Kata Sandi',
                  ),
                  SizedBox(height: 8),
                  _ProfileOptionCard(
                    title: 'Keluar Akun',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOptionCard extends StatelessWidget {
  final String title;

  const _ProfileOptionCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
