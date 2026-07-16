import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:mindly/feature/quiz/domain/entities/quiz_result.dart';
import 'package:mindly/feature/quiz/presentation/quiz_args.dart';
import 'package:mindly/feature/quiz/presentation/widgets/animated_result_chart.dart';
import 'package:mindly/route/app_router.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key, required this.result, required this.playArgs});

  final QuizResult result;
  final QuizPlayArgs playArgs;

  static const double lowThreshold = 0.40;
  static const double highThreshold = 0.70;
  static const double confettiThreshold = 0.75;

  static const Color lowColor = Color(0xFFE5484D);
  static const Color mediumColor = Color(0xFFF08C00);
  static const Color highColor = Color(0xFF22A45D);

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late final ConfettiController _confettiController;

  QuizResult get result => widget.result;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (result.ratio >= QuizResultScreen.confettiThreshold) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    if (result.ratio < QuizResultScreen.lowThreshold) return QuizResultScreen.lowColor;
    if (result.ratio < QuizResultScreen.highThreshold) return QuizResultScreen.mediumColor;
    return QuizResultScreen.highColor;
  }

  String get _formattedTimeSpent {
    final m = result.timeSpent.inMinutes;
    final s = result.timeSpent.inSeconds % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  void _retry(BuildContext context) {
    // Same quiz, same source (local JSON or live API), fully fresh state.
    Navigator.of(context).pushReplacementNamed(AppRoutes.quizPlay, arguments: widget.playArgs);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        automaticallyImplyLeading: false,
        title: const Text('Result'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBody(context, scheme, bottomPad),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              // downwards
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 24,
              maxBlastForce: 24,
              minBlastForce: 8,
              gravity: 0.25,
              shouldLoop: false,
              colors: const [
                QuizResultScreen.highColor,
                QuizResultScreen.mediumColor,
                Color(0xFF4BA9EF),
                Color(0xFF9B59B6),
                Color(0xFFF6C445),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ColorScheme scheme, double bottomPad) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPad + 24),
      children: [
        Center(
          child: AnimatedResultChart(ratio: result.ratio, color: _scoreColor),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                icon: Icons.check_circle_rounded,
                color: QuizResultScreen.highColor,
                value: '${result.correctAnswers}',
                label: 'Correct',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatBlock(
                icon: Icons.cancel_rounded,
                color: QuizResultScreen.lowColor,
                value: '${result.wrongAnswers}',
                label: 'Wrong',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                icon: Icons.list_alt_rounded,
                color: scheme.primary,
                value: '${result.totalQuestions}',
                label: 'Questions',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatBlock(
                icon: Icons.timer_outlined,
                color: QuizResultScreen.mediumColor,
                value: _formattedTimeSpent,
                label: 'Time spent',
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => _retry(context),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Retry'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _exit(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.icon, required this.color, required this.value, required this.label});

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          Text(label, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
