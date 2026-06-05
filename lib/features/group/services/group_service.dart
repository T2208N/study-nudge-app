import 'package:supabase_flutter/supabase_flutter.dart';

class GroupService {
  static final supabase = Supabase.instance.client;

  // TẠO NHÓM

  static Future<Map<String, dynamic>> createGroup(String name) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User chưa đăng nhập');
    }

    final code = DateTime.now()
        .millisecondsSinceEpoch
        .toString()
        .substring(7);

    final group = await supabase.from('groups').insert({
      'name': name,
      'invite_code': code,
      'owner_id': user.id,
    }).select().single();

    await supabase.from('group_member').insert({
      'group_id': group['id'],
      'user_id': user.id,
      'role': 'owner',
    });

    return group;
  }

  // THÊM NHÓM

  static Future<Map<String, dynamic>?> joinGroup(String code) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User chưa đăng nhập');
    }

    final group = await supabase
        .from('groups')
        .select()
        .eq('invite_code', code)
        .maybeSingle();

    if (group == null) {
      return null;
    }

    final oldMember = await supabase
        .from('group_member')
        .select()
        .eq('group_id', group['id'])
        .eq('user_id', user.id)
        .maybeSingle();

    if (oldMember == null) {
      await supabase.from('group_member').insert({
        'group_id': group['id'],
        'user_id': user.id,
        'role': 'member',
      });
    }

    return group;
  }

  //LẤY DANH SÁCH THÀNH VIÊN

  static Future<List<dynamic>> getMembers(int groupId) async {
    final data = await supabase
        .from('group_member')
        .select('''
          role,
          profiles(
            id,
            name,
            email
          )
        ''')
        .eq('group_id', groupId);

    return data;
  }

  //LẤY DANH SÁCH NHÓM

  static Future<List<dynamic>> getMyGroups() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final data = await supabase
        .from('group_member')
        .select('''
        role,
        groups(
          id,
          name,
          invite_code,
          created_at
        )
      ''')
        .eq('user_id', user.id);

    return data;
  }

  // SỬA TÊN NHÓM
  static Future<void> updateGroupName(int groupId, String newName) async {
    await supabase
        .from('groups')
        .update({
      'name': newName,
    })
        .eq('id', groupId);
  }

// GIẢI TÁN NHÓM
  static Future<void> deleteGroup(int groupId) async {
    await supabase
        .from('groups')
        .delete()
        .eq('id', groupId);
  }

// RỜI NHÓM
  static Future<void> leaveGroup(int groupId) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User chưa đăng nhập');
    }

    await supabase
        .from('group_member')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', user.id);
  }
}