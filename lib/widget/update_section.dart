import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../theme/app_colors.dart';

class UpdateSection extends StatelessWidget {
  const UpdateSection({super.key});

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
          // ====== Judul + tombol lonceng ======
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Update terbaru",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              // Tombol lonceng
              GestureDetector(
                onTap: () => context.go(AppRoutes.notification),
                child: Container(
                  width: 32,
                  height: 32,
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
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ====== Dua kolom isi ======
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kolom kiri
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.local_fire_department, color: AppColors.red),
                  SizedBox(height: 4),
                  Text(
                    "Terlaris hari ini:",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  Text("Powerbank (15)",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Text("Kabel USB (20)",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),

              // Kolom kanan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber_rounded, color: AppColors.red),
                  SizedBox(height: 4),
                  Text(
                    "Hampir habis:",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  Text(
                    "Headset Gaming (12)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.red,
                    ),
                  ),
                  Text(
                    "Monitor LED (10)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.red,
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
