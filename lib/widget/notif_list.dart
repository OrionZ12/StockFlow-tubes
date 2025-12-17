import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notif_provider.dart';
import '../model/notif_model.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifs = provider.notifications;

    if (notifs.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada notifikasi",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: notifs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notif = notifs[index];

        return _NotificationCard(
          notif: notif,
          onTap: () {
            if (!notif.isRead) {
              provider.markAsRead(notif.id);
            }
          },
        );
      },
    );
  }
}

//
// ================= CARD =================
//
class _NotificationCard extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isRead
              ? Colors.white
              : const Color(0xffeef3ff), // 🔵 unread highlight
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            // 🔴 DOT UNREAD
            if (!notif.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notif.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notif.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
