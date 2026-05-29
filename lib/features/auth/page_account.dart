import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sync_team/features/auth/page_info.dart';
import 'page_login.dart';

class PageAccount extends StatefulWidget {
  const PageAccount({super.key});

  @override
  State<PageAccount> createState() => PageAccountState();
}
class PageAccountState extends State<PageAccount> {
  Map<String, dynamic>? profile;
  bool isLoading = true;
  int groupCount = 0;
  int taskCount = 0;
  @override
  void initState() {
    super.initState();
    loadProfile();
  }
  Future<void> loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final response = await Supabase.instance.client
          .from('profiles')
          .select('id, email, name, phonenumber, created_at')
          .eq('id', user.id)
          .single();
      final groups = await Supabase.instance.client
          .from('group_member')
          .select('id')
          .eq('user_id', user.id);
      final tasks = await Supabase.instance.client
          .from('task')
          .select('id')
          .eq('assigned_to', user.id);
      setState(() {
        profile = response;
        groupCount = (groups as List).length;
        taskCount = (tasks as List).length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
  Future<void> Logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C2333),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Đăng xuất", style: TextStyle(color: Colors.white)),
        content: const Text("Bạn có chắc muốn đăng xuất không?", style: TextStyle(color: Color(0xFF8892A4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Hủy", style: TextStyle(color: Color(0xFF8892A4))),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Đăng xuất", style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const PageLogin()), (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    final name = profile?['name'] ?? 'Người dùng';
    final email = profile?['email'] ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        elevation: 0,
        title: Row(
          children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("STUDYGROUP", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text("Học nhóm", style: TextStyle(color: Color(0xFF8892A4), fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 16), width: 36, height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB), shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (profile?['name'] ?? 'U').isNotEmpty ? (profile?['name'] ?? 'U')[0].toUpperCase() : 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
          ),
        ],
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))) : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1C2333), borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: const NetworkImage('https://i.pinimg.com/736x/db/4a/78/db4a786eb7827734353ae18464d8e408.jpg',),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(email, style: const TextStyle(color: Color(0xFF8892A4), fontSize: 12)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
                          SizedBox(width: 4),
                          Text("Member", style: TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2333),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(value: groupCount.toString(), label: 'Nhóm'),
                Container(width: 1, height: 36, color: const Color(0xFF2A3448)),
                _StatItem(value: taskCount.toString(), label: 'Task'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          MenuItem(
            icon: Icons.person_outline,
            label: "Thông tin cá nhân",
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PagePersonalInfo(profile: profile),
              ),
            ),
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: Icons.notifications_none_outlined,
            label: "Thông báo",
            onTap: () {},
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: Icons.group_outlined,
            label: 'Groups',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          MenuItem(
            icon: Icons.task_outlined,
            label: 'Task Manager',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: Logout,
            icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
            label: const Text("Đăng xuất", style: TextStyle(color: Color(0xFFEF4444), fontSize: 15)),
            style: TextButton.styleFrom(backgroundColor: const Color(0xFFEF4444).withOpacity(0.1), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const MenuItem({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: const Color(0xFF1C2333),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF8892A4)),
    );
  }
}
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFF8892A4), fontSize: 12)),
      ],
    );
  }
}
