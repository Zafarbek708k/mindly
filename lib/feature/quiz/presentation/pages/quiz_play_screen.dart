import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindly/core/singletons/service_locator.dart';
import 'package:mindly/feature/common/animateed_button.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';
import 'package:mindly/feature/quiz/presentation/bloc/quiz_cubit.dart';
import 'package:mindly/feature/quiz/presentation/widgets/question_indicators.dart';
import 'package:mindly/route/app_router.dart';

class QuizPlayScreen extends StatelessWidget {
  const QuizPlayScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(
        repository: serviceLocator<QuizRepository>(),
        quizId: quizId,
      )..start(),
      child: const _QuizView(),
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    return BlocConsumer<QuizCubit, QuizState>(
      listenWhen: (prev, curr) => curr.status == QuizStatus.finished && prev.status != QuizStatus.finished,
      listener: (context, state) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.quizResult, arguments: state.result);
      },
      builder: (context, state) {
        final cubit = context.read<QuizCubit>();
        return Scaffold(
          backgroundColor: scheme.surface,
          appBar: AppBar(
            backgroundColor: scheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text('Math Quiz'),
            centerTitle: true,
            actions: [
              if (state.status == QuizStatus.inProgress)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _TimerChip(time: state.formattedTime, critical: state.isTimeCritical),
                ),
            ],
          ),
          body: switch (state.status) {
            QuizStatus.initial || QuizStatus.loading => const Center(child: CircularProgressIndicator()),
            QuizStatus.error =>
                _ErrorView(
                  message: state.errorMessage ?? 'Something went wrong',
                  onRetry: cubit.restart,
                ),
            _ => _QuestionBody(state: state, cubit: cubit),
          },
        );
      },
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.time, required this.critical});

  final String time;
  final bool critical;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    final color = critical ? scheme.error : scheme.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            time,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _QuestionBody extends StatelessWidget {
  const _QuestionBody({required this.state, required this.cubit});

  final QuizState state;
  final QuizCubit cubit;

  static const _letters = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    final question = state.currentQuestion!;
    final selected = state.currentAnswer;

    return Column(
      children: [
        const SizedBox(height: 8),
        QuestionIndicators(
          count: state.questions.length,
          currentIndex: state.currentIndex,
          isAnswered: state.isAnswered,
          onTap: cubit.goToQuestion,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              Text(
                'Question ${state.currentIndex + 1} of ${state.questions.length}',
                style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                question.text,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800, height: 1.25),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < question.options.length; i++) ...[
                _OptionTile(
                  letter: _letters[i],
                  text: question.options[i],
                  selected: selected == i,
                  onTap: () => cubit.selectOption(i),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        _BottomBar(state: state, cubit: cubit),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.letter, required this.text, required this.selected, required this.onTap});

  final String letter;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    final borderColor = selected ? scheme.primary : scheme.outlineVariant;
    return AnimatedButton(
      onTap: onTap,
      scaleValue: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? scheme.primary.withValues(alpha: 0.10) : scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                letter,
                style: TextStyle(
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.cubit});

  final QuizState state;
  final QuizCubit cubit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    final bottomPad = MediaQuery
        .paddingOf(context)
        .bottom;
    final hasAnswer = state.currentAnswer != null;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(color: scheme.shadow.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          if (state.currentIndex > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: cubit.previousQuestion,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: !hasAnswer
                  ? null
                  : state.isLastQuestion
                  ? cubit.finish
                  : cubit.nextQuestion,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(state.isLastQuestion ? 'Finish' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Theme
                .of(context)
                .colorScheme
                .error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
