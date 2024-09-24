import 'package:flutter/material.dart';

import '../../core/core.dart';

class Pulsating extends StatefulWidget {
  const Pulsating({
    this.interval = PEffects.longDuration,
    this.enabled = true,
    this.curve = Curves.linear,
    this.low = 0.6,
    this.high = 1.1,
    this.reverse = false,
    required this.child,
    super.key,
  }) : assert(low < high);

  final Duration interval;
  final bool enabled;
  final Curve curve;
  final double low, high;
  final bool reverse;
  final Widget child;

  @override
  State<Pulsating> createState() => _PulsatingState();
}

class _PulsatingState extends State<Pulsating>
    with SingleTickerProviderStateMixin {
  late final _naturalValue = (1.0 - widget.low) / (widget.high - widget.low);
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
        reverse: widget.reverse,
      );
    } else {
      // a value that sets the size to 1.0
      _animationController.value = _naturalValue;
    }
  }

  @override
  void didUpdateWidget(Pulsating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _animationController.repeat(
        min: 0.0,
        max: 1.0,
        reverse: true,
      );
    } else if (!widget.enabled) {
      _animationController.animateTo(_naturalValue);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform.scale(
          scale: widget.low +
              (widget.high - widget.low) * _animationController.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
