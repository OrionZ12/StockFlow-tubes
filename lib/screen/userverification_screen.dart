import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';

class UserVerificationPage extends StatelessWidget {
  const UserVerificationPage({super.key});

  Future<void> _toggleVerify(String uid, bool current) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"verified": !current});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EDFE),
      appBar: AppBar(
        title: const Text("Verifikasi Akun"),
        backgroundColor: AppColors.blueMain,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index].data() as Map<String, dynamic>;
              final uid = users[index].id;
              final name = data["name"] ?? "Unknown";
              final email = data["email"] ?? "-";
              final verified = data["verified"] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.softBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text(email,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),

                    // STATUS
                    Text(
                      verified ? "Verified" : "Unverified",
                      style: TextStyle(
                        color: verified ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // SWITCH
                    Switch(
                      value: verified,
                      onChanged: (_) => _toggleVerify(uid, verified),
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
