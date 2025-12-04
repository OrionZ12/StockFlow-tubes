import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // Hubungkan dengan Service yang sudah dibuat di atas
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Mendengarkan perubahan status auth dari Service
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // =========================================================
  // LOGIC LOGIN EMAIL (Sesuai kebutuhan LoginScreen Anda)
  // =========================================================
  Future<String> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Panggil service
      await _authService.signIn(email: email, password: password);

      _isLoading = false;
      notifyListeners();

      return "success"; // Penting: Ini yang dicek oleh UI Anda

    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      // Mengembalikan pesan error yang rapi
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
  // LOGIC LOGIN GOOGLE (Sesuai kebutuhan LoginScreen Anda)
  // =========================================================
  Future<void> signInWithGoogle(GoogleSignInAccount googleUser) async {
    // Tidak perlu set _isLoading di sini karena LoginScreen Anda
    // sudah menggunakan variabel lokal '_isGoogleSigningIn' untuk loadingnya.

    try {
      // 1. Ambil detail autentikasi dari object googleUser yang dikirim UI
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 2. Buat Credential Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Kirim Credential ke Service untuk login ke Firebase
      await _authService.signInWithCredential(credential);

      // Jika berhasil, stream di _initializeAuth akan otomatis update _user
      notifyListeners();

    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow; // Lempar error balik ke UI agar muncul di SnackBar
    }
  }

  // =========================================================
  // LOGIC REGISTER (Untuk SignupScreen)
  // =========================================================
  Future<String> signUpWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signUp(email: email, password: password);
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
  // LOGIC LOGOUT
  // =========================================================
  Future<void> signOut() async {
    await _authService.signOut();

    // Jika menggunakan Google Sign In, kita perlu disconnect juga agar
    // saat user login lagi, dia bisa memilih akun (tidak otomatis login akun sebelumnya)
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    } catch (_) {
      // Abaikan error jika bukan login via google
    }

    notifyListeners();
  }
}