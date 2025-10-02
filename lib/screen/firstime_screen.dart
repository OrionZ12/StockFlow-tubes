import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/routes.dart';

class FirstTimeScreen extends StatelessWidget {
  const FirstTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  'assets/images/warehouse.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              // Title text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: const [
                    TextSpan(text: 'Manage '),
                    TextSpan(
                      text: 'Supply',
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(text: ' with '),
                    TextSpan(
                      text: 'StockFlow',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.login); // to login_screen.dart
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Masuk"),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: 200,
                child: OutlinedButton(
                  onPressed: () {
                    context.go(AppRoutes.signIn); // to signin_screen.dart
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade300),
                    foregroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Daftar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
