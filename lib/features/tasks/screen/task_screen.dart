import 'package:flutter/material.dart';
import 'package:sync_team/features/tasks/screen/task_detail_screen.dart';
import 'package:sync_team/features/tasks/services/task_service.dart';
import 'task_form_screen.dart';

class TaskScreen extends StatefulWidget {
  final int groupId;
  final Function(List)? onTasksChanged;

  const TaskScreen({
    super.key,
    required this.groupId,
    this.onTasksChanged,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List tasks = [];
  String filter = 'all';
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      tasks = await TaskService.getTasks(widget.groupId);
      widget.onTasksChanged?.call(tasks);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List get filteredTasks {
    if (filter == 'all') {
      return tasks;
    }

    return tasks.where(
          (e) => e['status'] == filter,
    ).toList();
  }

  Future<void> openCreateTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(
          groupId: widget.groupId,
        ),
      ),
    );

    if (result == true) {
      await  loadTasks();
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'doing':
        return Colors.orange;
      default:
        return const Color(0xFF2F6BFF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              const Text(
                "Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0F16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: filter,
                  dropdownColor: const Color(0xFF1B2233),
                  underline: const SizedBox(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'todo',
                      child: Text('Todo'),
                    ),
                    DropdownMenuItem(
                      value: 'doing',
                      child: Text('Doing'),
                    ),
                    DropdownMenuItem(
                      value: 'done',
                      child: Text('Done'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filter = value!;
                    });
                  },
                ),
              ),

              const SizedBox(width: 8),

              IconButton(
                onPressed: openCreateTask,
                icon: const Icon(
                  Icons.add_circle,
                  color: Color(0xFF2F6BFF),
                  size: 30,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Task List
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : filteredTasks.isEmpty
                ? const Center(
              child: Text(
                "Chưa có task nào",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (_, index) {
                final task = filteredTasks[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  color: const Color(0xFF0B0F16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(
                            task: task,
                            groupId: widget.groupId,
                          ),
                        ),
                      );

                      if (result == true) {
                        loadTasks();
                      }
                    },

                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            task['title'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              task['status'],
                            ),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            (task['status'] ?? '')
                                .toString()
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: Colors.white54,
                                size: 14,
                              ),

                              const SizedBox(width: 4),

                              Expanded(
                                child: Text(
                                  task['profiles']?['name'] ??
                                      'Unassigned',
                                  style: const TextStyle(
                                    color: Color(0xFF2F6BFF),
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    task['deadline'] ?? 'No deadline',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white38,
                      size: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}