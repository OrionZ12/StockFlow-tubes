import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../theme/app_colors.dart';

class UserVerificationPage extends StatefulWidget {
  const UserVerificationPage({super.key});

  @override
  State<UserVerificationPage> createState() => _UserVerificationPageState();
}

class _UserVerificationPageState extends State<UserVerificationPage> {
  // =========================
  // FIRESTORE ACTIONS
  // =========================
  Future<void> _toggleVerify(String uid, bool current) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"verified": !current});
  }

  Future<void> _updateRole(String uid, String role) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"role": role});
  }

  Future<void> _deleteUser(BuildContext context, String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User berhasil dihapus")),
    );
  }

  void _confirmDelete(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus User"),
        content: const Text("Apakah Anda yakin ingin menghapus user ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;
        final padding = isSmall ? 12.0 : 16.0;
        final titleSize = isSmall ? 14.0 : 16.0;
        final subtitleSize = isSmall ? 11.0 : 12.0;

        return Scaffold(
          backgroundColor: const Color(0xFFE6EDFE),

          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.profile);
                }
              },
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

              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ExpansionPanelList.radio(
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.zero,

                  children: users.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final uid = doc.id;

                    final name = data["name"] ?? "Unknown";
                    final email = data["email"] ?? "-";
                    final role =
                    (data["role"] == "whmanager") ? "whmanager" : "staff";
                    final verified = data["verified"] ?? false;

                    return ExpansionPanelRadio(
                      value: uid, // 🔑 KUNCI 1 PANEL SAJA
                      canTapOnHeader: true,

                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),
                          subtitle: Text(
                            email,
                            style: TextStyle(fontSize: subtitleSize),
                          ),
                          trailing: Switch(
                            value: verified,
                            onChanged: (_) =>
                                _toggleVerify(uid, verified),
                            activeColor: Colors.green,
                          ),
                        );
                      },

                      body: Padding(
                        padding: EdgeInsets.fromLTRB(
                            padding, 0, padding, padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow("User ID", uid, isSmall),
                            _infoRow("Email", email, isSmall),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Text(
                                  "Role",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: role,
                                    isDense: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: "staff",
                                          child: Text("Staff")),
                                      DropdownMenuItem(
                                          value: "whmanager",
                                          child: Text("WH Manager")),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        _updateRole(uid, value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              height: isSmall ? 40 : 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () =>
                                    _confirmDelete(context, uid),
                                child: const Text(
                                  "Hapus User",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value, bool isSmall) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isSmall ? 70 : 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
