
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

class Confetti extends StatefulWidget {
  const Confetti({
    this.duration = PEffects.veryLongDuration,
    required this.builder,
    super.key,
  });

  /// The duration for which the confetti will show after being triggered.
  ///
  final Duration duration;

  /// The builder for the widget that will trigger the confetti.
  ///
  /// The `showConfetti` callback should be called to trigger the confetti.
  ///
  final Widget Function(BuildContext context, VoidCallback showConfetti)
      builder;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  late final _confettiController = ConfettiController(
    duration: widget.duration,
  );

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: _confettiController,
      blastDirection: 1.57,
      minimumSize: const Size(10, 10),
      maximumSize: const Size(20, 20),
      blastDirectionality: BlastDirectionality.explosive,
      child: widget.builder(context, _playConfetti),
    );
  }
}
