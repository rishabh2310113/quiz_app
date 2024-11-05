import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  LeaderboardScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber[600],
              child: Text(
                '$score/${totalQuestions}',
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Well done!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index == 0 ? Colors.amber[700] : Colors.grey[300],
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Player ${index + 1}'),
                    trailing: Text('${(10 - index)}/${totalQuestions}'),
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
