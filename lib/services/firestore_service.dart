import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemService {
  final CollectionReference itemsRef =
  FirebaseFirestore.instance.collection('items');

  /// 🔹 Menambahkan item baru (auto-ID)
  Future<void> addItem({
    required String name,
    required String desc,
    required int stok,
    required String category,
    required String supplier,
    required String date,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await itemsRef.add({
      'name': name,
      'desc': desc,
      'stok': stok,
      'category': category,           // kategori sekarang text biasa
      'supplier': supplier,
      'date': date,
      'last_updated': FieldValue.serverTimestamp(),
      'last_updated_by': user?.email ?? "unknown",
    });
  }

  /// 🔹 Menyimpan / update item berdasarkan itemId (manual ID)
  Future<void> saveItem({
    required String itemId,
    required String name,
    required String desc,
    required int stok,
    required String category,
    required String supplier,
    required String date,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await itemsRef.doc(itemId).set({
      'name': name,
      'desc': desc,
      'stok': stok,
      'category': category,          // tetap text
      'supplier': supplier,
      'date': date,
      'last_updated': FieldValue.serverTimestamp(),
      'last_updated_by': user?.email ?? "unknown",
    }, SetOptions(merge: true));
  }
}

/// =======================================================
///  🔥 CATEGORY SERVICE — kategori dipindah ke collection baru
/// =======================================================
class CategoryService {
  final CollectionReference catRef =
  FirebaseFirestore.instance.collection('categories');

  /// Ambil semua kategori (sorted)
  Future<List<String>> getCategories() async {
    final snap = await catRef.orderBy('name').get();

    return snap.docs.map((d) => d['name'] as String).toList();
  }

  /// Tambah kategori baru
  Future<void> addCategory(String name) async {
    await catRef.add({'name': name});
  }

  /// Hapus kategori berdasarkan nama
  Future<void> deleteCategory(String name) async {
    final snap =
    await catRef.where('name', isEqualTo: name).limit(1).get();

    if (snap.docs.isEmpty) return;

    await catRef.doc(snap.docs.first.id).delete();
  }
}
