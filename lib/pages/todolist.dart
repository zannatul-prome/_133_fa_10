import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.pink,
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
        title: Text('Pastel To-Do List'),
        backgroundColor: Colors.pink.shade200,
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
            // Input Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: _editingIndex == null
                              ? 'Add a new task'
                              : 'Edit your task',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: Text('Add', style: TextStyle(fontSize: 16)),
                    )
                  else
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _updateTask(_editingIndex!, _textController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
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
                  // Choose gradient based on task index for variety
                  final gradientColors = [
                    [Colors.white, Colors.pink.shade50],
                    [Colors.white, Colors.green.shade50],
                    [Colors.white, Colors.orange.shade50],
                  ];
                  final colors = gradientColors[index % 3];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) => _toggleTask(index),
                        activeColor: Colors.pink.shade200,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task.isCompleted
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
}

class Task {
  final String title;
  final bool isCompleted;

  Task(this.title, this.isCompleted);
}
