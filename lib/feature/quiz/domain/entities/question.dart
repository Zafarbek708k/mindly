import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final List<String> options;

  final int correctIndex;

  const Question({required this.id, required this.text, required this.options, required this.correctIndex});

  bool isCorrect(int optionIndex) => optionIndex == correctIndex;

  @override
  List<Object?> get props => [id, text, options, correctIndex];
}
