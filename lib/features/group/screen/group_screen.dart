import 'package:flutter/material.dart';
import 'package:sync_team/features/group/services/group_service.dart';
import 'group_detail_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final groupNameController = TextEditingController();
  final groupCodeController = TextEditingController();

  List myGroups = [];

  @override
  void initState() {
    super.initState();
    loadMyGroups();
  }

  Future<void> loadMyGroups() async {
    myGroups = await GroupService.getMyGroups();
    setState(() {});
  }

  void openGroup(Map<String, dynamic> group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupDetailScreen(
          groupId: group['id'],
          groupName: group['name'],
          inviteCode: group['invite_code'],
          createdAt: group['created_at'],
        ),
      ),
    );
  }

  Future<void> createGroup() async {
    final name = groupNameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    final group = await GroupService.createGroup(name);

    groupNameController.clear();

    Navigator.pop(context);

    await loadMyGroups();

    openGroup(group);
  }

  Future<void> joinGroup() async {
    final code = groupCodeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập mã nhóm"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final group = await GroupService.joinGroup(code);

    if (group == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không tìm thấy nhóm"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    groupCodeController.clear();

    Navigator.pop(context);

    await loadMyGroups();

    openGroup(group);
  }

  void showCreateDialog() {
    groupNameController.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2233),
          title: const Text(
            "Tạo nhóm",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: groupNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nhập tên nhóm",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF0B0F16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: createGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6BFF),
                foregroundColor: Colors.white,
              ),
              child: const Text("Tạo"),
            ),
          ],
        );
      },
    );
  }

  void showJoinDialog() {
    groupCodeController.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2233),
          title: const Text(
            "Tham gia nhóm",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: groupCodeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nhập mã nhóm",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF0B0F16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: joinGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6BFF),
                foregroundColor: Colors.white,
              ),
              child: const Text("Join"),
            ),
          ],
        );
      },
    );
  }

  void showGroupMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B2233),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF2F6BFF),
                ),
                title: const Text(
                  "Tạo nhóm mới",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showCreateDialog();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.login,
                  color: Color(0xFF2F6BFF),
                ),
                title: const Text(
                  "Tham gia bằng mã nhóm",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showJoinDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditGroupDialog(Map<String, dynamic> group) {
    final editController = TextEditingController();
    editController.text = group['name'];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2233),
          title: const Text(
            "Sửa tên nhóm",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: editController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Tên nhóm mới",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF0B0F16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = editController.text.trim();

                if (newName.isEmpty) {
                  return;
                }

                await GroupService.updateGroupName(
                  group['id'],
                  newName,
                );

                Navigator.pop(context);

                await loadMyGroups();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6BFF),
                foregroundColor: Colors.white,
              ),
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  void deleteGroup(int groupId) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2233),
          title: const Text(
            "Giải tán nhóm",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Bạn có chắc muốn giải tán nhóm này không?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                await GroupService.deleteGroup(groupId);

                Navigator.pop(context);

                await loadMyGroups();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  void leaveGroup(int groupId) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2233),
          title: const Text(
            "Rời nhóm",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Bạn có chắc muốn rời khỏi nhóm này không?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                await GroupService.leaveGroup(groupId);

                Navigator.pop(context);

                await loadMyGroups();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Rời nhóm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Groups",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0B0F16),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: showGroupMenu,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: myGroups.isEmpty
            ? const Center(
          child: Text(
            "Bạn chưa tham gia nhóm nào",
            style: TextStyle(color: Colors.white54),
          ),
        )
            : ListView.builder(
          itemCount: myGroups.length,
          itemBuilder: (_, index) {
            final item = myGroups[index];
            final group = item['groups'];

            return Card(
              color: const Color(0xFF1B2233),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2F6BFF),
                  child: Icon(
                    Icons.groups,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  group['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "CODE: ${group['invite_code']}",
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['role'],
                      style: const TextStyle(
                        color: Color(0xFF2F6BFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      color: const Color(0xFF1B2233),
                      onSelected: (value) {
                        if (value == 'edit') {
                          showEditGroupDialog(group);
                        }

                        if (value == 'delete') {
                          deleteGroup(group['id']);
                        }

                        if (value == 'leave') {
                          leaveGroup(group['id']);
                        }
                      },
                      itemBuilder: (_) {
                        if (item['role'] == 'owner') {
                          return const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                "Sửa tên nhóm",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                "Giải tán nhóm",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ];
                        }

                        return const [
                          PopupMenuItem(
                            value: 'leave',
                            child: Text(
                              "Rời nhóm",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                onTap: () {
                  openGroup(group);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}