import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav_bar.dart';
import '../config/routes.dart';

/// ====== WARNA SESUAI PALET FIGMA ======
const Color kPageBackground = Color(0xFFE0EBFD); // E0EBFD
const Color kCardBackground = Color(0xFFFFFFFF); // FFFFFF
const Color kSoftBorder     = Color(0xFFD3DBED); // D3DBED

const Color kTextPrimary    = Color(0xFF000000); // 000000
const Color kTextSecondary  = Color(0xFF474747); // 474747
const Color kTextMuted      = Color(0xFF929292); // 929292

const Color kBlueMain       = Color(0xFF5572DE); // badge jumlah
const Color kBlueSoft       = Color(0xFF7B94F3); // bubble nav
const Color kBlueMedium     = Color(0xFF506DB8); // icon search, v, FAB luar
const Color kBlueTitle      = Color(0xFF2D4990); // “Terlaris hari ini”, “Hampir habis”

const Color kGreen          = Color(0xFF0E7A44); // teks hijau
const Color kRed            = Color(0xFFD23737); // teks merah

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /// === DUMMY DATA UNTUK TAMPILAN (bisa diganti model nanti) ===
  final List<_ProductData> _dummyProducts = const [
    _ProductData(
      name: 'Mouse Wireless',
      description: 'Mouse Bluetooth 2.4GHz, warna hitam',
      quantity: 54,
    ),
    _ProductData(
      name: 'Kabel USB',
      description: 'Kabel USB-A ke USB-C, panjang 2 m',
      quantity: 44,
    ),
    _ProductData(
      name: 'Keyboard Gaming',
      description: 'Keyboard gaming mekanis dengan RGB',
      quantity: 23,
    ),
    _ProductData(
      name: 'Monitor LED',
      description: 'Full HD 24 inch, refresh rate 75Hz',
      quantity: 10,
    ),
    _ProductData(
      name: 'Flashdisk',
      description: 'USB 3.0 kapasitas 64GB, warna silver',
      quantity: 102,
    ),
    _ProductData(
      name: 'Harddisk Eksternal',
      description: 'USB 3.1 kapasitas 1TB, casing hitam',
      quantity: 64,
    ),
    _ProductData(
      name: 'Powerbank',
      description: '10000mAh fast charging, warna putih',
      quantity: 98,
    ),
    _ProductData(
      name: 'Charger Laptop',
      description: '65W USB-C Power Delivery, kabel 1.5 m',
      quantity: 12,
    ),
    _ProductData(
      name: 'Speaker Bluetooth',
      description: 'Stereo portable, baterai 12 jam',
      quantity: 16,
    ),
    _ProductData(
      name: 'Kabel HDMI',
      description: 'HDMI 2.1 ke HDMI, panjang 3 m',
      quantity: 202,
    ),
    _ProductData(
      name: 'Webcam',
      description: 'Resolusi Full HD 1080p, built-in mikrofon',
      quantity: 16,
    ),
  ];

  // ====== BOTTOM NAV TAP ======
  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      context.go(AppRoutes.home);
    } else if (index == 1) {
      context.go(AppRoutes.history);
    } else if (index == 2) {
      context.go('/profile'); // nanti kamu tambahin route-nya
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              const _UpdateCard(),
              const SizedBox(height: 16),
              const _SearchAndFilterRow(),
              const SizedBox(height: 16),
              Expanded(
                child: _ProductTableCard(products: _dummyProducts),
              ),
            ],
          ),
        ),
      ),

      // FAB '+' di kanan bawah seperti di Figma
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          onPressed: () {
            // ke page tambah barang nanti
          },
          backgroundColor: kBlueMedium, // luaran 506DB8
          shape: const CircleBorder(),
          child: Container(
            decoration: const BoxDecoration(
              color: kBlueMain, // dalam 5572DE
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.add, size: 24, color: Colors.white),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// ====== KARTU UPDATE TERBARU ======
class _UpdateCard extends StatelessWidget {
  const _UpdateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kSoftBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            children: [
              const Text(
                'Update terbaru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.notifications_none_rounded,
                color: kTextSecondary,
                size: 20,
              ),
            ],
          ),

          // GARIS ABU-ABU DI BAWAH HEADER
          const SizedBox(height: 6),
          const Divider(height: 1, color: kSoftBorder),
          const SizedBox(height: 10),

          // dua kolom status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: _UpdateText(
                  icon: Icons.local_shipping_outlined, // ikon truk
                  title: 'Terlaris hari ini:',
                  lines: ['Powerbank (15)', 'Kabel USB (20)'],
                  color: kGreen,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _UpdateText(
                  icon: Icons.warning_amber_rounded,
                  title: 'Hampir habis',
                  lines: ['Headset Gaming (12)', 'Monitor LED (10)'],
                  color: kRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpdateText extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  final Color color;

  const _UpdateText({
    required this.icon,
    required this.title,
    required this.lines,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: kBlueTitle),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // judul biru 2D4990
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kBlueTitle,
                ),
              ),
              // isi hijau/merah
              for (final line in lines)
                Text(
                  line,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: color,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ====== SEARCH + FILTER BAR ======
class _SearchAndFilterRow extends StatelessWidget {
  const _SearchAndFilterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search
        Expanded(
          flex: 2,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: kCardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kSoftBorder),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.search,
                  size: 18,
                  color: kBlueMedium, // 506DB8
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Cari Produk',
                    style: TextStyle(
                      fontSize: 12,
                      color: kTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Filter kategori
        Expanded(
          flex: 2,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: kCardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kSoftBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Semua Kategori',
                  style: TextStyle(
                    fontSize: 12,
                    color: kTextSecondary,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: kBlueMedium, // 506DB8
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ====== KARTU TABEL PRODUK ======
class _ProductTableCard extends StatelessWidget {
  final List<_ProductData> products;

  const _ProductTableCard({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kSoftBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // header
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Produk',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Jumlah',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kSoftBorder),

          // list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              itemBuilder: (context, index) =>
                  _ProductRow(product: products[index]),
              separatorBuilder: (_, __) =>
              const Divider(height: 16, color: kSoftBorder),
              itemCount: products.length,
            ),
          ),
        ],
      ),
    );
  }
}
/// ====== SATU BARIS PRODUK ======
class _ProductRow extends StatelessWidget {
  final _ProductData product;

  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // nama + desc
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  color: kTextSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // pill jumlah: lebar fix biar rapi
        SizedBox(
          width: 70, // atur2 dikit kalau mau lebih pas
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: kBlueMain,          // 5572DE
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              product.quantity.toString(),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


/// ====== MODEL DATA DUMMY ======
class _ProductData {
  final String name;
  final String description;
  final int quantity;

  const _ProductData({
    required this.name,
    required this.description,
    required this.quantity,
  });
}
