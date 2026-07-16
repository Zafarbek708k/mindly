import 'package:mindly/core/exceptions/failures.dart';
import 'package:mindly/core/utils/either.dart';
import 'package:mindly/feature/quiz/domain/entities/question.dart';

/// Where the questions come from.
enum QuizSource {
  /// Bundled mock JSON (assets/data/questions.json).
  local,

  /// Real HTTP call to the mock API (Endpoints.mockApi).
  remote,
}

/// Question source. The app only depends on this interface — swapping the
/// implementation (local mock ↔ real API) touches nothing above it.
abstract class QuizRepository {
  Future<Either<Failure, List<Question>>> getQuestions({required String quizId, QuizSource source = QuizSource.local});
}
