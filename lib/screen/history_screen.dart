import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  String _formatDate(DateTime d) =>
      "${d.day}/${d.month}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ================= HEADER =================
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 40, 18, 10),
            child: Row(
              children: const [
                Text(
                  "Stock",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Flow",
                  style: TextStyle(
                    color: AppColors.blueMain,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("history")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.blueMain),
                  );
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada riwayat...",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item =
                    docs[index].data() as Map<String, dynamic>;
                    final isLast = index == docs.length - 1;

                    final DateTime time =
                    (item["timestamp"] as Timestamp).toDate();

                    final String type = item["type"];
                    final String user =
                        item["username"] ?? "unknown";
                    final int qty =
                        item["qty_change"] ?? 0;
                    final String product =
                        item["item_name"] ?? "-";

                    String title = "";
                    if (type == "in") title = "Barang Masuk";
                    if (type == "out") title = "Barang Keluar";
                    if (type == "add") title = "Barang Baru";
                    if (type == "delete") title = "Barang Dihapus";

                    String action = "";
                    if (type == "in") action = "menambahkan";
                    if (type == "out") action = "mengeluarkan";
                    if (type == "add") action = "membuat barang";
                    if (type == "delete") action = "menghapus barang";

                    final desc =
                        "$user $action ${qty.abs()} $product";

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ===== TIMELINE =====
                        Column(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.blueSoft,
                                borderRadius:
                                BorderRadius.circular(20),
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

                        // ===== CARD =====
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                _showDetail(context, item),
                            child: Container(
                              margin:
                              const EdgeInsets.only(bottom: 18),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(18),
                                border: Border.all(
                                    color: AppColors.softBorder),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  // ===== TANGGAL (ATAS) =====
                                  Text(
                                    _formatDate(time),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // ===== TITLE =====
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      AppColors.textPrimary,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  // ===== DESKRIPSI =====
                                  Text(
                                    desc,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= DETAIL =================
  void _showDetail(BuildContext context, Map<String, dynamic> item) {
    final DateTime time =
    (item["timestamp"] as Timestamp).toDate();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Aktivitas",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text("User: ${item["username"]}"),
            Text("Jenis: ${item["type"]}"),
            Text("Jumlah: ${item["qty_change"]}"),
            Text("Barang: ${item["item_name"]}"),
            Text("Waktu: $time"),
          ],
        ),
      ),
    );
  }
}
