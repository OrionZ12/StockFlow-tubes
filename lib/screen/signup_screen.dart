import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../provider/auth_provider.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool showPass = true;
  bool showConfirm = true;
  bool loading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double titleFont = constraints.maxWidth * 0.06;
            double inputFont = constraints.maxWidth * 0.04;
            double topSpacing = constraints.maxHeight * 0.12;
            double fieldSpacing = constraints.maxHeight * 0.02;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topSpacing.clamp(60, 150)),

                    Center(
                      child: Text(
                        "Daftar Akun Baru",
                        style: TextStyle(
                          fontSize: titleFont.clamp(20, 28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: nameCtrl,
                      style: TextStyle(fontSize: inputFont),
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "Masukkan nama lengkap",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: fieldSpacing),

                    TextField(
                      controller: emailCtrl,
                      style: TextStyle(fontSize: inputFont),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Masukkan email anda",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: fieldSpacing),

                    TextField(
                      controller: passCtrl,
                      obscureText: showPass,
                      style: TextStyle(fontSize: inputFont),
                      decoration: InputDecoration(
                        hintText: "Masukkan kata sandi",
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPass ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => showPass = !showPass),
                        ),
                      ),
                    ),

                    SizedBox(height: fieldSpacing),

                    TextField(
                      controller: confirmCtrl,
                      obscureText: showConfirm,
                      style: TextStyle(fontSize: inputFont),
                      decoration: InputDecoration(
                        hintText: "Konfirmasi kata sandi",
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => showConfirm = !showConfirm),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          "Daftar",
                          style: TextStyle(
                            fontSize: inputFont.clamp(14, 20),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Sudah punya akun? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: inputFont.clamp(12, 16),
                          ),
                          children: [
                            TextSpan(
                              text: "Masuk disini",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final conf = confirmCtrl.text.trim();

    if (name.isEmpty) {
      showError("Nama lengkap wajib diisi");
      return;
    }
    if (email.isEmpty || pass.isEmpty || conf.isEmpty) {
      showError("Semua field wajib diisi");
      return;
    }
    if (pass != conf) {
      showError("Konfirmasi password tidak cocok");
      return;
    }
    if (pass.length < 6) {
      showError("Password minimal 6 karakter");
      return;
    }

    setState(() => loading = true);

    final auth = context.read<AuthProvider>();
    final result = await auth.signUpWithEmail(email, pass, name);

    if (!mounted) return;
    setState(() => loading = false);

    if (result == "success") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Pendaftaran Berhasil"),
          content: const Text(
            "Akun kamu berhasil dibuat dan sedang menunggu verifikasi admin.\n\n"
                "Silahkan login setelah akun disetujui.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(AppRoutes.login);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showError(result);
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}