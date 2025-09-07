import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _taskController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];
  int _completedTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    // Load tasks from user metadata
    final userMetadata = _authService.getUserMetadata();
    if (userMetadata != null && userMetadata['tasks'] != null) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(userMetadata['tasks']);
        _completedTasks = _tasks.where((task) => task['completed'] == true).length;
      });
    }
  }

  void _saveTasks() async {
    await _authService.updateUserMetadata({
      'tasks': _tasks,
    });
  }

  void _addTask() {
    if (_taskController.text.isEmpty) return;

    setState(() {
      _tasks.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _taskController.text,
        'completed': false,
      });
      _taskController.clear();
    });

    _saveTasks();
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
      _completedTasks = _tasks.where((task) => task['completed'] == true).length;
    });

    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      if (_tasks[index]['completed']) {
        _completedTasks--;
      }
      _tasks.removeAt(index);
    });

    _saveTasks();
  }

  void _signOut() async {
    try {
      await _authService.signOut();
      // Navigate back to sign in page
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: const Color.fromARGB(255, 139, 38, 233),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _tasks.length, Colors.blue),
                _buildStatCard('Completed', _completedTasks, Colors.green),
                _buildStatCard('Pending', _tasks.length - _completedTasks, Colors.orange),
              ],
            ),
          ),

          // Add task input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 139, 38, 233),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addTask,
                  ),
                ),
              ],
            ),
          ),

          // Tasks list
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checklist, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No tasks yet!', style: TextStyle(fontSize: 18)),
                        Text('Add a new task to get started', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Dismissible(
                        key: Key(task['id'].toString()),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) => _deleteTask(index),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: Checkbox(
                              value: task['completed'],
                              onChanged: (_) => _toggleTask(index),
                            ),
                            title: Text(
                              task['title'],
                              style: TextStyle(
                                decoration: task['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
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

  Widget _buildStatCard(String title, int count, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}