import 'dart:developer';

import 'package:mindly/core/api/links.dart';
import 'package:mindly/core/singletons/request_handler_service.dart';
import 'package:mindly/feature/quiz/data/models/question_model.dart';

/// Loads questions from the real mock API ([Endpoints.mockApi]).
///
/// The endpoint returns a JSON **array** of quiz objects
/// (see `mockApiMindlyResponse` in links.dart for the shape); we pick the one
/// matching [quizId] (or the first as a fallback) and parse its `questions`.
abstract class QuizRemoteDataSource {
  Future<List<QuestionModel>> loadQuestions({required String quizId});
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final RequestHandlerService service;

  const QuizRemoteDataSourceImpl({required this.service});

  @override
  Future<List<QuestionModel>> loadQuestions({required String quizId}) {
    log("QuizRemoteDataSourceImpl.loadQuestions called with quizId: $quizId");
    return service.handleRequest(
      path: Endpoints.mockApi,
      method: RequestMethod.get,
      fromJson: (res) {
        log("QuizRemoteDataSourceImpl.loadQuestions received response: ${res.statusCode} ${res.data}");

        final body = res.data;
        final quizzes = switch (body) {
          List l => l.whereType<Map<String, dynamic>>().toList(),
          Map<String, dynamic> m => [m],
          _ => const <Map<String, dynamic>>[],
        };
        if (quizzes.isEmpty) return const <QuestionModel>[];

        final quiz = quizzes.firstWhere(
          (q) => (q['quiz_id'] ?? q['id'])?.toString() == quizId,
          orElse: () => quizzes.first,
        );
        return (quiz['questions'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(QuestionModel.fromJson)
            .toList(growable: false);
      },
    );
  }
}
