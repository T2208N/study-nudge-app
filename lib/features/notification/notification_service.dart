import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final supabase = Supabase.instance.client;

  static Future<List<dynamic>> getMyNotifications() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await supabase
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
  }
}