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

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task cannot be empty")),
      );
      return;
    }

    _taskService.addTask(title);
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
      ),
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
                    decoration: const InputDecoration(
                      hintText: "Enter task...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          // TASK LIST
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.streamTasks(),
              builder: (context, snapshot) {

                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ERROR
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading tasks"));
                }

                final tasks = snapshot.data ?? [];

                // EMPTY
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text("No tasks yet. Add one above!"),
                  );
                }

                // DATA
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Card(
                        child: ExpansionTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),

                          // TASK CHECKBOX
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) =>
                                _taskService.updateTask(task),
                          ),

                          // DELETE TASK
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _taskService.deleteTask(task.id),
                          ),

                          children: [
                            // SUBTASKS WITH CHECKBOXES
                            ...List.generate(task.subtasks.length, (i) {
                              final subtask = task.subtasks[i];

                              return ListTile(
                                leading: Checkbox(
                                  value: subtask['done'] ?? false,
                                  onChanged: (value) {
                                    final updatedSubtasks =
                                        List<Map<String, dynamic>>.from(
                                            task.subtasks);

                                    updatedSubtasks[i]['done'] = value;

                                    _taskService.updateSubtasks(
                                        task.id, updatedSubtasks);
                                  },
                                ),
                                title: Text(
                                  subtask['title'] ?? '',
                                  style: TextStyle(
                                    decoration:
                                        (subtask['done'] ?? false)
                                            ? TextDecoration.lineThrough
                                            : null,
                                  ),
                                ),
                              );
                            }),

                            // ADD SUBTASK
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: "Add subtask...",
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (value) {
                                  if (value.trim().isEmpty) return;

                                  final updatedSubtasks =
                                      List<Map<String, dynamic>>.from(
                                          task.subtasks)
                                        ..add({
                                          'title': value.trim(),
                                          'done': false,
                                        });

                                  _taskService.updateSubtasks(
                                      task.id, updatedSubtasks);
                                },
                              ),
                            ),
                          ],
                        ),
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