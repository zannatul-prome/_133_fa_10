// lib/services/task_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskService {
  final _supabase = Supabase.instance.client;

  // Fetch all tasks, ordered by created_at descending
  Future<List<Task>> fetchTasks() async {
    final res = await _supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    if (res == null) return [];
    return (res as List)
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Add a new task
  Future<Task> addTask(String title) async {
    final res = await _supabase
        .from('tasks')
        .insert({'title': title, 'is_complete': false})
        .select()
        .single();
    return Task.fromMap(Map<String, dynamic>.from(res));
  }

  // Update a task (title and/or completion status)
  Future<Task> updateTask(String id, {String? title, bool? isComplete}) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (isComplete != null) body['is_complete'] = isComplete;

    final res = await _supabase
        .from('tasks')
        .update(body)
        .eq('id', id)
        .select()
        .single();
    return Task.fromMap(Map<String, dynamic>.from(res));
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await _supabase.from('tasks').delete().eq('id', id);
  }
}
