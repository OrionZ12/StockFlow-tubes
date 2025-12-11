import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';

class UpdateSection extends StatefulWidget {
  const UpdateSection({super.key});

  @override
  State<UpdateSection> createState() => _UpdateSectionState();
}

class _UpdateSectionState extends State<UpdateSection> {
  List<Map<String, dynamic>> terlaris = [];
  List<Map<String, dynamic>> hampirHabis = [];

  @override
  void initState() {
    super.initState();
    _loadTopProducts();
  }

  // =====================================================
  // AMBIL 2 ITEM TERLARIS & 2 ITEM HAMPIR HABIS
  // =====================================================
  Future<void> _loadTopProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("items").get();

      final List<Map<String, dynamic>> allItems = snapshot.docs
          .map((doc) => {
                "name": doc["name"],
                "stok": doc["stok"],
              })
          .toList();

      // Sort stok besar → kecil (terlaris)
      allItems.sort((a, b) => (b["stok"] as int).compareTo(a["stok"]));

      // Ambil 2 terbesar
      terlaris = allItems.take(2).toList();

      // Sort stok kecil → besar (hampir habis)
      final List<Map<String, dynamic>> sortedLow = allItems
          .where((item) => item["stok"] > 0) // hanya stok > 0
          .toList();

      sortedLow.sort((a, b) => (a["stok"] as int).compareTo(b["stok"]));

      // Ambil 2 terkecil
      hampirHabis = sortedLow.take(2).toList();

      setState(() {});
    } catch (e) {
      print("Error loading update section: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // ====== JUDUL ======
          const Text(
            "Update terbaru",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          // =====================================================
          // ROW TERLARIS & HAMPIR HABIS
          // =====================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // =================== TERLARIS ===================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.local_fire_department,
                      color: AppColors.red),
                  const SizedBox(height: 4),
                  const Text(
                    "Stok Terbanyak:",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  ...terlaris.map(
                    (item) => Text(
                      "${item['name']} (${item['stok']})",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              // ================== HAMPIR HABIS ==================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.red),
                  const SizedBox(height: 4),
                  const Text(
                    "Hampir habis:",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  ...hampirHabis.map(
                    (item) => Text(
                      "${item['name']} (${item['stok']})",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
