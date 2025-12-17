import 'dart:async';
import 'package:flutter/material.dart';

import '../model/notif_model.dart';
import '../screen/notif_directory.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repo;

  NotificationProvider(this._repo);

  List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  StreamSubscription<List<AppNotification>>? _sub;
  String? _currentUserId;

  // ===== GETTER =====
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  // ===== LISTEN NOTIFICATION =====
  void startListening(String userId) {
    if (userId.isEmpty) return;

    // kalau user sama, jangan subscribe ulang
    if (_currentUserId == userId) return;

    _currentUserId = userId;
    _sub?.cancel();

    _sub = _repo.streamNotifications(userId).listen(
          (list) {
        _notifications = list;
        _unreadCount = list.where((n) => !n.isRead).length;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Notification stream error: $e');
      },
    );
  }

  // ===== STOP (LOGOUT) =====
  void stopListening() {
    _sub?.cancel();
    _sub = null;
    _currentUserId = null;
    _notifications = [];
    _unreadCount = 0;
    notifyListeners();
  }

  // ===== ACTION =====
  Future<void> markAsRead(String notifId) async {
    await _repo.markAsRead(notifId);
  }

  Future<void> markAllAsRead() async {
    if (_currentUserId == null) return;
    await _repo.markAllAsRead(_currentUserId!);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
