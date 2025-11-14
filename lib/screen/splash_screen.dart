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
      context.go(AppRoutes.firstTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double logoSize = constraints.maxWidth * 0.35;
            double titleFont = constraints.maxWidth * 0.08;
            double footerFont = constraints.maxWidth * 0.04;

            double spacingTop = constraints.maxHeight * 0.02;
            double spacingMiddle = constraints.maxHeight * 0.05;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// RESPONSIVE LOGO
                  Image.asset(
                    'assets/images/logo.png',
                    width: logoSize.clamp(80, 180),
                    height: logoSize.clamp(80, 180),
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: spacingTop.clamp(10, 32)),

                  /// RESPONSIVE RICHTEXT TITLE
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'RobotoSerif',
                        fontSize: titleFont.clamp(22, 40),
                        fontWeight: FontWeight.bold,
                      ),
                      children: const [
                        TextSpan(text: 'Stock', style: TextStyle(color: Colors.black)),
                        TextSpan(text: 'Flow', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),

                  SizedBox(height: spacingMiddle.clamp(20, 60)),

                  /// RESPONSIVE FOOTER
                  Text(
                    "by TriWeight",
                    style: TextStyle(
                      fontFamily: 'RobotoSerif',
                      fontSize: footerFont.clamp(10, 18),
                      color: Colors.black54,
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
