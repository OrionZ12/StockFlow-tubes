import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

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
    double iconSize = MediaQuery.of(context).size.width * 0.065;
    double bubbleSize = MediaQuery.of(context).size.width * 0.13;

    final items = [
      _NavItem("Beranda", "assets/icons/home_icon.png"),
      _NavItem("Riwayat", "assets/icons/history_icon.png"),
      _NavItem("Profil", "assets/icons/profil_icon.png"),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = currentIndex == i;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: bubbleSize,
                  height: bubbleSize,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.blueSoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Image.asset(
                      items[i].icon,
                      width: iconSize,
                      color: isActive ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items[i].label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                    color:
                    isActive ? AppColors.blueMedium : Colors.black87,
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  _NavItem(this.label, this.icon);
}
