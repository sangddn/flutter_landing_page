import 'package:flutter/material.dart';

import '../../core/core.dart';

class Circle extends StatelessWidget {
  const Circle({
    this.size = 2.0,
    this.color,
    super.key,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? PColors.darkGray.resolveFrom(context),
        shape: BoxShape.circle,
      ),
    );
  }
}
