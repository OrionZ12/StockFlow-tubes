import '../model/notif_model.dart';
import '../data/notif_remote_source.dart';

class NotificationRepository {
  final NotificationRemoteSource _remote;

  NotificationRepository(this._remote);

  /// 🔥 STREAM REALTIME NOTIFICATION
  Stream<List<AppNotification>> streamNotifications(String userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    return _remote.streamNotifications(userId);
  }

  /// ✅ MARK SINGLE NOTIFICATION AS READ
  Future<void> markAsRead(String notifId) async {
    if (notifId.isEmpty) return;
    await _remote.markAsRead(notifId);
  }

  /// ✅ MARK ALL NOTIFICATION AS READ
  Future<void> markAllAsRead(String userId) async {
    if (userId.isEmpty) return;
    await _remote.markAllAsRead(userId);
  }
}
