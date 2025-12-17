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
    return Material(
      color: notif.isRead ? Colors.white : const Color(0xffeef3ff),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 72),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!notif.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 10, top: 6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        notif.isRead ? FontWeight.w500 : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.message,
                      maxLines: 2,
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
      ),
    );
  }
}
