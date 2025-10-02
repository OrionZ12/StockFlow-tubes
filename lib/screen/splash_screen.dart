import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      // Go to firstime_screen.dart
      context.go(AppRoutes.firstTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF), // light blue background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
            children: [
              // logo
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              const SizedBox(height: 16),

              // StockFlow title
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'RobotoSerif',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(text: 'Stock', style: TextStyle(color: Colors.black)),
                    TextSpan(text: 'Flow', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // footer text
              const Text(
                "by TriWeight",
                style: TextStyle(
                  fontFamily: 'RobotoSerif',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
