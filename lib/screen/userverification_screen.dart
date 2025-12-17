import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../widget/bottom_nav_bar.dart';

class UserVerificationPage extends StatelessWidget {
  const UserVerificationPage({super.key});

  // =========================
  // UPDATE VERIFIED
  // =========================
  Future<void> _toggleVerify(String uid, bool current) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"verified": !current});
  }

  // =========================
  // UPDATE ROLE
  // =========================
  Future<void> _updateRole(String uid, String role) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"role": role});
  }

  // =========================
  // DELETE USER
  // =========================
  Future<void> _deleteUser(BuildContext context, String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User berhasil dihapus")),
    );
  }

  // =========================
  // CONFIRM DELETE
  // =========================
  void _confirmDelete(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: const Text("Hapus User"),
        content: const Text("Apakah Anda yakin ingin menghapus user ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertContext),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(alertContext);
              await _deleteUser(context, uid);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EDFE),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Manajemen Akun"),
        backgroundColor: AppColors.blueMain,
      ),


      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("Tidak ada user"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;

              final uid = doc.id;
              final name = data["name"] ?? "Unknown";
              final email = data["email"] ?? "-";
              final rawRole = data["role"];
              final role = (rawRole == "staff" || rawRole == "whmanager")
                  ? rawRole
                  : "staff";
              final verified = data["verified"] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.softBorder),
                ),

                child: ExpansionTile(
                  tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  childrenPadding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 16),

                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    email,
                    style: const TextStyle(fontSize: 12),
                  ),

                  trailing: Switch(
                    value: verified,
                    onChanged: (_) => _toggleVerify(uid, verified),
                    activeColor: Colors.green,
                  ),

                  children: [
                    _infoRow("User ID", uid),
                    _infoRow("Email", email),

                    const SizedBox(height: 12),

                    // ROLE DROPDOWN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Role",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        DropdownButton<String>(
                          value: role,
                          items: const [
                            DropdownMenuItem(
                              value: "staff",
                              child: Text("Staff"),
                            ),
                            DropdownMenuItem(
                              value: "whmanager",
                              child: Text("WH Manager"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _updateRole(uid, value);
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // DELETE BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _confirmDelete(context, uid),
                        child: const Text(
                          "Hapus User",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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

  // =========================
  // INFO ROW
  // =========================
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
