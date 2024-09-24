import 'package:flutter/material.dart';

import '../../core/core.dart';

class AdaptiveSelectionArea extends StatelessWidget {
  const AdaptiveSelectionArea({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Target.isNativeMobile) {
      return child;
    } else {
      return SelectionArea(
        child: child,
      );
    }
  }
}
