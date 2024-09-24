import 'package:flutter/material.dart';

import '../components.dart';

class PositionedButton extends StatefulWidget {
  const PositionedButton({
    required this.tooltip,
    required this.onPressed,
    required this.child,
    super.key,
  });

  final String tooltip;
  final ValueChanged<Rect>? onPressed;
  final Widget child;

  @override
  State<PositionedButton> createState() => _PositionedButtonState();
}

class _PositionedButtonState extends State<PositionedButton> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: CButton(
        tooltip: widget.tooltip,
        onTap: widget.onPressed == null
            ? null
            : () {
                final renderBox =
                    _key.currentContext!.findRenderObject()! as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                final size = renderBox.size;
                widget.onPressed?.call(
                  Rect.fromLTWH(
                    position.dx,
                    position.dy,
                    size.width,
                    size.height,
                  ),
                );
              },
        child: widget.child,
      ),
    );
  }
}
