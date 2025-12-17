import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory AppNotification.fromFirestore(
      QueryDocumentSnapshot doc,
      ) {
    final data = doc.data() as Map<String, dynamic>;

    return AppNotification(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt:
      (data['created_at'] as Timestamp).toDate(),
      isRead: data['is_read'] ?? false,
    );
  }
}

