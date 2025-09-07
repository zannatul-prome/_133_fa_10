import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://chdqlrpmatcwniwyhahx.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoZHFscnBtYXRjd25pd3loYWh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1OTY2NTcsImV4cCI6MjA3MjE3MjY1N30.msMf6RhfR01mPGOkf08c_lhbxBhhAm7y784nvWpxmYU",
  );

  runApp(MyApp());
}

// Global Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To-Do List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple To-Do List')),
      body: Center(child: Text('Hello from Supabase!')),
    );
  }
}
