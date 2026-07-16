import 'dart:developer';

import 'package:mindly/core/exceptions/failures.dart';
import 'package:mindly/core/singletons/request_handler_service.dart';
import 'package:mindly/core/utils/either.dart';
import 'package:mindly/feature/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:mindly/feature/quiz/data/datasources/quiz_remote_datasource.dart';
import 'package:mindly/feature/quiz/domain/entities/question.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource localDataSource;
  final QuizRemoteDataSource remoteDataSource;
  final RequestHandlerService service;

  const QuizRepositoryImpl({required this.localDataSource, required this.remoteDataSource, required this.service});

  @override
  Future<Either<Failure, List<Question>>> getQuestions({required String quizId, QuizSource source = QuizSource.local}) {
    log("QuizRepositoryImpl.getQuestions called with quizId: $quizId, source: $source");

    return service.handleRequestInRepository(
      onRequest: () => switch (source) {
        QuizSource.local => localDataSource.loadQuestions(quizId: quizId),
        QuizSource.remote => remoteDataSource.loadQuestions(quizId: quizId),
      },
      debugLabel: 'QuizRepo.getQuestions($source)',
    );
  }
}
