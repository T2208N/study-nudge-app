import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sync_team/features/dashboard/screen/dashboard_screen.dart';
import 'package:sync_team/features/group/services/group_service.dart';
import 'package:sync_team/features/tasks/screen/task_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final int groupId;
  final String groupName;
  final String inviteCode;
  final String createdAt;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.inviteCode,
    required this.createdAt,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List members = [];
  List tasks = [];

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  Future<void> loadMembers() async {
    members = await GroupService.getMembers(widget.groupId);
    setState(() {});
  }
  void showMembers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B2233),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (_) {
        return ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: members.length + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "Thành viên nhóm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final member = members[index - 1];
            final profile = member['profiles'];

            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF2F6BFF),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(
                profile['name'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                profile['email'],
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: Text(
                member['role'],
                style: const TextStyle(
                  color: Color(0xFF2F6BFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(widget.createdAt);
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B0F16),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF2F6BFF),
                  child: Icon(
                    Icons.groups,
                    color: Colors.white,
                    size: 16,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    widget.groupName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            Text(
              "Ngày tạo: $formattedDate",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: showMembers,
            icon: const Icon(
              Icons.people,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TaskDashboard(
              tasks: tasks,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2233),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: TaskScreen(
                    groupId: widget.groupId,
                    onTasksChanged: (data) {
                      setState(() {
                        tasks = data;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2233),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "CODE: ${widget.inviteCode}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // FloatingActionButton.small(
                  //   onPressed: () {},
                  //   backgroundColor: const Color(0xFF2F6BFF),
                  //   foregroundColor: Colors.white,
                  //   child: const Icon(Icons.add),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}