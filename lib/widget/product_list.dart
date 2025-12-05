import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProductList extends StatelessWidget {
  final List<List> products;

  const ProductList({super.key, required this.products});

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
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Produk", style: TextStyle(fontWeight: FontWeight.w600)),
              Text("Jumlah", style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(height: 20),

          // -----------------------------
          // EMPTY STATE
          // -----------------------------
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: const [
                  Icon(Icons.inbox, size: 40, color: AppColors.textMuted),
                  SizedBox(height: 10),
                  Text(
                    "Tidak ada produk",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            ...products.map((item) => ProductItem(data: item)).toList(),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final List data;

  const ProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data[0], style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                data[1],
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
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
}
