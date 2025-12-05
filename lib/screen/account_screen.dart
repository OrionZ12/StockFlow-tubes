import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE6EDFE),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Tombol kembali + judul StockFlow
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A6ACF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Stock",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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

              const SizedBox(height: 20),

              Expanded(
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final data = snapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          AccountCard(label: "Nama", value: data["name"] ?? "-"),
                          const SizedBox(height: 12),
                          AccountCard(label: "ID", value: data["id"] ?? "-"),
                          const SizedBox(height: 12),
                          AccountCard(
                              label: "Jabatan", value: data["role"] ?? "-"),
                          const SizedBox(height: 12),
                          AccountCard(
                              label: "Email", value: data["email"] ?? "-"),
                        ],
                      ),
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

class AccountCard extends StatelessWidget {
  final String label;
  final String value;

  const AccountCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              )),
          const SizedBox(height: 4),
          Container(height: 1, width: double.infinity, color: Colors.grey.shade300),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A5ACF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
