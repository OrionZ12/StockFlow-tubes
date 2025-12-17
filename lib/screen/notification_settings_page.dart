import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav_bar.dart';
import '../config/routes.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool notificationEffectOn = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: const Color(0xFFE6EDFE),
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.profile),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A78C9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Stock",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Flow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A6ACF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ===== SINGLE TOGGLE CARD =====
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Aktifkan Efek Notifikasi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: notificationEffectOn,
                      onChanged: (v) {
                        setState(() => notificationEffectOn = v);

                        // nanti disimpan ke SharedPreferences / Provider
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                "Catatan: Notifikasi tetap masuk ke aplikasi meskipun efek dimatikan.",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
