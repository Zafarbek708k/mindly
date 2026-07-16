import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindly/feature/quiz/domain/entities/question.dart';
import 'package:mindly/feature/quiz/domain/entities/quiz_result.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';
import 'package:mindly/feature/quiz/domain/usecases/load_quiz_usecase.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  static const int totalSeconds = 20 * 60;

  final LoadQuizUseCase loadQuiz;
  final String quizId;
  final QuizSource source;

  Timer? _ticker;

  QuizCubit({required this.loadQuiz, required this.quizId, this.source = QuizSource.local})
      : super(const QuizState());

  Future<void> start() async {
    if (state.status == QuizStatus.loading) return;
    _ticker?.cancel();
    emit(const QuizState(status: QuizStatus.loading));

    final result = await loadQuiz(LoadQuizParams(quizId: quizId, source: source));
    if (isClosed) return;

    result.either(
          (failure) => emit(state.copyWith(status: QuizStatus.error, errorMessage: failure.message)),
          (questions) {
        if (questions.isEmpty) {
          emit(state.copyWith(status: QuizStatus.error, errorMessage: 'No questions found'));
          return;
        }
        emit(QuizState(status: QuizStatus.inProgress, questions: questions));
        _startTicker();
      },
    );
  }

  Future<void> restart() => start();

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = state.remainingSeconds - 1;
      if (left <= 0) {
        emit(state.copyWith(remainingSeconds: 0));
        finish();
        return;
      }
      emit(state.copyWith(remainingSeconds: left));
    });
  }

  void selectOption(int optionIndex) {
    if (state.status != QuizStatus.inProgress) return;
    final answers = Map<int, int>.from(state.answers)
      ..[state.currentIndex] = optionIndex;
    emit(state.copyWith(answers: answers));
  }

  void goToQuestion(int index) {
    if (state.status != QuizStatus.inProgress) return;
    if (index < 0 || index >= state.questions.length) return;
    emit(state.copyWith(currentIndex: index));
  }

  void nextQuestion() => goToQuestion(state.currentIndex + 1);

  void previousQuestion() => goToQuestion(state.currentIndex - 1);

  void finish() {
    if (state.status != QuizStatus.inProgress) return;
    _ticker?.cancel();

    var correct = 0;
    state.answers.forEach((questionIndex, optionIndex) {
      if (state.questions[questionIndex].isCorrect(optionIndex)) correct++;
    });

    final result = QuizResult(
      totalQuestions: state.questions.length,
      correctAnswers: correct,
      timeSpent: Duration(seconds: totalSeconds - state.remainingSeconds),
    );

    emit(state.copyWith(status: QuizStatus.finished, result: result));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
