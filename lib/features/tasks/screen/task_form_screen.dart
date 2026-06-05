import 'package:flutter/material.dart';
import 'package:sync_team/features/tasks/services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final int groupId;

  const TaskFormScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> saveTask() async {
    if (titleController.text.trim().isEmpty) return;

    await TaskService.createTask(
      groupId: widget.groupId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F16),
        title: const Text(
          "Create Task",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}