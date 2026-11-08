import 'package:flutter/material.dart';
import 'package:sync_team/features/auth/authController.dart';
import 'package:sync_team/features/auth/page_info.dart';
import 'package:sync_team/features/group/screen/group_screen.dart';
import 'package:sync_team/features/notification/notification_screen.dart';
import 'page_login.dart';

class PageAccount extends StatefulWidget {
  const PageAccount({super.key});

  @override
  State<PageAccount> createState() => _PageAccountState();
}

class _PageAccountState extends State<PageAccount> {
  final authController = AuthController();

  Map<String, dynamic>? _profile;
  int groupCount = 0;
  int taskCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAccountData();
  }

  Future<void> loadAccountData() async {
    try {
      final data = await authController.loadAccountData();
      if (mounted) {
        setState(() {
          _profile = data.profile;
          groupCount = data.groupCount;
          taskCount = data.taskCount;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C2333),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất',
            style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc muốn đăng xuất không?',
            style: TextStyle(color: Color(0xFF8892A4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy',
                style: TextStyle(color: Color(0xFF8892A4))),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Đăng xuất',
                style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await authController.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const PageLogin()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile?['name'] ?? 'Người dùng';
    final email = _profile?['email'] ?? '';
    final avatarLetter = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
              const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STUDYGROUP', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold,letterSpacing: 1)),
                Text('Học nhóm', style: TextStyle(color: Color(0xFF8892A4), fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
            child: Center(
              child: Text(
                avatarLetter,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF2563EB)))
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2333),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage('https://i.pinim.com/736x/db/4a/7/db4a786eb7827734353ae18464d8e408.jpg',),
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
                        border: Border.all(
                            color: const Color(0xFF2563EB)
                                .withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
                          SizedBox(width: 4),
                          Text('Member', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11,fontWeight: FontWeight.w600)),
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
                _StatItem(value: groupCount.toString(), label:'Nhóm'),
                Container(
                    width: 1,
                    height: 36,
                    color: const Color(0xFF2A3448)),
                _StatItem(value: taskCount.toString(), label:'Task'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _MenuItem(
            icon: Icons.person_outline,
            label: 'Thông tin cá nhân',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    PagePersonalInfo(profile: _profile),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _MenuItem(
              icon: Icons.notifications_none_outlined,
              label: 'Thông báo',
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          _MenuItem(
              icon: Icons.group_outlined,
              label: 'Groups',
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GroupScreen()),
              );
            },),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
            label: const Text('Đăng xuất', style: TextStyle(color: Color(0xFFEF4444), fontSize: 15)),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: const Color(0xFF1C2333),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing:
      const Icon(Icons.chevron_right, color: Color(0xFF8892A4)),
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
        Text(value, style: const TextStyle(color: Color(0xFF2563EB),fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFF8892A4), fontSize: 12)),
      ],
    );
  }
}