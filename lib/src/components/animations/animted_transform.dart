import 'package:flutter/material.dart';

class AnimatedTransform extends ImplicitlyAnimatedWidget {
  const AnimatedTransform({
    required this.transform,
    required this.child,
    super.curve,
    required super.duration,
    super.onEnd,
    super.key,
  });

  final Matrix4 transform;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedTransform> createState() =>
      _AnimatedTransformState();
}

class _AnimatedTransformState
    extends AnimatedWidgetBaseState<AnimatedTransform> {
  Matrix4Tween? _matrixTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _matrixTween = visitor(
      _matrixTween,
      widget.transform,
      (dynamic value) => Matrix4Tween(begin: value as Matrix4),
    ) as Matrix4Tween?;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: _matrixTween!.evaluate(animation),
      child: widget.child,
    );
  }
}
