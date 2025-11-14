import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe3efff),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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

              const Text(
                "Riwayat Aktivitas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(child: buildTimeline()),
            ],
          ),
        ),
      ),
    );
  }

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
        // Garis timeline
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
              decoration: BoxDecoration(
                color: const Color(0xff5a78c9),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),

        // Label Bulan
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