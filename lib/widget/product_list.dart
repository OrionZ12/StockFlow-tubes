import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProductList extends StatelessWidget {
  final List products;

  const ProductList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Responsif font
        double titleFont = width < 340 ? 13 : 15;
        double descFont = width < 340 ? 11 : 12;
        double chipFont = width < 340 ? 11 : 13;

        return Column(
          children: [
            // =============================
            // HEADER TABEL
            // =============================
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.softBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Produk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFont,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Jumlah",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFont,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // =============================
            // LIST PRODUK – SCROLL ONLY HERE
            // =============================
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final name = products[i][0];
                  final desc = products[i][1];
                  final qty = products[i][2];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.softBorder),
                    ),
                    child: Row(
                      children: [
                        // PRODUK + DESKRIPSI
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: titleFont,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                desc,
                                style: TextStyle(
                                  fontSize: descFont,
                                  color: Colors.grey.shade600,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // JUMLAH DALAM CHIP BIRU
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: width < 340 ? 10 : 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueMain,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$qty",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: chipFont,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
