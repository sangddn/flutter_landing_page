import 'package:flutter/material.dart';

import '../components.dart';

class ScaffoldBodyMask extends StatelessWidget {
  const ScaffoldBodyMask({
    required this.unscaledHeight,
    required this.child,
    super.key,
  });

  final double unscaledHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        child,
        // Gradient background
        Positioned(
          right: 0.0,
          left: 0.0,
          bottom: 0.0,
          height: unscaledHeight.scaleWithText(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surfaceTint.withOpacity(0.0),
                  theme.colorScheme.surfaceTint.withOpacity(0.95),
                  theme.colorScheme.surfaceTint.withOpacity(0.98),
                  theme.colorScheme.surfaceTint,
                ],
                // stops: const [0.0, 0.8],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
