import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  bool _isRegistering = false;

  String _role = "staff";

  // ================= GETTERS =================
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String get role => _role;
  bool get isManager => _role == "whmanager";

  // ================= INIT =================
  AuthProvider() {
    _listenAuthState();
  }

  void _listenAuthState() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;

      // ⛔ Jangan akses Firestore saat proses signup
      if (_isRegistering) {
        notifyListeners();
        return;
      }

      if (user == null) {
        _role = "staff";
        notifyListeners();
        return;
      }

      try {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (doc.exists) {
          _role = doc.data()?["role"] ?? "staff";
        } else {
          _role = "staff";
        }
      } catch (_) {
        _role = "staff";
      }

      notifyListeners();
    });
  }

  // ================= EMAIL VERIFICATION =================
  Future<bool> reloadAndCheckVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    await user.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  // ================= LOGIN =================
  Future<String> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User tidak ditemukan";

      // ❗ Email belum verifikasi
      if (!user.emailVerified) {
        await _authService.signOut();
        return "Email belum diverifikasi";
      }

      // ❗ Cek approval admin
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!doc.exists || doc.data()?["verified"] != true) {
        await _authService.signOut();
        return "Akun belum disetujui admin";
      }

      _role = doc.data()?["role"] ?? "staff";
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Gagal login";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= SIGN UP =================
  Future<String> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    _isLoading = true;
    _isRegistering = true;
    notifyListeners();

    try {
      final credential = await _authService.signUp(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return "Gagal membuat akun";

      final uid = user.uid;

      // 🔥 SIMPAN USER KE FIRESTORE
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({
        "uid": uid,
        "email": email,
        "name": name,
        "role": "staff",
        "verified": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // 🔥 KIRIM EMAIL VERIFIKASI
      try {
        await user.sendEmailVerification();
      } catch (_) {}

      // 🔥 LOGOUT SETELAH REGISTER
      await _authService.signOut();

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Gagal mendaftar";
    } catch (e) {
      return "Error: $e";
    } finally {
      _isRegistering = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= LOGOUT =================
  Future<void> signOut() async {
    await _authService.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    _role = "staff";
    notifyListeners();
  }
}