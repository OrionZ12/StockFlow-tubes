import 'package:flutter/material.dart';
import '../widget/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    // NAVIGASI MENGGUNAKAN GoRouter
    if (index == 0) {
      context.go('/home');
    }
    else if (index == 1) {
      context.go('/history');   // ⬅ pindah ke RiwayatPage
    }
    else if (index == 2) {
      context.go('/profile');   // jika nanti ada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F0FF),
        title: Row(
                    children: [
                      const Text(
                        "Stock",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const Text(
                        "Flow",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5a78c9),
                        ),
                      ),
                    ],
                  )),
      body: const Center(
        child: Text(
          "......",
          style: TextStyle(fontSize: 20),
        ),
      ),

      /// ⬇ Tambahkan navbar ⬇
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
