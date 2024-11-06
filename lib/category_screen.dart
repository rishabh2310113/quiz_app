import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String userName;

  CategoryScreen({required this.userName});

  void selectCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          userName: userName,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Category'),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // Light background color
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hello, $userName!\nChoose a Category:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 30),
              CategoryButton(
                title: 'Mathematics',
                onPressed: () => selectCategory(context, '19'),
              ),
              CategoryButton(
                title: 'Computers',
                onPressed: () => selectCategory(context, '18'),
              ),
              CategoryButton(
                title: 'Gadgets',
                onPressed: () => selectCategory(context, '30'),
              ),
              CategoryButton(
                title: 'Sports',
                onPressed: () => selectCategory(context, '21'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  CategoryButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
