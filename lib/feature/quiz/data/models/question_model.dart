import 'package:mindly/feature/quiz/domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({required super.id, required super.text, required super.options, required super.correctIndex});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List<dynamic>? ?? const []).map((o) => o.toString()).toList(growable: false);
    final rawIndex = json['correct_index'];
    final correctIndex = rawIndex is int ? rawIndex : int.tryParse('$rawIndex') ?? 0;
    return QuestionModel(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      options: options,
      correctIndex: correctIndex.clamp(0, options.isEmpty ? 0 : options.length - 1),
    );
  }
}
