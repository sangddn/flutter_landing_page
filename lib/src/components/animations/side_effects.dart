import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension SideEffects on Widget {
  Widget onMouseHover({
    ValueChanged<PointerEnterEvent>? onHoverEnter,
    ValueChanged<PointerExitEvent>? onHoverExit,
  }) =>
      MouseRegion(
        onEnter: onHoverEnter,
        onExit: onHoverExit,
        child: this,
      );

  Widget onHoverOrTap({
    ValueChanged<bool>? onHoverOrTap,
  }) =>
      MouseRegion(
        onEnter: (_) => onHoverOrTap?.call(true),
        onExit: (_) => onHoverOrTap?.call(false),
        child: GestureDetector(
          onTap: () => onHoverOrTap?.call(true),
          child: this,
        ),
      );

  Widget on({
    ValueChanged<PointerEnterEvent>? onHoverEnter,
    ValueChanged<PointerExitEvent>? onHoverExit,
    ValueChanged<bool>? onHoverOrTap,
    ValueChanged<TapDownDetails>? onTapDown,
    ValueChanged<TapUpDetails>? onTapUp,
    VoidCallback? onTapCancel,
    VoidCallback? onTap,
  }) =>
      GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onTap: onTap,
        child: MouseRegion(
          onEnter: onHoverEnter,
          onExit: onHoverExit,
          child: this,
        ),
      );
}
