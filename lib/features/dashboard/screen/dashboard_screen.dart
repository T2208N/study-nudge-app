import 'package:flutter/material.dart';

class TaskDashboard extends StatelessWidget {
  final List tasks;

  const TaskDashboard({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;

    final todo =
        tasks.where((e) => e['status'] == 'todo').length;

    final doing =
        tasks.where((e) => e['status'] == 'doing').length;

    final done =
        tasks.where((e) => e['status'] == 'done').length;

    Widget buildCard(
        String title,
        int value,
        Color color,
        ) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2233),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        buildCard(
          'Total',
          total,
          Colors.blue,
        ),
        buildCard(
          'Todo',
          todo,
          Colors.grey,
        ),
        buildCard(
          'Doing',
          doing,
          Colors.orange,
        ),
        buildCard(
          'Done',
          done,
          Colors.green,
        ),
      ],
    );
  }
}