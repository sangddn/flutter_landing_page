import 'package:flutter/material.dart';

import '../../core/core.dart';

class Spinning extends StatefulWidget {
  const Spinning({
    this.interval = PEffects.longDuration,
    this.enabled = true,
    this.curve = Curves.linear,
    required this.child,
    super.key,
  });

  final Duration interval;
  final bool enabled;
  final Curve curve;
  final Widget child;

  @override
  State<Spinning> createState() => _SpinningState();
}

class _SpinningState extends State<Spinning>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: widget.interval,
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _animationController.repeat(
        min: 0.0,
        max: 1.0,
      );
    }
  }

  @override
  void didUpdateWidget(Spinning oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _animationController.repeat(
        min: 0.0,
        max: 1.0,
      );
    } else if (!widget.enabled) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) => Transform.rotate(
        angle: _animationController.value * 2 * 3.14159,
        child: widget.child,
      ),
    );
  }
}
