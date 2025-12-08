import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../provider/auth_provider.dart';
import '../theme/app_colors.dart';

// Widgets
import '../widget/header_widget.dart';
import '../widget/update_section.dart';
import '../widget/search_section.dart';
import '../widget/product_list.dart';
import '../widget/role_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showRoleButton = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showRoleButton = false;
        });
      }
    });
  }

  // ⬇ Popup Back Button
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Keluar Aplikasi"),
          content: const Text("Apakah kamu yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final w = screen.width;
    final h = screen.height;

    final auth = context.watch<AuthProvider>();
    final role = auth.role;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.pageBackground,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  w * 0.04,
                  h * 0.02,
                  w * 0.04,
                  h * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    SizedBox(height: h * 0.015),

                    const UpdateSection(),
                    SizedBox(height: h * 0.015),

                    const SearchSection(),
                    SizedBox(height: h * 0.015),

                    // ==============================
                    //       STREAMBUILDER FIRESTORE
                    // ==============================
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.softBorder),
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("items")
                              .orderBy("name")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text(
                                      "Belum ada data barang di database"));
                            }

                            // 🔥 Convert Firestore docs → List products
                            final products = snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              return [
                                data["name"] ?? "",
                                data["desc"] ?? "",
                                data["stok"] ?? 0,
                                doc.id, // ⬅ penting!
                              ];
                            }).toList();

                            return ProductList(products: products);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =============================
              //         FLOATING BUTTON
              // =============================
              if (role != "staff")
                Positioned(
                  right: w * 0.04,
                  bottom: h * 0.02,
                  child: _floatingButton(w),
                ),

              if (showRoleButton)
                Positioned(
                  left: w * 0.04,
                  right: w * 0.04,
                  bottom: h * 0.05,
                  child: RoleButton(
                    role: role,
                    width: w,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingButton(double w) {
    return Container(
      width: w * 0.15,
      height: w * 0.15,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: AppColors.blueMain),
        iconSize: w * 0.07,
        onPressed: () {},
      ),
    );
  }
}
