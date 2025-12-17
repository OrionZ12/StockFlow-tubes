import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  bool _isAuthorized = false;
  String _role = "none";

  // ================= GETTER =================
  User? get user => _user;
  String get uid => _user?.uid ?? "";
  bool get isLoading => _isLoading;
  bool get isAuthorized => _isAuthorized;
  String get role => _role;

  // ================= INIT =================
  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) async {
      // DEFAULT STATE (KUNCI)
      _user = user;
      _isAuthorized = false;
      _role = "none";
      notifyListeners();

      if (user == null) return;

      // 1️⃣ CEK EMAIL VERIFIED
      await user.reload();
      if (!user.emailVerified) return;

      // 2️⃣ CEK FIRESTORE
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!doc.exists) return;

      final data = doc.data()!;
      final String? role = data["role"];
      final bool verifiedByAdmin = data["verified"] == true;

      // ❌ ROLE TIDAK VALID → TOLAK
      if (role == null || role == "none") {
        _role = "none";
        _isAuthorized = false;
        notifyListeners();
        return;
      }

      // ❌ BELUM DIVERIFIKASI ADMIN → TOLAK
      if (!verifiedByAdmin) {
        _role = role; // boleh tau rolenya, tapi belum aktif
        _isAuthorized = false;
        notifyListeners();
        return;
      }

      // ✅ BARU RESMI BOLEH MASUK
      _role = role;
      _isAuthorized = true;
      notifyListeners();
    });
  }

  // ================= LOGIN =================
  Future<String> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
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



  // ================= EMAIL VERIFICATION CHECK =================
  Future<bool> reloadAndCheckVerified() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    await currentUser.reload();
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  // ================= LOGOUT =================
  Future<void> signOut() async {
    await _authService.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    _user = null;
    _role = "none";
    _isAuthorized = false;
    notifyListeners();
  }
}
