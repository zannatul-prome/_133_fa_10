import 'package:flutter/material.dart';
import 'dart:io';
import '../models/task.dart';
import '../services/task_service.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  final TextEditingController _textController = TextEditingController();
  final TaskService _taskService = TaskService();

  bool _loading = false;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    try {
      tasks = await _taskService.fetchTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addTask(String text) async {
    if (text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final newTask = await _taskService.addTask(text);
      setState(() {
        tasks.insert(0, newTask);
        _textController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateTask(int index, String newText) async {
    if (newText.isEmpty) return;
    setState(() => _loading = true);
    try {
      final updated = await _taskService.updateTask(
        tasks[index].id,
        title: newText,
      );
      setState(() {
        tasks[index] = updated;
        _editingIndex = null;
        _textController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteTask(int index) async {
    setState(() => _loading = true);
    try {
      await _taskService.deleteTask(tasks[index].id);
      setState(() => tasks.removeAt(index));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleTask(int index) async {
    setState(() => _loading = true);
    try {
      final current = tasks[index];
      final updated = await _taskService.updateTask(
        current.id,
        // isCompleted: !current.isComplete, // matches TaskService
      );
      setState(() => tasks[index] = updated);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Toggle failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _textController.text = tasks[index].title;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingIndex = null;
      _textController.clear();
    });
  }

  void _exitApp() => exit(0);

  int get totalTasks => tasks.length;
  int get completedTasks =>
      tasks.where((task) => task.isComplete).length;
  int get pendingTasks => totalTasks - completedTasks;
  double get successRate => totalTasks == 0 ? 0 : (completedTasks / totalTasks) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pastel To-Do List'),
        backgroundColor: Colors.pink.shade200,
        actions: [IconButton(icon: Icon(Icons.exit_to_app), onPressed: _exitApp)],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.pink.shade50, Colors.green.shade50, Colors.orange.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSummaryCard('Total', totalTasks.toString(), Colors.blue.shade200),
                      _buildSummaryCard('Completed', completedTasks.toString(), Colors.green.shade200),
                      _buildSummaryCard('Pending', pendingTasks.toString(), Colors.orange.shade200),
                      _buildSummaryCard('Success', '${successRate.toStringAsFixed(0)}%', Colors.pink.shade200),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: _editingIndex == null ? 'Add a new task' : 'Edit your task',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (_editingIndex == null)
                        ElevatedButton(
                          onPressed: () async => await _addTask(_textController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade200,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text('Add', style: TextStyle(fontSize: 16)),
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async => await _updateTask(_editingIndex!, _textController.text),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade200,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: Text('Save', style: TextStyle(fontSize: 16)),
                            ),
                            SizedBox(width: 8),
                            TextButton(onPressed: _cancelEditing, child: Text('Cancel')),
                          ],
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadTasks,
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            leading: Checkbox(
                              value: task.isComplete,
                              onChanged: (_) => _toggleTask(index),
                              activeColor: Colors.pink.shade200,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                decoration: task.isComplete ? TextDecoration.lineThrough : TextDecoration.none,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _startEditing(index)),
                                IconButton(icon: Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _deleteTask(index)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Container(
        width: 70,
        height: 70,
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 2),
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
