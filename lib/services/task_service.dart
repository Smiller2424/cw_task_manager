import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;

    await tasks.add({
      'title': title.trim(),
      'isCompleted': false,
      'subtasks': [],
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Task>> streamTasks() {
    return tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> toggleTask(Task task) async {
    await tasks.doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }

  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  Future<void> updateSubtasks(
      String taskId, List<Map<String, dynamic>> subtasks) async {
    await tasks.doc(taskId).update({
      'subtasks': subtasks,
    });
  }
}