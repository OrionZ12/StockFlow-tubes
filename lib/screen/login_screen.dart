import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State untuk loading
  bool _isGoogleSigningIn = false;
  bool _isEmailSigningIn = false; // Tambahan untuk loading email

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // LOGIKA LOGIN GOOGLE
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      setState(() => _isGoogleSigningIn = true);

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        if (!mounted) return; // Cek mounted sebelum akses context
        final authProvider = context.read<AuthProvider>();

        await authProvider.signInWithGoogle(googleUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selamat datang, ${googleUser.email}!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal masuk: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleSigningIn = false);
    }
  }

  // LOGIKA LOGIN EMAIL (Diperbaiki)
  Future<void> _handleEmailLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan password harus diisi"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isEmailSigningIn = true);

    final auth = context.read<AuthProvider>();

    // Panggil Provider
    String? result = await auth.login(email, password);

    // PENTING: Cek mounted sebelum lanjut navigasi/update UI
    if (!mounted) return;

    setState(() => _isEmailSigningIn = false);

    if (result == "success") {
      context.go(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal: $result"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

            double topSpacing = constraints.maxHeight * 0.12;
            double fieldSpacing = constraints.maxHeight * 0.02;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topSpacing.clamp(60, 150)),

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

                    /// EMAIL FIELD
                    TextField(
                      controller: emailController,
                      style: TextStyle(fontSize: inputFont),
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

                    SizedBox(height: fieldSpacing),

                    /// PASSWORD FIELD
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(fontSize: inputFont),
                      decoration: const InputDecoration(
                        hintText: "Masukkan kata sandi",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// LOGIN BUTTON (EMAIL)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        // Disable tombol saat loading google/email berlangsung
                        onPressed: (_isEmailSigningIn || _isGoogleSigningIn)
                            ? null
                            : _handleEmailLogin,
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
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
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

                    const SizedBox(height: 16),

                    /// GOOGLE SIGN IN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: _isGoogleSigningIn
                          ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                        ),
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                          : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1,
                            ),
                          ),
                        ),
                        // Disable google button jika sedang login email
                        onPressed: _isEmailSigningIn
                            ? null
                            : () => _handleGoogleSignIn(context),
                        icon: const Icon(Icons.login, size: 20),
                        label: Text(
                          "Sign in dengan Google",
                          style: TextStyle(
                            fontSize: inputFont.clamp(13, 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// SIGN UP TEXT
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: inputFont.clamp(12, 16),
                          ),
                          children: [
                            const TextSpan(text: "Belum punya akun? Daftar "),
                            TextSpan(
                              text: "disini",
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // PERBAIKAN: Mengarah ke AppRoutes.signUp
                                  context.go(AppRoutes.signUp);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}