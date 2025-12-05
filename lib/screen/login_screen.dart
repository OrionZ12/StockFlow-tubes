import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../config/routes.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isEmailSigningIn = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // LOGIN EMAIL
  Future<void> _handleEmailLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Email dan password harus diisi", Colors.orange);
      return;
    }

    setState(() => _isEmailSigningIn = true);

    final auth = context.read<AuthProvider>();
    final result = await auth.login(email, password);

    if (!mounted) return;

    setState(() => _isEmailSigningIn = false);

    // ==============================
    // LOGIN SUKSES
    // ==============================
    if (result == "success") {
      context.go(AppRoutes.home);   // <── DIGANTI INI SAJA
      return;
    }

    // ==============================
    // UNVERIFIED USER
    // ==============================
    if (result.contains("belum diverifikasi")) {
      _showMessage(
        "Akun Anda belum diverifikasi admin.\nSilakan tunggu persetujuan.",
        Colors.orange,
      );
      return;
    }

    // ==============================
    // USER NOT FOUND
    // ==============================
    if (result == "Email tidak ditemukan." || result == "user-not-found") {
      _showUserNotFoundDialog();
      return;
    }

    // ==============================
    // WRONG PASSWORD
    // ==============================
    if (result == "Password salah." || result == "wrong-password") {
      _showMessage("Password salah", Colors.red);
      return;
    }

    // ==============================
    // OTHER ERRORS
    // ==============================
    _showMessage("Login gagal: $result", Colors.red);
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUserNotFoundDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Akun tidak ditemukan"),
        content: const Text("Email ini belum terdaftar. Ingin membuat akun baru?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.signUp);
            },
            child: const Text("Daftar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double titleFont = constraints.maxWidth * 0.06;
            double inputFont = constraints.maxWidth * 0.04;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.12),

                  Center(
                    child: Text(
                      "Selamat Datang!",
                      style: TextStyle(
                        fontSize: titleFont.clamp(18, 28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: emailController,
                    style: TextStyle(fontSize: inputFont),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Masukkan email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePass,
                    style: TextStyle(fontSize: inputFont),
                    decoration: InputDecoration(
                      hintText: "Masukkan kata sandi",
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isEmailSigningIn ? null : _handleEmailLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isEmailSigningIn
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: inputFont.clamp(14, 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: inputFont.clamp(12, 16),
                        ),
                        children: [
                          const TextSpan(text: "Belum punya akun? "),
                          TextSpan(
                            text: "Daftar disini",
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.go(AppRoutes.signUp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
