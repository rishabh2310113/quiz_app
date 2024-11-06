import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'leaderboard_screen.dart';

class QuizScreen extends StatefulWidget {
  final String userName;
  final String category;

  QuizScreen({required this.userName, required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

// class _QuizScreenState extends State<QuizScreen> {
//   List<dynamic> questions = [];
//   int currentQuestionIndex = 0;
//   int score = 0;
//   bool isLoading = true;
//   String? selectedAnswer;

//   @override
//   void initState() {
//     super.initState();
//     fetchQuestions();
//   }

//   Future<void> fetchQuestions() async {
//     final response = await http.get(Uri.parse(
//         'https://opentdb.com/api.php?amount=10&category=${widget.category}&type=multiple'));

//     if (response.statusCode == 200) {
//       setState(() {
//         questions = json.decode(response.body)['results'];
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load questions. Please try again later.')),
//       );
//     }
//   }

//   void checkAnswer(String selectedAnswer) {
//     if (selectedAnswer == questions[currentQuestionIndex]['correct_answer']) {
//       score++;
//     }
//   }

//   void goToNextQuestion() {
//     if (selectedAnswer != null) {
//       checkAnswer(selectedAnswer!);
//       if (currentQuestionIndex < questions.length - 1) {
//         setState(() {
//           currentQuestionIndex++;
//           selectedAnswer = null;
//         });
//       } else {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => LeaderboardScreen(score: score, totalQuestions: questions.length),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an answer before proceeding.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Loading...'),
//           backgroundColor: Colors.teal[700],
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${currentQuestionIndex + 1}/${questions.length}'),
//         backgroundColor: Colors.teal[700],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.0),
//                 boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 2))],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     questions[currentQuestionIndex]['question'],
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   ...((questions[currentQuestionIndex]['incorrect_answers'] as List<dynamic>)..add(questions[currentQuestionIndex]['correct_answer']))
//                       .map((answer) {
//                     return ListTile(
//                       title: Text(answer),
//                       leading: Radio<String>(
//                         value: answer,
//                         groupValue: selectedAnswer,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedAnswer = value;
//                           });
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: goToNextQuestion,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal[700],
//               ),
//               child: const Text(
//                 'Next',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  String? selectedAnswer;
  List<String> shuffledAnswers = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=${widget.category}&type=multiple'));

    if (response.statusCode == 200) {
      setState(() {
        questions = json.decode(response.body)['results'];
        isLoading = false;
        setShuffledAnswers();  // Set answers for the first question
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load questions. Please try again later.')),
      );
    }
  }

  void setShuffledAnswers() {
    // Create a new list containing incorrect answers + the correct answer
    shuffledAnswers = List<String>.from(questions[currentQuestionIndex]['incorrect_answers']);
    shuffledAnswers.add(questions[currentQuestionIndex]['correct_answer']);
    // Shuffle the list
    shuffledAnswers.shuffle(Random());
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['correct_answer']) {
      score++;
    }
  }

  void goToNextQuestion() {
    if (selectedAnswer != null) {
      checkAnswer(selectedAnswer!);
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
          setShuffledAnswers();  // Shuffle answers for the next question
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LeaderboardScreen(score: score, totalQuestions: questions.length),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer before proceeding.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
          backgroundColor: Colors.teal[700],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentQuestionIndex + 1}/${questions.length}'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Text(
                    questions[currentQuestionIndex]['question'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...shuffledAnswers.map((answer) {
                    return ListTile(
                      title: Text(answer),
                      leading: Radio<String>(
                        value: answer,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: goToNextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
              ),
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
