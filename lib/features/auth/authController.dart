import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final SupabaseClient supabase = Supabase.instance.client;

  String? validateRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty) return 'Vui lòng nhập họ và tên';
    if (email.trim().isEmpty) return 'Vui lòng nhập email';
    if (!email.contains('@')) return 'Email không hợp lệ';
    if (phone.trim().isEmpty) return 'Vui lòng nhập số điện thoại';
    if (int.tryParse(phone) == null) return 'Số điện thoại không hợp lệ';
    if (password.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    if (password != confirmPassword) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    return supabase.auth.signUp(
      email: email.trim(),
      password: password.trim(),
      data: {
        'name': name.trim(),
        'phonenumber': phone.trim(),
      },
    );
  }

  String? validateLogin({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Vui lòng nhập đầy đủ thông tin';
    }
    return null;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String code,
  }) {
    return supabase.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: code,
    );
  }


  Future<Map<String, dynamic>> getProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');
    return await supabase
        .from('profiles')
        .select('id, email, name, phonenumber, created_at')
        .eq('id', user.id)
        .single();
  }

  Future<int> getGroupCount() async {
    final user = supabase.auth.currentUser;
    final groups = await supabase
        .from('group_member')
        .select('id')
        .eq('user_id', user!.id);
    return (groups as List).length;
  }

  Future<int> getTaskCount() async {
    final user = supabase.auth.currentUser;
    final tasks = await supabase
        .from('task')
        .select('id')
        .eq('assigned_to', user!.id);
    return (tasks as List).length;
  }

  Future<({Map<String, dynamic> profile, int groupCount, int taskCount})>
  loadAccountData() async {
    final profile = await getProfile();
    final groupCount = await getGroupCount();
    final taskCount = await getTaskCount();
    return (profile: profile, groupCount: groupCount, taskCount: taskCount);
  }


  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  String mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Email hoặc mật khẩu không đúng';
    }
    if (message.contains('Email not confirmed')) {
      return 'Vui lòng xác thực email trước khi đăng nhập';
    }
    if (message.contains('User already registered')) {
      return 'Email này đã được đăng ký';
    }
    return message;
  }
}