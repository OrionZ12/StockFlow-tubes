import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notif_model.dart';

class NotificationRemoteSource {
  final _ref = FirebaseFirestore.instance.collection('notifications');

  Stream<List<AppNotification>> streamNotifications(String userId) {
    return _ref
        .where('target_user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        return AppNotification.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> markAsRead(String notifId) async {
    await _ref.doc(notifId).update({'is_read': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final q = await _ref
        .where('target_user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .get();

    for (final d in q.docs) {
      await d.reference.update({'is_read': true});
    }
  }
}
