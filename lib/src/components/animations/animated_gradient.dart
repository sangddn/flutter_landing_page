import 'package:flutter/material.dart';

import '../../core/core.dart';

class AnimatedTwoStateGradientMask extends StatefulWidget {
  const AnimatedTwoStateGradientMask({
    this.duration = PEffects.veryShortDuration,
    this.curve = Curves.easeInOut,
    this.color,
    required this.shouldMask,
    super.key,
  });

  final Duration duration;
  final Curve curve;
  final Color? color;
  final bool shouldMask;

  @override
  State<AnimatedTwoStateGradientMask> createState() =>
      _AnimatedTwoStateGradientMaskState();
}

class _AnimatedTwoStateGradientMaskState
    extends State<AnimatedTwoStateGradientMask>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: PEffects.veryShortDuration,
    vsync: this,
  );
  late final _animation = Tween<double>(begin: 0.0, end: 0.3)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

  @override
  void didUpdateWidget(covariant AnimatedTwoStateGradientMask oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldMask != oldWidget.shouldMask) {
      if (widget.shouldMask) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.color ?? theme.scaffoldBackgroundColor;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  effectiveColor,
                  effectiveColor.withOpacity(0.5),
                  effectiveColor.withOpacity(0.0),
                ],
                stops: [
                  _animation.value,
                  (_animation.value * 2.5).clamp(0.5, 0.9),
                  1.0,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ColoredBox(color: effectiveColor),
          );
        },
      ),
    );
  }
}
