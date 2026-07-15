import 'package:flutter/material.dart';
import 'package:mindly/core/const/static_values.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scaleValue;
  final bool isDisabled;
  final HitTestBehavior behavior;

  const AnimatedButton({
    required this.child,
    required this.onTap,
    super.key,
    this.isDisabled = false,
    this.duration = AppDurations.short,
    this.scaleValue = 0.96,
    this.behavior = HitTestBehavior.opaque,
  }) : assert(scaleValue <= 1 && scaleValue >= 0, 'scaleValue must be in [0, 1]');

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(
      begin: 1,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down() {
    if (!widget.isDisabled) _controller.forward();
  }

  void _up() {
    if (!widget.isDisabled) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.isDisabled ? null : widget.onTap,
      onPanDown: (_) => _down(),
      onPanCancel: _up,
      onPanEnd: (_) => _up(),
      child: AnimatedOpacity(
        duration: AppDurations.short,
        opacity: widget.isDisabled ? 0.5 : 1,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
