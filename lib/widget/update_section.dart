import 'package:flutter/material.dart';
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
          const Text(
            "Update terbaru",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.local_fire_department, color: AppColors.red),
                  SizedBox(height: 4),
                  Text("Terlaris hari ini:", style: TextStyle(color: AppColors.textMuted)),
                  Text("Powerbank (15)", style: TextStyle(fontWeight: FontWeight.w600)),
                  Text("Kabel USB (20)", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber_rounded, color: AppColors.red),
                  SizedBox(height: 4),
                  Text("Hampir habis:", style: TextStyle(color: AppColors.textMuted)),
                  Text("Headset Gaming (12)", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.red)),
                  Text("Monitor LED (10)", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
