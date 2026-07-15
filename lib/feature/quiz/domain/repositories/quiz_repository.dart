import 'package:mindly/feature/quiz/domain/entities/question.dart';

abstract class QuizRepository {
  Future<List<Question>> getQuestions({required String quizId});
}
