import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationStaffPage extends StatelessWidget {
  const NotificationStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final titleSize = width * 0.055;

    return Scaffold(
      backgroundColor: const Color(0xffe3efff), // ✅ page sendiri
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(), // 🔥 BALIK KE HOME
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xff5a78c9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                      const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Stock",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Flow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5a78c9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Notifikasi",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ================= LIST =================
              Expanded(
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(12),
                      child: const Text("Contoh Notifikasi"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
