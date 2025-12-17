import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String filterMode = "day"; // day | month
  String expandedMonth = "";

  String _formatDate(DateTime d) =>
      "${d.day}/${d.month}/${d.year}";

  String _monthName(int m) {
    const months = [
      "", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return months[m];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      child: Column(
        children: [

          // ================= HEADER =================
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 40, 18, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Row(
                  children: [
                    Text("Stock",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    Text("Flow",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueMain)),
                  ],
                ),

                DropdownButton(
                  value: filterMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: "day", child: Text("Per Hari")),
                    DropdownMenuItem(
                        value: "month", child: Text("Per Bulan")),
                  ],
                  onChanged: (v) => setState(() => filterMode = v!),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("history")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("Belum ada riwayat"),
                  );
                }

                // ================= PER HARI =================
                if (filterMode == "day") {
                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final item =
                      docs[index].data() as Map<String, dynamic>;
                      final isLast = index == docs.length - 1;

                      final time =
                      (item["timestamp"] as Timestamp).toDate();

                      return _timelineCard(item, time, isLast);
                    },
                  );
                }

                // ================= PER BULAN =================
                Map<String, List<Map<String, dynamic>>> grouped = {};

                for (var d in docs) {
                  final data = d.data() as Map<String, dynamic>;
                  final time =
                  (data["timestamp"] as Timestamp).toDate();
                  final key =
                      "${_monthName(time.month)} ${time.year}";

                  grouped.putIfAbsent(key, () => []);
                  grouped[key]!.add(data);
                }

                return ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18),
                  children: grouped.entries.map((entry) {
                    final isOpen = expandedMonth == entry.key;

                    return Column(
                      children: [

                        // ===== BULAN CARD =====
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedMonth =
                              isOpen ? "" : entry.key;
                            });
                          },
                          child: Container(
                            margin:
                            const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(isOpen
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                              ],
                            ),
                          ),
                        ),

                        // ===== ISI BULAN =====
                        if (isOpen)
                          ...entry.value.map((item) {
                            final time =
                            (item["timestamp"] as Timestamp)
                                .toDate();
                            return _timelineCard(
                                item, time, true);
                          }),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= TIMELINE CARD =================
  Widget _timelineCard(
      Map<String, dynamic> item, DateTime time, bool isLast) {
    final type = item["type"];
    final user = item["username"] ?? "unknown";
    final qty = item["qty_change"] ?? 0;
    final product = item["item_name"] ?? "-";

    String title = "";
    if (type == "in") title = "Barang Masuk";
    if (type == "out") title = "Barang Keluar";
    if (type == "add") title = "Barang Baru";
    if (type == "delete") title = "Barang Dihapus";

    String action = "";
    if (type == "in") action = "menambahkan";
    if (type == "out") action = "mengeluarkan";
    if (type == "add") action = "membuat";
    if (type == "delete") action = "menghapus";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.blueSoft,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 90,
                color: AppColors.blueSoft,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(time),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted)),
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  "$user $action ${qty.abs()} $product",
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
