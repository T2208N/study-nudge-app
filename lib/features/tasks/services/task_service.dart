import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  static final supabase = Supabase.instance.client;

  static Future<List<dynamic>> getTasks(int groupId) async {
    return await supabase
        .from('task')
        .select('''
          *,
          profiles!task_assigned_to_fkey(
            id,
            name,
            email
          )
        ''')
        .eq('group_id', groupId)
        .order('created_at');
  }

  static Future<Map<String, dynamic>?> getTaskById(
      int taskId,
      ) async {
    return await supabase
        .from('task')
        .select('''
          *,
          profiles!task_assigned_to_fkey(
            id,
            name,
            email
          )
        ''')
        .eq('id', taskId)
        .maybeSingle();
  }

  static Future<void> createTask({
    required int groupId,
    required String title,
    required String description,
    String? assignedTo,
  }) async {
    await supabase.from('task').insert({
      'group_id': groupId,
      'title': title,
      'description': description,
      'status': 'todo',
      'assigned_to': assignedTo,
    });
  }

  static Future<void> updateTask({
    required int taskId,
    required String title,
    required String description,
    required String status,
    String? assignedTo,
    String ? deadline
  }) async {
    await supabase.from('task').update({
      'title': title,
      'description': description,
      'status': status,
      'assigned_to': assignedTo,
      'deadline': deadline
    }).eq('id', taskId);
  }

  static Future<void> updateTaskStatus(
      int taskId,
      String status,
      ) async {
    await supabase.from('task').update({
      'status': status,
    }).eq('id', taskId);
  }

  static Future<void> assignTask(
      int taskId,
      String? userId,
      ) async {
    await supabase.from('task').update({
      'assigned_to': userId,
    }).eq('id', taskId);
  }

  static Future<void> deleteTask(
      int taskId,
      ) async {
    await supabase
        .from('task')
        .delete()
        .eq('id', taskId);
  }
}