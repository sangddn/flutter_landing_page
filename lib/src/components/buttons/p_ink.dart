import 'package:flutter/material.dart';

import '../components.dart';

class PInk extends StatelessWidget {
  const PInk({
    this.focusNode,
    this.cornerRadius = 12.0,
    this.side = BorderSide.none,
    this.padding = EdgeInsets.zero,
    required this.onTap,
    required this.enabled,
    required this.child,
    super.key,
  });

  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final double cornerRadius;
  final EdgeInsetsGeometry padding;
  final BorderSide side;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: PContinuousRectangleBorder(
        cornerRadius: cornerRadius,
        side: side,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkResponse(
        focusNode: focusNode,
        onTap: enabled
            ? () {
                onTap?.call();
              }
            : null,
        highlightShape: BoxShape.rectangle,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
