import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'page_login.dart';
import 'page_verify_otp.dart';

class PageRegister extends StatefulWidget {
  const PageRegister({super.key});

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  String? validate() {
    if (nameController.text.trim().isEmpty) return 'Vui lòng nhập họ và tên';
    if (emailController.text.trim().isEmpty) return 'Vui lòng nhập email';
    if (!emailController.text.trim().contains('@')) return 'Email không hợp lệ';
    if (phoneController.text.trim().isEmpty) return 'Vui lòng nhập số điện thoại';
    if (int.tryParse(phoneController.text.trim()) == null) return 'Số điện thoại không hợp lệ';
    if (passwordController.text.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    if (passwordController.text != confirmPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }
  Future<void> handleRegister() async {
    final error = validate();
    if (error != null) {showSnackBar(error);
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'name': nameController.text.trim(),
          'phonenumber': int.parse(phoneController.text.trim()),
        },
      );
      if (response.user != null && mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageVerifyOtp(email: response.user!.email!,),
          ),
        );
      }
    } on AuthException catch (e) {
      showSnackBar(mapAuthError(e.message));
    } catch (e) {
      showSnackBar('Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  //English-> VietNamese
  String mapAuthError(String message) {
    if (message.contains('User already registered')) {
      return 'Email này đã được đăng ký';
    } else if (message.contains('Password should be')) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: const [Text("Tạo tài khoản", style: TextStyle(color: Color(0xFF111827), fontSize: 26, fontWeight: FontWeight.bold,),),
                    SizedBox(height: 6),
                    Text("Tham gia học nhóm ngay hôm nay", style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 20,),),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child:Image.asset("asset/images/3f6a9dd806108e74b4eefff28bd11b3a.jpg", width: double.infinity, height: 250, fit: BoxFit.fill),
              ),
              const SizedBox(height: 28),
              LightTextField(
                controller: nameController,
                hint: "Họ và tên",
                icon: Icons.person_outline,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 14),
              LightTextField(
                controller: emailController,
                hint: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              LightTextField(
                controller: phoneController,
                hint: "Số điện thoại",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 14),
              LightTextField(
                controller: passwordController,
                hint: "Mật khẩu",
                icon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF9CA3AF), size: 20,),
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                ),
              ),
              const SizedBox(height: 14),
              LightTextField(
                controller: confirmPasswordController,
                hint: "Xác nhận mật khẩu",
                icon: Icons.lock_outline,
                obscureText: obscureConfirm,
                suffixIcon: IconButton(icon: Icon(obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF9CA3AF), size: 20,),
                  onPressed: () =>
                      setState(() => obscureConfirm = !obscureConfirm),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleRegister, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                    elevation: 0,
                  ),
                  child: isLoading ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,
                    ),
                  ) : const Text("Đăng ký", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,),),
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const PageLogin()), (route) => false,),
                  child: RichText(
                    text: const TextSpan(text:"Đã có tài khoản?", style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                      children: [
                        TextSpan(text:"Đăng nhập", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600,),),
                      ],
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
}

class LightTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const LightTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Color(0xFF111827), fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF6B7280),),
        prefixIcon: Icon(icon, color: Color(0xFF6B7280), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}