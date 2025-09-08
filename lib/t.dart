import 'package:flutter/material.dart';
import 'dart:io';

// Fixed Task model
class Task {
  final String id;
  final String title;
  final bool isComplete;

  Task({required this.id, required this.title, required this.isComplete});
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  final TextEditingController _textController = TextEditingController();
  int? _editingIndex;

  void _addTask(String text) {
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
          isComplete: false,
        ));
        _textController.clear();
      });
    }
  }

  void _updateTask(int index, String newText) {
    if (newText.isNotEmpty) {
      setState(() {
        tasks[index] = Task(
          id: tasks[index].id,
          title: newText,
          isComplete: tasks[index].isComplete,
        );
        _editingIndex = null;
        _textController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index] = Task(
        id: tasks[index].id,
        title: tasks[index].title,
        isComplete: !tasks[index].isComplete,
      );
    });
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

  void _exitApp() {
    exit(0);
  }

  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((task) => task.isComplete).length;
  int get pendingTasks => totalTasks - completedTasks;
  double get successRate => totalTasks == 0 ? 0 : (completedTasks / totalTasks) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pastel To-Do List'),
        backgroundColor: Colors.pink.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _exitApp,
            tooltip: 'Exit App',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.pink.shade50,
              Colors.green.shade50,
              Colors.orange.shade50
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Summary cards
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard('Total', totalTasks.toString(), Colors.blue.shade200),
                  _buildSummaryCard('Completed', completedTasks.toString(), Colors.green.shade200),
                  _buildSummaryCard('Pending', pendingTasks.toString(), Colors.orange.shade200),
                  _buildSummaryCard('Success', '${successRate.toStringAsFixed(0)}%',
                      Colors.pink.shade200),
                ],
              ),
            ),

            // Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: _editingIndex == null
                              ? 'Add a new task'
                              : 'Edit your task',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  if (_editingIndex == null)
                    ElevatedButton(
                      onPressed: () => _addTask(_textController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text('Add', style: TextStyle(fontSize: 16)),
                    )
                  else
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _updateTask(_editingIndex!, _textController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text('Save', style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: _cancelEditing,
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: Checkbox(
                        value: task.isComplete,
                        onChanged: (value) => _toggleTask(index),
                        activeColor: Colors.pink.shade200,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task.isComplete
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () => _startEditing(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 2),
            Text(title,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
