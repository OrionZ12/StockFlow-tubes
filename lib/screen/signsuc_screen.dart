import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE6EEFF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double imgSize = constraints.maxWidth * 0.25; // responsive image
          double fontSize = constraints.maxWidth * 0.04; // responsive text
          double spacing = constraints.maxHeight * 0.03;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// RESPONSIVE IMAGE
                Image.asset(
                  "assets/images/check.png",
                  width: imgSize.clamp(60, 150),
                  height: imgSize.clamp(60, 150),
                ),

                SizedBox(height: spacing.clamp(12, 40)),

                /// RESPONSIVE TEXT
                Text(
                  "Selamat, pendaftaran berhasil",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize.clamp(12, 22),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
