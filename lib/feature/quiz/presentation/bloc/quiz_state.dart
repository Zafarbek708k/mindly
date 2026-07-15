part of 'quiz_cubit.dart';

enum QuizStatus { initial, loading, error, inProgress, finished }

class QuizState extends Equatable {
  final QuizStatus status;
  final List<Question> questions;

  final Map<int, int> answers;
  final int currentIndex;

  final int remainingSeconds;
  final QuizResult? result;
  final String? errorMessage;

  const QuizState({
    this.status = QuizStatus.initial,
    this.questions = const [],
    this.answers = const {},
    this.currentIndex = 0,
    this.remainingSeconds = QuizCubit.totalSeconds,
    this.result,
    this.errorMessage,
  });

  Question? get currentQuestion => questions.isEmpty ? null : questions[currentIndex.clamp(0, questions.length - 1)];

  int? get currentAnswer => answers[currentIndex];

  bool get isLastQuestion => currentIndex == questions.length - 1;

  bool isAnswered(int index) => answers.containsKey(index);

  bool get allAnswered => answers.length == questions.length && questions.isNotEmpty;

  String get formattedTime {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get isTimeCritical => remainingSeconds <= 60;

  QuizState copyWith({
    QuizStatus? status,
    List<Question>? questions,
    Map<int, int>? answers,
    int? currentIndex,
    int? remainingSeconds,
    QuizResult? result,
    String? errorMessage,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, questions, answers, currentIndex, remainingSeconds, result, errorMessage];
}
