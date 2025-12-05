import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream untuk memantau status user secara realtime
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan user saat ini
  User? get currentUser => _auth.currentUser;

  // 1. Sign Up (Email & Password)
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // BUAT DATA USER DI FIRESTORE (default role = pending)
      await _createUserData(cred.user!);

      return cred;
    } catch (e) {
      throw e; // Lempar error agar ditangkap Provider
    }
  }

  // 2. Sign In (Email & Password)
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  // 3. Sign In dengan Credential (Google dsb)
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      final cred = await _auth.signInWithCredential(credential);

      // Jika login via Google, pastikan Firestore sudah ada dokumen user
      await _ensureUserDataExists(cred.user!);

      return cred;
    } catch (e) {
      throw e;
    }
  }

  // 4. Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ---------------------------------------------------
  // 🔥 Tambahan: Buat data user di Firestore
  // ---------------------------------------------------

  Future<void> _createUserData(User user) async {
    await _db.collection('users').doc(user.uid).set({
      'email': user.email,
      'role': 'pending', // Default belum diverifikasi admin
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Kalau login via Google, pastikan dokumen Firestore sudah ada
  Future<void> _ensureUserDataExists(User user) async {
    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _createUserData(user);
    }
  }
}
