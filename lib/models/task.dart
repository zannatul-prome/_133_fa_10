
// class Task {
//   final String id;
//   final String title;
//   final bool isCompleted;

//   Task({
//     required this.id,
//     required this.title,
//     required this.isCompleted,
//   });

//   factory Task.fromMap(Map<String, dynamic> map) {
//     return Task(
//       id: map['id'].toString(),
//       title: map['title'] ?? '',
//       isCompleted: (map['is_completed'] == true) || (map['is_completed'] == 1),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'is_completed': isCompleted,
//     };
//   }
// }

// lib/models/task.dart
class Task {
  final String id;
  final DateTime createdAt;
  final String title;
  final String? description;
  final bool isComplete;
  final String priority;
  final String? userId;

  Task({
    required this.id,
    required this.createdAt,
    required this.title,
    this.description,
    this.isComplete = false,
    this.priority = 'medium',
    this.userId,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'] as String,
      description: map['description'] as String?,
      isComplete: map['is_complete'] ?? false,
      priority: map['priority'] ?? 'medium',
      userId: map['user_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'description': description,
      'is_complete': isComplete,
      'priority': priority,
      'user_id': userId,
    };
  }
}

