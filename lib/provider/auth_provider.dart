import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    try {
      // Initialize with current user
      _user = _firebaseAuth.currentUser;
      // Listen to auth state changes
      _firebaseAuth.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
      _isInitialized = true;
    } catch (e) {
      debugPrint('AuthProvider initialization error: $e');
      _isInitialized = true; // Mark as initialized even if it failed
    }
  }


Future<String?> login(String email, String password) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    return "success";
  } catch (e) {
    return e.toString();
  }
}


  // Sign up with email and password
Future<String?> signUpWithEmail(String email, String password) async {
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password, 
    );
    notifyListeners();
    return "success";
  } catch (e) {
    return e.toString();
  }
}


  // Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      notifyListeners();
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }
}
