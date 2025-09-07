import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Supabase.initialize(
    url: "https://dqagdnnxomobyyofpmto.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxYWdkbm54b21vYnl5b2ZwbXRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxMzYxNTIsImV4cCI6MjA3MjcxMjE1Mn0.ZGQz0blL_OptiY8oUAtNxQdZhUOyc87hS05m6G2AtmY"
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 139, 38, 233),
      ),
      home: const SignInPage(),
    );
  }
}
  

  