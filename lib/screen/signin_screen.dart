import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import '../config/routes.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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

                    /// SIGN IN LINK — RESPONSIVE FONT
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
