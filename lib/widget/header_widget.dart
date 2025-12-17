import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Stock",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Text(
          "Flow",
          style: TextStyle(
            color: AppColors.blueMain,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        const Spacer(),

        // 🔔 Tombol notifikasi (kanan atas)
        GestureDetector(
          onTap: () => context.push(AppRoutes.notification),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.softBorder),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none,
              color: AppColors.blueMain,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
