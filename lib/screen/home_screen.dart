import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../theme/app_colors.dart';

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
    final role = auth.role; // <-- ambil role dari provider

    return Container(
      color: AppColors.pageBackground,
      child: Stack(
        children: [
          // MAIN CONTENT
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 140),
            children: [
              _header(),
              const SizedBox(height: 14),
              _updateSection(),
              const SizedBox(height: 14),
              _searchSection(),
              const SizedBox(height: 14),
              _productList(),
            ],
          ),

          // FLOATING BUTTON
          Positioned(
            right: 16,
            bottom: 80,
            child: _floatingButton(),
          ),

          // ROLE-BASED BUTTON
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _roleButton(role), // <-- kirim role
          ),
        ],
      ),
    );
  }

  // --- HEADER ---
  Widget _header() {
    return const Row(
      children: [
        Text(
          "Stock",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          "Flow",
          style: TextStyle(
            color: AppColors.blueMain,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  // --- UPDATE SECTION ---
  Widget _updateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Update terbaru",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TERLARIS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.local_fire_department, color: AppColors.red),
                  SizedBox(height: 4),
                  Text("Terlaris hari ini:", style: TextStyle(color: AppColors.textMuted)),
                  Text("Powerbank (15)", style: TextStyle(fontWeight: FontWeight.w600)),
                  Text("Kabel USB (20)", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),

              // HAMPIR HABIS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber_rounded, color: AppColors.red),
                  SizedBox(height: 4),
                  Text("Hampir habis:", style: TextStyle(color: AppColors.textMuted)),
                  Text("Headset Gaming (12)", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.red)),
                  Text("Monitor LED (10)", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SEARCH ---
  Widget _searchSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.softBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20, color: AppColors.textMuted),
                SizedBox(width: 10),
                Text("Cari Produk", style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.softBorder),
          ),
          child: const Row(
            children: [
              Text("Semua Kategori", style: TextStyle(color: AppColors.textMuted)),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ],
    );
  }

  // --- PRODUCT LIST ---
  Widget _productList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Produk", style: TextStyle(fontWeight: FontWeight.w600)),
              Text("Jumlah", style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(height: 20),
          ...products.map((p) => _productItem(p)).toList(),
        ],
      ),
    );
  }

  Widget _productItem(List data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product name + desc
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data[0], style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(data[1], style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),

          // Count badge
          Container(
            width: 40,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.blueSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              data[2].toString(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }

  // --- FLOATING BUTTON ---
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

  // --- ROLE BASED BUTTON ---
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
