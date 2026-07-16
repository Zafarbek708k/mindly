import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:mindly/core/exceptions/failures.dart';
import 'package:mindly/core/usecases/usecase.dart';
import 'package:mindly/core/utils/either.dart';
import 'package:mindly/feature/quiz/domain/entities/question.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';

class LoadQuizUseCase implements UseCase<List<Question>, LoadQuizParams> {
  final QuizRepository repository;

  const LoadQuizUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Question>>> call(LoadQuizParams params) {
    log("LoadQuizUseCase called with quizId: ${params.quizId}, source: ${params.source}");
    return repository.getQuestions(quizId: params.quizId, source: params.source);
  }
}

class LoadQuizParams extends Equatable {
  final String quizId;
  final QuizSource source;

  const LoadQuizParams({required this.quizId, this.source = QuizSource.local});

  @override
  List<Object?> get props => [quizId, source];
}
