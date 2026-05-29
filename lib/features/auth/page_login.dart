import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sync_team/features/auth/page_account.dart';
import 'package:sync_team/main.dart';
import 'page_register.dart';
import 'page_verify_otp.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => PageLoginState();
}

class PageLoginState extends State<PageLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showSnackBar('Vui lòng nhập đầy đủ thông tin');
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.user != null && mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PageAccount()
          ),(route) => false,
        );
      }
    } on AuthException catch (e) {showSnackBar(mapAuthError(e.message));
    } catch (e) {showSnackBar('Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  String mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Email hoặc mật khẩu không đúng';
    } else if (message.contains('Email not confirmed')) {
      return 'Vui lòng xác thực email trước khi đăng nhập';
    }
    return message;
  }
  void showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(000000),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              const Center(
                  child: Text("Chào mừng trở lại!", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold,),)
              ),
              const SizedBox(height: 6),
              const Center(
                  child: Text("Đăng nhập để tiếp tục học nhóm", style: TextStyle(color: Color(0xFF8892A4), fontSize: 20),),
              ),
              Center(
                child:Image.asset("asset/images/98c666a371f6a1b9544a07b6a63c3bf0.jpg", width: double.infinity, height: 250, fit: BoxFit.fill
                ),
              ),
              const SizedBox(height: 32),
              DarkTextField(
                controller: emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              DarkTextField(
                controller: passwordController,
                hint: 'Mật khẩu',
                icon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF4A5568), size: 20,),
                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB),
                    disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),
                  )
                      : const Text("Đăng nhập", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,),),
                ),
              ),
              const SizedBox(height: 30),
              // ── Sign up hint ──
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PageRegister()),
                  ),
                  child: RichText(text: const TextSpan(text: "Chưa có tài khoản? ", style: TextStyle(color: Color(0xFF4A5568), fontSize: 14),
                      children: [
                        TextSpan(text: "Đăng ký ngay", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600,),),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const DarkTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4A5568)),
        prefixIcon: Icon(icon, color: const Color(0xFF4A5568), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF1C2333),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3448)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3448)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}