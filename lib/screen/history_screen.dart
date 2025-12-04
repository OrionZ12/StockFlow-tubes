import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  final List<Map<String, dynamic>> historyItems = const [
    {
      "title": "Barang Masuk",
      "desc": "Menambahkan 30 unit Mouse Wireless",
      "date": "4 Jan 2025"
    },
    {
      "title": "Barang Keluar",
      "desc": "Mengeluarkan 5 unit Keyboard Gaming",
      "date": "4 Jan 2025"
    },
    {
      "title": "Stok Diupdate",
      "desc": "Monitor LED ditambah 12 unit",
      "date": "3 Jan 2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 HEADER (pengganti AppBar, aman tanpa Scaffold)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 40, 18, 10),
            child: Row(
              children: const [
                Text(
                  "Stock",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Flow",
                  style: TextStyle(
                    color: AppColors.blueMain,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🔵 LIST DATA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                final isLast = index == historyItems.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Bullet timeline
                    Column(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.blueSoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 3,
                            height: 70,
                            color: AppColors.blueSoft,
                          ),
                      ],
                    ),

                    const SizedBox(width: 15),

                    // --- Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.softBorder),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["desc"],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item["date"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
