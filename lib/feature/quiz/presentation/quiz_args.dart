import 'package:mindly/feature/quiz/domain/entities/quiz_result.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';

class QuizPlayArgs {
  final String quizId;
  final QuizSource source;

  const QuizPlayArgs({required this.quizId, this.source = QuizSource.local});
}

class QuizResultArgs {
  final QuizResult result;
  final QuizPlayArgs playArgs;

  const QuizResultArgs({required this.result, required this.playArgs});
}
