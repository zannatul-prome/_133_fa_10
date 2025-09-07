import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
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
        tasks.add(Task(text, false));
        _textController.clear();
      });
    }
  }

  void _updateTask(int index, String newText) {
    if (newText.isNotEmpty) {
      setState(() {
        tasks[index] = Task(newText, tasks[index].isCompleted);
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
      tasks[index] = Task(tasks[index].title, !tasks[index].isCompleted);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _editingIndex == null 
                          ? 'Add a new task' 
                          : 'Edit your task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (_editingIndex == null)
                  ElevatedButton(
                    onPressed: () => _addTask(_textController.text),
                    child: Text('Add'),
                  )
                else
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateTask(_editingIndex!, _textController.text),
                        child: Text('Save'),
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
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => _toggleTask(index),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _startEditing(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ],
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

class Task {
  final String title;
  final bool isCompleted;

  Task(this.title, this.isCompleted);
}