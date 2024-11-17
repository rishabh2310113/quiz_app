import 'package:flutter/material.dart';
import 'category_screen.dart';

class IntroScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'QUIZ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.teal[700]),
            ),
            Text(
              'Khelo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.amber[600]),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(userName: _nameController.text),
                    ),
                  );
                }
              },
              child: Text('Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
