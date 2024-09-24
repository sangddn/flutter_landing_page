import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';
import '../components.dart';

class JumpingCard extends StatefulWidget {
  const JumpingCard({
    required this.onTap,
    this.jumpScale = -0.2,
    required this.child,
    super.key,
  });

  final double jumpScale;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<JumpingCard> createState() => _JumpingCardState();
}

class _JumpingCardState extends State<JumpingCard> {
  @override
  Widget build(BuildContext context) {
    return DisambiguatedHoverTapBuilder(
      onTap: widget.onTap,
      builder: (context, isHovering, isPressing) => widget.child
          .animate(
            target: isHovering && !isPressing ? 1.0 : 0.0,
          )
          .slideY(
            duration: PEffects.veryShortDuration,
            curve: Curves.easeInOut,
            begin: 0.0,
            end: widget.jumpScale,
          ),
    );
  }
}
