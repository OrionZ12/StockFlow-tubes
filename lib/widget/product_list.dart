import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProductList extends StatelessWidget {
  final List<List<dynamic>> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(height: 20),
      itemBuilder: (context, i) {
        final title = products[i][0];
        final desc  = products[i][1];
        final qty   = products[i][2];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 TEKS — dibuat Expanded supaya wrap & tidak overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: w * 0.035,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: w * 0.03),

            // 🔵 BADGE JUMLAH
            Container(
              padding: EdgeInsets.symmetric(
                vertical: w * 0.015,
                horizontal: w * 0.04,
              ),
              decoration: BoxDecoration(
                color: AppColors.blueMain,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "$qty",
                style: TextStyle(
                  fontSize: w * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
