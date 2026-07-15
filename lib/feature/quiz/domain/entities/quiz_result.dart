import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeSpent;

  const QuizResult({required this.totalQuestions, required this.correctAnswers, required this.timeSpent});

  int get wrongAnswers => totalQuestions - correctAnswers;

  double get ratio => totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  int get percent => (ratio * 100).round();

  @override
  List<Object?> get props => [totalQuestions, correctAnswers, timeSpent];
}
