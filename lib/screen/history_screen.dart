import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int _selectedIndex = 1; // "Riwayat" aktif

  final Map<int, List<String>> data = {
    2025: [
      "Oktober",
      "September",
      "Agustus",
      "Juli",
      "Juni",
      "Mei",
      "April",
      "Maret",
      "Februari",
      "Januari",
    ],
    2024: [
      "Desember",
      "November",
      "Oktober",
      "September",
      "Agustus",
    ],
  };

  // =============== BOTTOM NAV ACTION ==================

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/profile'); // kalau belum ada, buat nanti
        break;
    }
  }

  // =============== RESPONSIVE BOTTOM NAVBAR ===============

  Widget buildNavbar(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.065;
    double bubbleSize = MediaQuery.of(context).size.width * 0.12;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(context, 0, "Beranda", "assets/icons/home.png",
              iconSize, bubbleSize),
          navItem(context, 1, "Riwayat", "assets/icons/history.png",
              iconSize, bubbleSize),
          navItem(context, 2, "Profil", "assets/icons/profile.png",
              iconSize, bubbleSize),
        ],
      ),
    );
  }

  Widget navItem(BuildContext context, int index, String label, String iconPath,
      double iconSize, double bubbleSize) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // BUBBLE + ICON
          Container(
            width: bubbleSize,
            height: bubbleSize,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xff7c9cff) : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // LABEL
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? const Color(0xff5a78c9) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================

  @override
  Widget build(BuildContext context) {
    double titleSize = MediaQuery.of(context).size.width * 0.055;

    return Scaffold(
      backgroundColor: const Color(0xffe3efff),

      // =========== BODY =============
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xff5a78c9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "StockFlow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5a78c9),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Riwayat Aktivitas",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(child: buildTimeline()),
            ],
          ),
        ),
      ),

      // ========== BOTTOM NAVBAR ==========
      bottomNavigationBar: buildNavbar(context),
    );
  }

  // ========== TIMELINE ==========

  Widget buildTimeline() {
    return ListView(
      children: data.entries.map((entry) {
        int year = entry.key;
        List<String> months = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$year",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // List bulan
            Column(
              children: months.map((month) => buildTimelineItem(month)).toList(),
            ),

            const SizedBox(height: 25),
          ],
        );
      }).toList(),
    );
  }

  Widget buildTimelineItem(String month) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 2,
              height: 20,
              color: const Color(0xff5a78c9),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xff5a78c9),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),

        const SizedBox(width: 15),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xff5a78c9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            month,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
