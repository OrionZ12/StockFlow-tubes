import 'package:flutter/material.dart';
import '../widget/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    // TODO: pindah page pakai GoRouter atau Navigator
    // if (index == 1) context.push("/riwayat");
    // if (index == 2) context.push("/profil");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(title: const Text("Home")),
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
