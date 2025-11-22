import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart' as auth_prov;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isGoogleSigningIn = false;

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      setState(() => _isGoogleSigningIn = true);

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // ignore: use_build_context_synchronously
        final authProvider = context.read<auth_prov.AuthProvider>();
        await authProvider.signInWithGoogle(googleUser);

        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selamat datang, ${googleUser.email}!'),
              backgroundColor: Colors.green,
            ),
          );
          // ignore: use_build_context_synchronously
          context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal masuk: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleSigningIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double titleFont = constraints.maxWidth * 0.06; // responsive title
            double inputFont = constraints.maxWidth * 0.04;

            double topSpacing = constraints.maxHeight * 0.12;
            double fieldSpacing = constraints.maxHeight * 0.02;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TOP SPACING (responsif)
                    SizedBox(height: topSpacing.clamp(60, 150)),

                    /// TITLE
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

                    /// USERNAME FIELD
                    TextField(
                      controller: nameController,
                      style: TextStyle(fontSize: inputFont),
                      decoration: const InputDecoration(
                        hintText: "Masukkan nama anda",
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

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go(AppRoutes.home),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(
                                    color: Color(0xFFDADADA),
                                  ),
                                ),
                              ),
                              onPressed: null,
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4285F4),
                                  ),
                                ),
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
                              onPressed: () => _handleGoogleSignIn(context),
                              icon: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Color(0xFF4285F4),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              label: Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: inputFont.clamp(13, 16),
                                  fontWeight: FontWeight.w500,
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
                                ..onTap = () => context.go(AppRoutes.signIn),
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
