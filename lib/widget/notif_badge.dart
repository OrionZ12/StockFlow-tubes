import 'package:flutter/material.dart';

class NotifBadge extends StatelessWidget {
  final int unreadCount;

  const NotifBadge({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    // 👉 kalau cuma mau dot merah
    // return _dot();

    // 👉 badge angka
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Center(
        child: Text(
          unreadCount > 9 ? "9+" : unreadCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 🔴 DOT ONLY (opsional)
  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
