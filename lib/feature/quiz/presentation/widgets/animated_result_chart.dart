import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedResultChart extends StatefulWidget {
  const AnimatedResultChart({
    super.key,
    required this.ratio,
    required this.color,
    this.size = 190,
    this.duration = const Duration(milliseconds: 1000),
  });

  final double ratio;
  final Color color;
  final double size;
  final Duration duration;

  @override
  State<AnimatedResultChart> createState() => _AnimatedResultChartState();
}

class _AnimatedResultChartState extends State<AnimatedResultChart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fill;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fill = Tween<double>(
      begin: 0,
      end: widget.ratio.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _fill,
      builder: (context, _) {
        final percent = (_fill.value * 100).round();
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: _fill.value,
              color: widget.color,
              trackColor: scheme.surfaceContainerHighest,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: widget.color),
                  ),
                  Text(
                    'correct',
                    style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.color, required this.trackColor});

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 16.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      final arc = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.trackColor != trackColor;
}
