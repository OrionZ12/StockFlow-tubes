import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final _notifRef =
  FirebaseFirestore.instance.collection('notifications');
  final _userRef =
  FirebaseFirestore.instance.collection('users');

  Future<void> notifyAllExcept({
    required String title,
    required String message,
    required String type,
    required String itemId,
    required String itemName,
    required String actorUid,
    required String actorName,
  }) async {
    final usersSnap = await _userRef.get();
    final batch = FirebaseFirestore.instance.batch();

    for (final doc in usersSnap.docs) {
      if (doc.id == actorUid) continue;

      final notifDoc = _notifRef.doc();

      batch.set(notifDoc, {
        'title': title,
        'message': message,
        'type': type,
        'item_id': itemId,
        'item_name': itemName,
        'target_user_id': doc.id,

        // actor
        'actor_uid': actorUid,
        'actor_name': actorName,

        // state
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
