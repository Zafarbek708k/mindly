import 'package:flutter/material.dart';

class QuizDetailsScreen extends StatelessWidget {
  const QuizDetailsScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Details')),
      body: Center(child: Text('Quiz Details Screen for quizId: $quizId')),
    );
  }
}
