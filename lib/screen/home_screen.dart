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
    final screen = MediaQuery.of(context).size;
    final w = screen.width;
    final h = screen.height;

    final auth = context.watch<AuthProvider>();
    final role = auth.role;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.02,
                w * 0.04,
                h * 0.15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWidget(),
                  SizedBox(height: h * 0.015),

                  const UpdateSection(),
                  SizedBox(height: h * 0.015),

                  const SearchSection(),
                  SizedBox(height: h * 0.015),

                  // ⬇ Kotak putih besar + scroll list
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.softBorder),
                      ),
                      child: ProductList(products: products),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Button
            Positioned(
              right: w * 0.04,
              bottom: h * 0.12,
              child: _floatingButton(w),
            ),

            // Role button
            Positioned(
              left: w * 0.04,
              right: w * 0.04,
              bottom: w * 0.04,
              child: _roleButton(role, w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingButton(double w) {
    return Container(
      width: w * 0.15,
      height: w * 0.15,
      decoration: const BoxDecoration(
        color: AppColors.blueMain,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        iconSize: w * 0.07,
        onPressed: () {},
      ),
    );
  }

  Widget _roleButton(String role, double w) {
    if (role == "staff") {
      return _roleBtn(AppColors.blueMain, "Staff: Input Barang Masuk", w);
    }
    if (role == "whmanager") {
      return _roleBtn(Colors.green, "Manager: Tambah Supplier", w);
    }
    return _roleBtn(Colors.orange, "Admin: Kelola Pengguna", w);
  }

  Widget _roleBtn(Color color, String text, double w) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: w * 0.035),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
        ),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(fontSize: w * 0.04),
      ),
    );
  }
}
