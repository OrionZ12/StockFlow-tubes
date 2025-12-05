import 'package:flutter/material.dart';

class RoleButton extends StatelessWidget {
  final String role;
  final double width;
  final VoidCallback? onPressed;

  const RoleButton({
    super.key,
    required this.role,
    required this.width,
    this.onPressed,
  });

  Color _color() {
    if (role == "staff") return const Color(0xFF4A78FF);
    if (role == "whmanager") return Colors.green;
    return Colors.orange;
  }

  String _label() {
    if (role == "staff") return "Staff: Input Barang Masuk";
    if (role == "whmanager") return "Manager: Tambah Supplier";
    return "Admin: Kelola Pengguna";
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _color(),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: width * 0.035),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.04),
        ),
      ),
      onPressed: onPressed ?? () {},
      child: Text(
        _label(),
        style: TextStyle(fontSize: width * 0.04),
      ),
    );
  }
}
