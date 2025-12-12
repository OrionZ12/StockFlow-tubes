import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';

class ProductList extends StatelessWidget {
  final List products;
  final String userRole;

  const ProductList({
    super.key,
    required this.products,
    required this.userRole,
  });


  // =====================================================
  // UPDATE STOCK + HISTORY
  // =====================================================
  Future<void> _updateStockInFirestore(
    String itemId,
    String name,
    String desc,
    int newStock,
    int oldStock,
  ) async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final data = userDoc.data() as Map<String, dynamic>;
    final username = data["name"] ?? "unknown";

    int change = newStock - oldStock;
    String type = change > 0 ? "in" : "out";

    // Update stok
    await FirebaseFirestore.instance.collection("items").doc(itemId).update({
      "stok": newStock,
      "last_updated": FieldValue.serverTimestamp(),
      "last_updated_by": uid,
    });

    // Tambah ke history jika ada perubahan
    if (change != 0) {
      FirebaseFirestore.instance.collection("history").add({
        "type": type,
        "item_name": name,
        "item_id": itemId,
        "qty_change": change,
        "final_stock": newStock,
        "timestamp": FieldValue.serverTimestamp(),
        "user_id": uid,
        "username": username,
      });
    }
  }

  // =====================================================
  // POPUP DELETE
  // =====================================================
  Future<void> _deleteItem(
      BuildContext context, String itemId, String name) async {
    await FirebaseFirestore.instance.collection("items").doc(itemId).delete();

    // Firestore StreamBuilder di HomeScreen akan auto-refresh
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$name berhasil dihapus!")),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String itemId, String name) {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: const Text("Hapus Barang"),
        content: Text("Apakah Anda yakin ingin menghapus \"$name\"?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(alertContext),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(alertContext);        // Tutup dialog
              await _deleteItem(context, itemId, name); // Lanjutkan delete
            },
          ),
        ],
      ),
    );
  }


  // =====================================================
  // POPUP UPDATE STOK
  // =====================================================
  void _showStockPopup(
      BuildContext context,
      String name,
      String desc,
      int stock,
      String itemId,
      String userRole,
      ) {
    int newStock = stock;
    final controller = TextEditingController(text: stock.toString());

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Stok terakhir: $stock",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                // TEXTFIELD INPUT STOK
                SizedBox(
                  width: 130,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (v) {
                      setState(() {
                        newStock = int.tryParse(v) ?? newStock;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BUTTON +/- RESPONSIF
                LayoutBuilder(
                  builder: (context, c) {
                    double iconSize = c.maxWidth < 300 ? 22 : 28;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: iconSize,
                          onPressed: () => setState(() {
                            newStock = (newStock - 10).clamp(0, 999999);
                            controller.text = newStock.toString();
                          }),
                          icon: const Icon(Icons.keyboard_double_arrow_down),
                        ),
                        IconButton(
                          iconSize: iconSize,
                          onPressed: () => setState(() {
                            newStock = (newStock - 1).clamp(0, 999999);
                            controller.text = newStock.toString();
                          }),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        IconButton(
                          iconSize: iconSize,
                          onPressed: () => setState(() {
                            newStock = (newStock + 1).clamp(0, 999999);
                            controller.text = newStock.toString();
                          }),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        IconButton(
                          iconSize: iconSize,
                          onPressed: () => setState(() {
                            newStock = (newStock + 10).clamp(0, 999999);
                            controller.text = newStock.toString();
                          }),
                          icon: const Icon(Icons.keyboard_double_arrow_up),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 25),

                // BUTTON ROW: SAVE + DELETE (HANYA MANAGER)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (userRole == "whmanager")
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            _showDeleteConfirmation(context, itemId, name);
                          },
                          child: const Text("Hapus",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),

                    if (userRole == "whmanager")
                      const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await _updateStockInFirestore(
                              itemId, name, desc, newStock, stock);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Stok berhasil diperbarui!")),
                          );
                        },
                        child: const Text("Simpan",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  // =====================================================
  // BUILD PRODUCT LIST
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        double titleFont = width < 340 ? 13 : 15;
        double descFont = width < 340 ? 11 : 12;
        double chipFont = width < 340 ? 11 : 13;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.softBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Produk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFont,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Jumlah",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFont,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final name = products[i][0];
                  final desc = products[i][1];
                  final qty = products[i][2];
                  final itemId = products[i][3]; // <-- DOC ID

                  return _AnimatedProductTile(
                    width: width,
                    titleFont: titleFont,
                    descFont: descFont,
                    chipFont: chipFont,
                    name: name,
                    desc: desc,
                    qty: qty,
                    itemId: itemId,
                      onTap: () =>
                          _showStockPopup(context, name, desc, qty, itemId, userRole),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ======================================================
//              ANIMATED TILE WITH PRESS EFFECT
// ======================================================

class _AnimatedProductTile extends StatefulWidget {
  final double titleFont;
  final double descFont;
  final double chipFont;
  final double width;

  final String name;
  final String desc;
  final int qty;
  final String itemId;

  final VoidCallback onTap;

  const _AnimatedProductTile({
    required this.titleFont,
    required this.descFont,
    required this.chipFont,
    required this.width,
    required this.name,
    required this.desc,
    required this.qty,
    required this.onTap,
    required this.itemId,
  });

  @override
  State<_AnimatedProductTile> createState() => _AnimatedProductTileState();
}

class _AnimatedProductTileState extends State<_AnimatedProductTile> {
  double _scale = 1.0;

  void _press() {
    setState(() => _scale = 0.97);
  }

  void _release() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 1.0, end: _scale),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: (_) => _press(),
          onTapUp: (_) => _release(),
          onTapCancel: _release,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: AppColors.blueMain.withOpacity(0.12),
            highlightColor: AppColors.blueMain.withOpacity(0.08),
            onTap: widget.onTap,


            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.softBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: widget.titleFont,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.desc,
                          style: TextStyle(
                            fontSize: widget.descFont,
                            color: Colors.grey.shade600,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: widget.width < 340 ? 10 : 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueMain,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${widget.qty}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.chipFont,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}