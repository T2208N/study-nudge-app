import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sync_team/features/auth/authController.dart';
import 'package:sync_team/features/auth/page_login.dart';

class PageVerifyOtp extends StatelessWidget {
  final String email;
  const PageVerifyOtp({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Container(
              width: 68,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                color: Color(0xFF2563EB),
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Xác thực OTP',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF9CA3AF), height: 1.5),
                children: [
                  const TextSpan(text: 'Nhập mã 6 chữ số đã gửi đến\n'),
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            OtpTextField(
              numberOfFields: 6,
              borderColor: const Color(0xFFE2E8F0),
              focusedBorderColor: const Color(0xFF2563EB),
              showFieldAsBox: true,
              borderWidth: 1.5,
              fieldWidth: 45,
              borderRadius: BorderRadius.circular(10),
              filled: true,
              fillColor: Colors.white,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827),
              ),
              clearText: true,
              onCodeChanged: (_) {},
              onSubmit: (String verificationCode) async {
                try {
                  final response = await authController.verifyOtp(
                    email: email,
                    code: verificationCode,
                  );
                  if (response.user != null && context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const PageLogin()),
                          (route) => false,
                    );
                  }
                } on AuthException catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Tự động xác thực khi nhập đủ 6 số',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }
}