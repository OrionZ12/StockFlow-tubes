import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

                    Text(
                      "Masuk ke akun anda",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: inputFont.clamp(14, 18),
                      ),
                    ),
                    const SizedBox(height: 12),

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
