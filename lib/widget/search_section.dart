import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchSection extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Function(String) onCategoryChanged;
  final List<String> kategoriList;

  const SearchSection({
    super.key,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.kategoriList,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ================== INPUT SEARCH ====================
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.softBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Cari Produk",
                      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 10),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        // =============== DROPDOWN KATEGORI ==================
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.softBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: "Semua Kategori",
              items: [
                const DropdownMenuItem(
                  value: "Semua Kategori",
                  child: Text("Semua Kategori"),
                ),
                ...kategoriList.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    )),
              ],
              onChanged: (value) => onCategoryChanged(value!),
            ),
          ),
        ),
      ],
    );
  }
}
