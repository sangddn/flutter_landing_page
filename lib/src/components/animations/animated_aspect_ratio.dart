import 'package:flutter/material.dart';

class AnimatedAspectRatio extends ImplicitlyAnimatedWidget {
  const AnimatedAspectRatio({
    required this.aspectRatio,
    required this.child,
    super.curve,
    required super.duration,
    super.onEnd,
    super.key,
  });

  final double aspectRatio;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedAspectRatio> createState() =>
      _AnimatedAspectRatioState();
}

class _AnimatedAspectRatioState
    extends AnimatedWidgetBaseState<AnimatedAspectRatio> {
  Tween<double>? _aspectRatio;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _aspectRatio = visitor(
      _aspectRatio,
      widget.aspectRatio,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio!.evaluate(animation),
      child: widget.child,
    );
  }
}
