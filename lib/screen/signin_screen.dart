import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import '../config/routes.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Selamat Datang!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Daftar ke StockFlow",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan nama anda",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan email atau nomor HP anda",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Masukkan kata sandi",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Masukkan ulang kata sandi",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 100.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.go(AppRoutes.login); // redirect ke login_screen.dart
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Sudah punya akun? Masuk ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "disini",
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go(AppRoutes.login);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
