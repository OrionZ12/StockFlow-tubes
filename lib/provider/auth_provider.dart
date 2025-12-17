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

  // =========================================================
  // INITIALIZE AUTH
  // =========================================================
  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          _role = doc["role"] ?? "none";
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
  // EMAIL VERIFICATION SYSTEM (FINAL VERSION)
  // =========================================================

  /// Kirim email verifikasi
  Future<String> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return "User tidak ditemukan.";

    if (user.emailVerified) {
      return "Email kamu sudah terverifikasi.";
    }

    try {
      await user.sendEmailVerification();
      return "Link verifikasi telah dikirim ke email kamu.";
    } catch (e) {
      return "Gagal mengirim link verifikasi: $e";
    }
  }

  /// Kirim ulang email verifikasi
  Future<String> resendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return "User tidak ditemukan.";
    if (user.emailVerified) return "Email sudah terverifikasi.";

    try {
      await user.sendEmailVerification();
      return "Link verifikasi telah dikirim ulang.";
    } catch (e) {
      return "Gagal mengirim ulang verifikasi: $e";
    }
  }

  /// Refresh user & cek status emailVerified
  Future<bool> reloadAndCheckVerified() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    await user.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  // =========================================================
  // LOGIN
  // =========================================================
  Future<String> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return "User tidak ditemukan.";
      }

      // 🔥 CEK EMAIL VERIFIKASI DULU
      if (!user.emailVerified) {
        await _authService.signOut();
        _isLoading = false;
        notifyListeners();
        return "Email belum terverifikasi.\nSilahkan verifikasi terlebih dahulu.";
      }

      // 🔥 CEK VERIFIKASI ADMIN DI FIRESTORE
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!doc.exists || doc["verified"] != true) {
        await _authService.signOut();
        _isLoading = false;
        notifyListeners();
        return "Akun kamu belum disetujui admin.";
      }

      _role = doc["role"] ?? "none";

      _isLoading = false;
      notifyListeners();
      return "success";

    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      if (e.code == "user-not-found") return "Email tidak ditemukan.";
      if (e.code == "wrong-password") return "Password salah.";

      return e.message ?? "Gagal login.";
    }
  }

  // =========================================================
  // SIGN UP (UPDATED)
  // =========================================================
  Future<String> signUpWithEmail(
    String email, String password, String name) async {
  _isLoading = true;
  notifyListeners();

  try {
    UserCredential credential = await _authService.signUp(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      return "Gagal membuat akun.";
    }

    final uid = user.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      "name": name,
      "role": "staff",
      "verified": false, // admin approval
      "createdAt": FieldValue.serverTimestamp(),
    });

    // Kirim email verifikasi
    await user.sendEmailVerification();

    return "success";
  } catch (e) {
    return "Error: $e";
  } finally {
    _isLoading = false;
    notifyListeners();
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
