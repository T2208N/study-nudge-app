import 'package:flutter/material.dart';
import 'package:sync_team/features/group/services/group_service.dart';
import 'package:sync_team/features/tasks/services/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map task;
  final int groupId;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.groupId,
  });

  @override
  State<TaskDetailScreen> createState() =>
      _TaskDetailScreenState();
}

class _TaskDetailScreenState
    extends State<TaskDetailScreen> {
  late String selectedStatus;
  String? selectedUser;
  DateTime? selectedDeadline;
  List members = [];

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.task['status'];

    selectedUser = widget.task['assigned_to'];
    if (widget.task['deadline'] != null) {
      selectedDeadline = DateTime.parse(
        widget.task['deadline'],
      );
    }

    loadMembers();
  }

  Future<void> pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
      selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDeadline = picked;
      });
    }
  }

  Future<void> loadMembers() async {
    members =
    await GroupService.getMembers(widget.groupId);

    setState(() {});
  }

  Future<void> saveChanges() async {
    await TaskService.updateTask(
      taskId: widget.task['id'],
      title: widget.task['title'],
      description: widget.task['description'] ?? '',
      status: selectedStatus,
      assignedTo: selectedUser,
      deadline: selectedDeadline
          ?.toIso8601String(),
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> deleteTask() async {
    await TaskService.deleteTask(
      widget.task['id'],
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Widget statusChip(String value) {
    final isSelected = selectedStatus == value;

    Color selectedColor;
    Color borderColor;

    switch (value) {
      case 'doing':
        selectedColor = Colors.orange;
        borderColor = Colors.orange;
        break;

      case 'done':
        selectedColor = Colors.green;
        borderColor = Colors.green;
        break;

      default:
        selectedColor = Colors.grey;
        borderColor = Colors.white54;
    }

    return ChoiceChip(
      label: Text(
        value.toUpperCase(),
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),

      selected: isSelected,

      backgroundColor: const Color(0xFF1B2233),

      selectedColor: selectedColor,

      side: BorderSide(
        color: isSelected
            ? selectedColor
            : borderColor,
        width: 1.5,
      ),

      onSelected: (_) {
        setState(() {
          selectedStatus = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F16),
        title: const Text(
          "Task Detail",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.task['title'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.task['description'] ?? '',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Status",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: [
                statusChip("todo"),
                statusChip("doing"),
                statusChip("done"),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Assign To",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String?>(
              value: members.any(
                    (m) => m['profiles']['id'] == selectedUser,
              )
                  ? selectedUser
                  : null,
              dropdownColor:
              const Color(0xFF1B2233),

              decoration: InputDecoration(
                filled: true,
                fillColor:
                const Color(0xFF1B2233),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    "Unassigned",
                    style:  TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                ...members.map((member) {
                  final profile =
                  member['profiles'];

                  return DropdownMenuItem(
                    value: profile['id'],
                    child: Text(
                      profile['name'],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ],

              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),

            const SizedBox(height: 24),

            const Text(
              "Deadline",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: pickDeadline,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2233),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Text(
                  selectedDeadline == null
                      ? "Select deadline"
                      : "${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveChanges,
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF2F6BFF),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: deleteTask,
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Delete Task",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}