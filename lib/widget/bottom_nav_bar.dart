import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsif dengan batas minimal dan maksimal
    double iconSize = (screenWidth * 0.07).clamp(22, 34);
    double fontSize = (screenWidth * 0.035).clamp(10, 16);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            index: 0,
            label: "Beranda",
            iconPath: "assets/icons/home_icon.png",
            isActive: currentIndex == 0,
            iconSize: iconSize,
            fontSize: fontSize,
          ),
          _navItem(
            index: 1,
            label: "Riwayat",
            iconPath: "assets/icons/history_icon.png",
            isActive: currentIndex == 1,
            iconSize: iconSize,
            fontSize: fontSize,
          ),
          _navItem(
            index: 2,
            label: "Profil",
            iconPath: "assets/icons/profil_icon.png",
            isActive: currentIndex == 2,
            iconSize: iconSize,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String label,
    required String iconPath,
    required bool isActive,
    required double iconSize,
    required double fontSize,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 85, // untuk keseimbangan tampilan, tetap responsif di dalamnya
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: isActive
                  ? BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(20),
              )
                  : null,
              child: Image.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
                color: isActive ? Colors.black : Colors.black87,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: isActive ? Colors.black : Colors.black87,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
