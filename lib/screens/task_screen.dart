import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TaskService _taskService = TaskService();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    _taskService.addTask(title);
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      body: Column(
        children: [
          // INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration:
                        const InputDecoration(hintText: "Enter task..."),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          // LIST
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.streamTasks(),
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      title: Text(task.title),

                      // CHECKBOX
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) =>
                            _taskService.toggleTask(task),
                      ),

                      // DELETE
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _taskService.deleteTask(task.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}