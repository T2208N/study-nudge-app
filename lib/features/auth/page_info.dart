import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PagePersonalInfo extends StatelessWidget {
  final Map<String, dynamic>? profile;
  const PagePersonalInfo({super.key, required this.profile});

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(raw).toLocal());
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = profile?['name'] ?? '—';
    final email = profile?['email'] ?? '—';
    final phone = profile?['phonenumber']?.toString() ?? '—';
    final createdAt = _formatDate(profile?['created_at']?.toString());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1E),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
        ),
        title: const Text('Thông tin cá nhân', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Hero card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1A2A5E), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF60A5FA), width: 2.5)),
                    child: ClipOval(child: Image.network('https://i.pinimg.com/736x/db/4a/78/db4a786eb7827734353ae18464d8e408.jpg', fit: BoxFit.cover)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(email, style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 11)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF60A5FA).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF60A5FA).withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Color(0xFFFBBF24), size: 10),
                            SizedBox(width: 4),
                            Text('Member', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 10, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Icon(Icons.person_outline, color: Color(0xFF60A5FA), size: 18),
                SizedBox(width: 6),
                Text('Thông tin cá nhân', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  InfoTile(icon: Icons.person_outline,iconColor: const Color(0xFF60A5FA), label: "Họ và tên",value: name),
                  InfoTile(icon: Icons.email_outlined,iconColor: const Color(0xFF818CF8), label: "Email",value: email),
                  InfoTile(icon: Icons.phone_outlined,iconColor: const Color(0xFF34D399), label: "Số điện thoại", value: phone),
                  InfoTile(icon: Icons.calendar_today_outlined, iconColor: const Color(0xFFFBBF24), label: "Ngày tham gia", value: createdAt, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isLast;
  const InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF111827),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(9)),
                child: Icon(icon, color: iconColor, size: 17),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Color(0xFF4B6CB7), fontSize: 10)),
                    const SizedBox(height: 2),
                    Text(value, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFF1E3A6E), height: 1, thickness: 0.5),
      ],
    );
  }
}