import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widget/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

const Color kPageBackground = Color(0xFFE0EBFD); // E0EBFD
const Color kCardBackground = Color(0xFFFFFFFF); // FFFFFF
const Color kSoftBorder = Color(0xFFD3DBED); // D3DBED

const Color kTextPrimary = Color(0xFF000000); // 000000
const Color kTextSecondary = Color(0xFF474747); // 474747
const Color kTextMuted = Color(0xFF929292); // 929292

const Color kBlueMain = Color(0xFF5572DE); // badge jumlah
const Color kBlueSoft = Color(0xFF7B94F3); // bubble nav
const Color kBlueMedium = Color(0xFF506DB8); // icon search, v, FAB luar
const Color kBlueTitle = Color(0xFF2D4990);

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPageBackground,
        centerTitle: false,
        title: const Row(
          children: [
            Text(
              'Stock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kTextPrimary,
              ),
            ),
            Text(
              'Flow',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kBlueMain,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileMenuItem(
                    label: "Informasi Akun",
                    onTap: () {
                      context.go('/account');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    label: "Kelola Notifikasi",
                    onTap: () {
                      // Handle Kelola Notifikasi tap
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    label: "Ganti Kata Sandi",
                    onTap: () {
                      // Handle Ganti Kata Sandi tap
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    label: "Keluar Akun",
                    onTap: () {
                      // Handle Keluar Akun tap
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xffd3dbed), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff474747),
          ),
        ),
      ),
    );
  }
}
