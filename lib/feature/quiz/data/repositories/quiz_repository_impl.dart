import 'package:mindly/feature/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:mindly/feature/quiz/domain/entities/question.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource dataSource;

  const QuizRepositoryImpl({required this.dataSource});

  @override
  Future<List<Question>> getQuestions({required String quizId}) {
    return dataSource.loadQuestions(quizId: quizId);
  }
}
