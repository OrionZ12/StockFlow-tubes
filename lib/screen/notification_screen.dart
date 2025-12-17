import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../provider/notif_provider.dart';
import '../../widget/notif_list.dart';

class NotificationStaffPage extends StatefulWidget {
  const NotificationStaffPage({super.key});

  @override
  State<NotificationStaffPage> createState() =>
      _NotificationStaffPageState();
}

class _NotificationStaffPageState
    extends State<NotificationStaffPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _userId = user.uid;

    // 🔥 START LISTEN (provider baru)
    Future.microtask(() {
      context
          .read<NotificationProvider>()
          .startListening(_userId!);
    });
  }

  @override
  void dispose() {
    // 🛑 STOP LISTEN BIAR BERSIH
    context.read<NotificationProvider>().stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final titleSize = width * 0.055;

    return Scaffold(
      backgroundColor: const Color(0xffe3efff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xff5a78c9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Stock",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Flow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5a78c9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Notifikasi",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ================= LIST =================
              const Expanded(
                child: NotificationList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
