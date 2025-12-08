import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProductList extends StatelessWidget {
  final List products;

  const ProductList({
    super.key,
    required this.products,
  });

  void _showStockPopup(
      BuildContext context, String name, String desc, int stock) {
    int newStock = stock;
    final controller = TextEditingController(text: stock.toString());

    void updateStock(int value, StateSetter setState) {
      setState(() {
        newStock = (newStock + value).clamp(0, 999999);
        controller.text = newStock.toString();
      });
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Text("Stok terakhir: $stock",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: 130,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            newStock = int.tryParse(value) ?? newStock;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => updateStock(-10, setState),
                          icon: const Icon(Icons.keyboard_double_arrow_down,
                              size: 30),
                        ),
                        IconButton(
                          onPressed: () => updateStock(-1, setState),
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 32),
                        ),
                        IconButton(
                          onPressed: () => updateStock(1, setState),
                          icon: const Icon(Icons.add_circle_outline, size: 32),
                        ),
                        IconButton(
                          onPressed: () => updateStock(10, setState),
                          icon: const Icon(Icons.keyboard_double_arrow_up,
                              size: 30),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        print("Stock baru: $newStock");
                      },
                      child: const Text("Simpan",
                          style:
                          TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
            // HEADER
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

            // LIST PRODUK
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final name = products[i][0];
                  final desc = products[i][1];
                  final qty = products[i][2];

                  return _AnimatedProductTile(
                    width: width,
                    titleFont: titleFont,
                    descFont: descFont,
                    chipFont: chipFont,
                    name: name,
                    desc: desc,
                    qty: qty,
                    onTap: () => _showStockPopup(context, name, desc, qty),
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
