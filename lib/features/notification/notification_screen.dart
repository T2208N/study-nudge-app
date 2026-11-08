import 'package:flutter/material.dart';
import 'package:sync_team/features/notification/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }
  Future<void> load() async {
    notifications = await NotificationService.getMyNotifications();
    setState(() => isLoading = false);
  }
  Map<String, List> groupData() {
    Map<String, List> map = {
      "task": [],
      "group": [],
    };
    for (var n in notifications) {
      if (n['type'] == 'task') {
        map["task"]!.add(n);
      } else if (n['type'] == 'group') {
        map["group"]!.add(n);
      }
    }
    return map;
  }
  @override
  Widget build(BuildContext context) {
    final data = groupData();
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F16),
        elevation: 0,
        title: const Text("Thông báo", style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold),
        ),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(12),
        children: [
          section("Task", data["task"]!, Colors.blue),
          section("Group", data["group"]!, Colors.purple),
        ],
      ),
    );
  }
  Widget section(String title, List items, Color color) {
    if (items.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Column(
          children: [
            for (var i = 0; i < items.length; i++)
              _item(items[i], color),
          ],
        ),
      ],
    );
  }
  Widget _item(Map item, Color color) {
    String _formatTime(String? time) {
      if (time == null) return '';
      final dt = DateTime.tryParse(time);
      if (dt == null) return '';
      return "${dt.day}/${dt.month}/${dt.year}";
    }
    final createdAt = item['created_at'];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141B2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon(item['type']), color: color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item['message'] ?? '',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  _formatTime(createdAt),
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData icon(String? type) {
    switch (type) {
      case "task":
        return Icons.task_alt;
      case "group":
        return Icons.group;
      default:
        return Icons.notifications;
    }
  }
}