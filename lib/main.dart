import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/todolist.dart'; // Your existing To-Do List page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://chdqlrpmatcwniwyhahx.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoZHFscnBtYXRjd25pd3loYWh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1OTY2NTcsImV4cCI6MjA3MjE3MjY1N30.msMf6RhfR01mPGOkf08c_lhbxBhhAm7y784nvWpxmYU",
  );

  runApp(MyApp());
}

// Global Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the To-Do List page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoListScreen()),
            );
          },
          child: Text('Go to To-Do List'),
        ),
      ),
    );
  }
}
