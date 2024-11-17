import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart'; 
import 'leaderboard_screen.dart';

class QuizScreen extends StatefulWidget {
  final String userName;
  final String category;

  QuizScreen({required this.userName, required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  List<String?> selectedAnswers = [];
  List<String> shuffledAnswers = [];
  final int timeLimit = 15;
  final CountDownController _controller = CountDownController();

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
        questions = questions.map((question) {
          question['question'] = parseHtmlString(question['question']);
          question['correct_answer'] = parseHtmlString(question['correct_answer']);
          question['incorrect_answers'] = question['incorrect_answers']
              .map((answer) => parseHtmlString(answer))
              .toList();
          return question;
        }).toList();
        isLoading = false;
        selectedAnswers = List<String?>.filled(questions.length, null);
        setShuffledAnswers();
        _controller.start();
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

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? htmlString;
  }

  void setShuffledAnswers() {
    shuffledAnswers = List<String>.from(questions[currentQuestionIndex]['incorrect_answers']);
    shuffledAnswers.add(questions[currentQuestionIndex]['correct_answer']);
    shuffledAnswers.shuffle(Random());
  }

  void checkAnswer() {
    if (selectedAnswers[currentQuestionIndex] != null &&
        selectedAnswers[currentQuestionIndex] == questions[currentQuestionIndex]['correct_answer']) {
      score++;
    }
  }

  void goToNextQuestion() {
    checkAnswer();
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        setShuffledAnswers();
      });
      _controller.restart(duration: timeLimit);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LeaderboardScreen(score: score, totalQuestions: questions.length),
        ),
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
            CircularCountDownTimer(
              duration: timeLimit,
              initialDuration: 0,
              controller: _controller,
              width: 80,
              height: 80,
              ringColor: Colors.grey[300]!,
              ringGradient: null,
              fillColor: Colors.teal[700]!,
              fillGradient: null,
              backgroundColor: Colors.white,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              isReverse: true,
              isReverseAnimation: true,
              onComplete: () {
                goToNextQuestion();
              },
            ),
            const SizedBox(height: 10),
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
                        groupValue: selectedAnswers[currentQuestionIndex],
                        onChanged: (value) {
                          setState(() {
                            selectedAnswers[currentQuestionIndex] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: goToNextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

