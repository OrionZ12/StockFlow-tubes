import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/routes.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final e = email.trim();
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(e);
  }

  bool get _isFormValid {
    final email = _emailCtrl.text.trim();
    final oldP = _oldPassCtrl.text;
    final newP = _newPassCtrl.text;
    final conf = _confirmPassCtrl.text;

    if (email.isEmpty || oldP.isEmpty || newP.isEmpty || conf.isEmpty) {
      return false;
    }
    if (!_isValidEmail(email)) return false;
    if (newP.length < 6) return false;
    if (newP != conf) return false;

    return true;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<String> _changePasswordFirebase({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User belum login.";

      // Re-auth (wajib untuk update password)
      final cred = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(cred);

      await user.updatePassword(newPassword);

      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") return "Password lama salah.";
      if (e.code == "user-mismatch") return "Email tidak sesuai dengan akun login.";
      if (e.code == "invalid-credential") return "Email atau password lama salah.";
      if (e.code == "weak-password") return "Password baru terlalu lemah (min 6).";
      if (e.code == "requires-recent-login") {
        return "Silakan login ulang dulu, lalu coba lagi.";
      }
      return e.message ?? "Gagal ganti password.";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> _submit() async {
    if (!_isFormValid || _isLoading) {
      if (!_isFormValid) {
        // kasih feedback yang jelas biar user ngerti
        final email = _emailCtrl.text.trim();
        final newP = _newPassCtrl.text;
        final conf = _confirmPassCtrl.text;

        if (email.isEmpty) return _showSnack("Email wajib diisi.");
        if (!_isValidEmail(email)) return _showSnack("Format email tidak valid.");
        if (_oldPassCtrl.text.isEmpty) return _showSnack("Password lama wajib diisi.");
        if (newP.isEmpty) return _showSnack("Password baru wajib diisi.");
        if (newP.length < 6) return _showSnack("Password baru minimal 6 karakter.");
        if (conf.isEmpty) return _showSnack("Konfirmasi password wajib diisi.");
        if (newP != conf) return _showSnack("Konfirmasi password tidak cocok.");
      }
      return;
    }

    setState(() => _isLoading = true);

    final result = await _changePasswordFirebase(
      email: _emailCtrl.text.trim(),
      oldPassword: _oldPassCtrl.text,
      newPassword: _newPassCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == "success") {
      _showSnack("Password berhasil diubah!", color: Colors.green);
      context.go(AppRoutes.changePasswordSuccess);
    } else {
      _showSnack(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6EDFE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.profile),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A78C9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Stock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Flow',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A6ACF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Ganti Kata Sandi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // ================= FORM =================
              _inputField(
                controller: _emailCtrl,
                hint: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              _inputField(
                controller: _oldPassCtrl,
                hint: 'Masukkan kata sandi lama',
                obscure: _obscureOld,
                toggle: () => setState(() => _obscureOld = !_obscureOld),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              _inputField(
                controller: _newPassCtrl,
                hint: 'Masukkan kata sandi baru',
                obscure: _obscureNew,
                toggle: () => setState(() => _obscureNew = !_obscureNew),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              _inputField(
                controller: _confirmPassCtrl,
                hint: 'Masukkan kembali kata sandi baru',
                obscure: _obscureConfirm,
                toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 22),

              // ================= BUTTON =================
              Center(
                child: SizedBox(
                  width: width * 0.6,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: (_isFormValid && !_isLoading) ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A6ACF),
                      disabledBackgroundColor:
                      const Color(0xFF5A6ACF).withOpacity(0.45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT WIDGET =================
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    VoidCallback? toggle,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            suffixIcon: toggle != null
                ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                size: 18,
              ),
              onPressed: toggle,
            )
                : null,
          ),
        ),
      ),
    );
  }
}
