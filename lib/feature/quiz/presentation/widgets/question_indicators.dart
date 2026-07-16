import 'package:flutter/material.dart';

class QuestionIndicators extends StatelessWidget {
  const QuestionIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.isAnswered,
    required this.onTap,
  });

  final int count;
  final int currentIndex;
  final bool Function(int index) isAnswered;
  final ValueChanged<int> onTap;

  static const _answeredColor = Color(0xFF22A45D);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final answered = isAnswered(i);
          final current = i == currentIndex;

          final Color background;
          final Color foreground;
          Color border = Colors.transparent;
          if (current) {
            background = scheme.primary;
            foreground = scheme.onPrimary;
            if (answered) border = _answeredColor;
          } else if (answered) {
            background = _answeredColor;
            foreground = Colors.white;
          } else {
            background = scheme.surfaceContainerHighest;
            foreground = scheme.onSurfaceVariant;
          }

          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 2),
              ),
              child: Text(
                '${i + 1}',
                style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
              ),
            ),
          );
        },
      ),
    );
  }
}
