import 'package:flutter/material.dart';
import 'splash_screen.dart';
void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFE0F7FA),
      ),
      home: SplashScreen(),
    );
  }
}

