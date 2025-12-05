import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../theme/app_colors.dart';

// Widgets
import '../widget/header_widget.dart';
import '../widget/update_section.dart';
import '../widget/search_section.dart';
import '../widget/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final products = const [
    ["Mouse Wireless", "Mouse Bluetooth 2.4GHz, warna hitam", 54],
    ["Kabel USB", "Kabel USB-A ke USB-C, panjang 2 m", 44],
    ["Keyboard Gaming", "Keyboard gaming mekanis dengan RGB", 23],
    ["Monitor LED", "Full HD 24 inch, refresh rate 75Hz", 10],
    ["Flashdisk", "USB 3.0 kapasitas 64GB, warna silver", 103],
    ["Harddisk Eksternal", "USB 3.1 kapasitas 1TB, casing hitam", 88],
    ["Powerbank", "10000mAh fast charging, warna putih", 98],
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.role;

    return SafeArea(
      child: Container(
        color: AppColors.pageBackground,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 140),
              children: [
                const HeaderWidget(),
                const SizedBox(height: 14),

                const UpdateSection(),
                const SizedBox(height: 14),

                const SearchSection(),
                const SizedBox(height: 14),

                ProductList(products: products),
                const SizedBox(height: 120), // ruang agar tidak ketutupan role button
              ],
            ),

            Positioned(
              right: 16,
              bottom: 80,
              child: _floatingButton(),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _roleButton(role),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.blueMain,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () {},
      ),
    );
  }

  Widget _roleButton(String role) {
    if (role == "staff") {
      return _roleBtn(AppColors.blueMain, "Staff: Input Barang Masuk");
    }
    if (role == "whmanager") {
      return _roleBtn(Colors.green, "Manager: Tambah Supplier");
    }
    return _roleBtn(Colors.orange, "Admin: Kelola Pengguna");
  }

  Widget _roleBtn(Color color, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
