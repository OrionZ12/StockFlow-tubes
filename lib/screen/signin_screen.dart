import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/routes.dart';
import '../provider/auth_provider.dart' as auth_prov;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive sizes
            double titleFont = constraints.maxWidth * 0.06;
            double labelFont = constraints.maxWidth * 0.04;
            double inputFont = constraints.maxWidth * 0.04;

            double topSpacing = constraints.maxHeight * 0.12;
            double inputSpacing = constraints.maxHeight * 0.018;

            double buttonWidth = constraints.maxWidth * 0.6;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// RESPONSIVE TOP SPACING
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

                    const SizedBox(height: 20),

                    Text(
                      "Daftar ke StockFlow",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: labelFont.clamp(14, 20),
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// INPUTS — RESPONSIVE FONTS
                    TextField(
                      style: TextStyle(fontSize: inputFont.clamp(12, 18)),
                      decoration: InputDecoration(
                        hintText: "Masukkan nama anda",
                        hintStyle: TextStyle(fontSize: inputFont.clamp(12, 18)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: inputSpacing),

                    TextField(
                      style: TextStyle(fontSize: inputFont.clamp(12, 18)),
                      decoration: InputDecoration(
                        hintText: "Masukkan email atau nomor HP anda",
                        hintStyle: TextStyle(fontSize: inputFont.clamp(12, 18)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: inputSpacing),

                    TextField(
                      obscureText: true,
                      style: TextStyle(fontSize: inputFont.clamp(12, 18)),
                      decoration: InputDecoration(
                        hintText: "Masukkan kata sandi",
                        hintStyle: TextStyle(fontSize: inputFont.clamp(12, 18)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: inputSpacing),

                    TextField(
                      obscureText: true,
                      style: TextStyle(fontSize: inputFont.clamp(12, 18)),
                      decoration: InputDecoration(
                        hintText: "Masukkan ulang kata sandi",
                        hintStyle: TextStyle(fontSize: inputFont.clamp(12, 18)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// RESPONSIVE BUTTON
                    Center(
                      child: SizedBox(
                        width: buttonWidth.clamp(180, 300),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context.go(AppRoutes.login),
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: inputFont.clamp(14, 20),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// GOOGLE SIGN IN BUTTON
                    Center(
                      child: SizedBox(
                        width: buttonWidth.clamp(180, 300),
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
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Sudah punya akun? Masuk ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: inputFont.clamp(12, 16),
                          ),
                          children: [
                            TextSpan(
                              text: "disini",
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.go(AppRoutes.login),
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
