import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemService {
  final CollectionReference itemsRef =
  FirebaseFirestore.instance.collection('items');

  Future<void> saveItem({
    required String itemId,
    required String name,
    required String desc,
    required int stok,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await itemsRef.doc(itemId).set({
      'name': name,
      'desc': desc,
      'stok': stok,
      'last_updated': FieldValue.serverTimestamp(),
      'last_updated_by': user?.email ?? "unknown",
    }, SetOptions(merge: true));
  }
}
