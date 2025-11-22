import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/routes.dart';

class FirstTimeScreen extends StatelessWidget {
  const FirstTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Dynamic sizes
            double imageHeight = constraints.maxHeight * 0.30;
            double titleFontSize = constraints.maxWidth * 0.07;
            double buttonWidth = constraints.maxWidth * 0.6;

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// IMAGE – responsive height
                      Image.asset(
                        'assets/images/warehouse.png',
                        height: imageHeight.clamp(120, 350),
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 40),

                      /// RESPONSIVE TITLE
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: titleFontSize.clamp(18, 32),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: const [
                            TextSpan(text: 'Manage '),
                            TextSpan(text: 'Supply', style: TextStyle(color: Colors.blue)),
                            TextSpan(text: ' with '),
                            TextSpan(text: 'StockFlow', style: TextStyle(color: Colors.blueAccent)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// MASUK BUTTON
                      SizedBox(
                        width: buttonWidth.clamp(180, 260),
                        child: ElevatedButton(
                          onPressed: () => context.go(AppRoutes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Masuk"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// DAFTAR BUTTON
                      SizedBox(
                        width: buttonWidth.clamp(180, 260),
                        child: OutlinedButton(
                          onPressed: () => context.go(AppRoutes.signIn),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue.shade300),
                            foregroundColor: Colors.blue.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Daftar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
