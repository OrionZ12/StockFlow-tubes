import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream untuk memantau status user secara realtime
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan user saat ini
  User? get currentUser => _auth.currentUser;

  // 1. Sign Up (Email & Password)
  Future<UserCredential> signUp({required String email, required String password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e; // Lempar error agar ditangkap Provider
    }
  }

  // 2. Sign In (Email & Password)
  Future<UserCredential> signIn({required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  // 3. Sign In dengan Credential (untuk Google/Facebook/dll)
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }

  // 4. Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}