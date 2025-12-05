import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;

  String _role = "none";
  String get role => _role;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          _role = doc['role'] ?? "none";
        } else {
          _role = "none";
        }
      } else {
        _role = "none";
      }

      notifyListeners();
    });
  }

  // =========================================================
  // LOGIN EMAIL
  // =========================================================
  Future<String> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        _isLoading = false;
        await _authService.signOut();
        notifyListeners();
        return "Data pengguna tidak ditemukan.";
      }

      final data = doc.data() as Map<String, dynamic>;

      // CEK VERIFIKASI ADMIN
      if (data["verified"] != true) {
        await _authService.signOut();
        _isLoading = false;
        notifyListeners();
        return "Akun Anda belum diverifikasi admin.";
      }

      // ROLE
      _role = data["role"] ?? "none";

      _isLoading = false;
      notifyListeners();
      return "success";

    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      if (e.code == 'user-not-found') return "Email tidak ditemukan.";
      if (e.code == 'wrong-password') return "Password salah.";
      if (e.code == 'invalid-email') return "Format email salah.";

      return e.message ?? "Terjadi kesalahan autentikasi.";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Gagal login: $e";
    }
  }

  // =========================================================
  // REGISTER (UPDATED)
  // =========================================================
  Future<String> signUpWithEmail(
      String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential credential =
      await _authService.signUp(email: email, password: password);

      String uid = credential.user!.uid;

      // Firestore default user: BELUM VERIFIKASI + ROLE NONE
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'verified': false,          // <-- ini yang dicek admin
        'role': 'none',             // <-- admin akan ubah ke: admin/staff/whmanager
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _authService.signOut();

      _isLoading = false;
      notifyListeners();
      return "success";

    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      if (e.code == 'weak-password') return "Password terlalu lemah.";
      if (e.code == 'email-already-in-use') return "Email sudah terdaftar.";

      return e.message ?? "Gagal mendaftar.";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================
  Future<void> signOut() async {
    await _authService.signOut();

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    _role = "none";
    notifyListeners();
  }
}
