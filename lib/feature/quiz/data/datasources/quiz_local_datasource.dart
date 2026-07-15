import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mindly/feature/quiz/data/models/question_model.dart';

abstract class QuizLocalDataSource {
  Future<List<QuestionModel>> loadQuestions({required String quizId});
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  const QuizLocalDataSourceImpl({this.artificialDelay = const Duration(milliseconds: 500)});

  static const _assetPath = 'assets/data/questions.json';

  final Duration artificialDelay;

  @override
  Future<List<QuestionModel>> loadQuestions({required String quizId}) async {
    await Future<void>.delayed(artificialDelay);
    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['questions'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(QuestionModel.fromJson)
        .toList(growable: false);
  }
}
