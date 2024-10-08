import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../components.dart';

class CButton extends StatelessWidget {
  const CButton({
    this.padding = EdgeInsets.zero,
    this.color,
    this.side = BorderSide.none,
    this.cornerRadius = 8.0,
    this.clipBehavior = Clip.antiAlias,
    this.pressedOpacity = 0.4,
    this.tooltipTriggerMode = TooltipTriggerMode.longPress,
    this.focusNode,
    this.addFeedback = false,
    this.tooltipPreferBottom = true,
    this.tooltipWaitDuration = const Duration(milliseconds: 500),
    required this.tooltip,
    required this.onTap,
    required this.child,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final BorderSide side;
  final double cornerRadius;
  final double pressedOpacity;
  final Color? color;
  final TooltipTriggerMode tooltipTriggerMode;
  final FocusNode? focusNode;
  final bool addFeedback;
  final bool tooltipPreferBottom;
  final Duration tooltipWaitDuration;
  final String? tooltip;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final Widget child;

  void _callback() {
    return onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<FocusNode>(
      create: (_) => focusNode ?? FocusNode(),
      builder: (context, child) {
        final hasFocus = context.watch<FocusNode>().hasFocus;
        final extraPadding = hasFocus ? 1.5 : 0.0;
        return AnimatedContainer(
          duration: PEffects.shortDuration,
          curve: Curves.ease,
          decoration: ShapeDecoration(
            shape: PContinuousRectangleBorder(
              side: side.copyWith(
                color: color ?? Theme.of(context).dividerColor,
                width: side.width * 2.0,
              ),
              cornerRadius: cornerRadius + extraPadding,
            ),
          ),
          padding: EdgeInsets.all(extraPadding),
          clipBehavior: clipBehavior,
          child: CupertinoButton(
            color: color,
            focusNode: context.select((FocusNode fn) => fn),
            focusColor: Theme.of(context).highlightColor,
            padding: padding,
            minSize: 0.0,
            pressedOpacity: pressedOpacity,
            borderRadius: BorderRadius.circular(0.0),
            onPressed: onTap == null
                ? null
                : addFeedback
                    ? () {
                        Feedback.wrapForTap(_callback, context)?.call();
                      }
                    : _callback,
            child: PTooltip(
              message: tooltip,
              preferBelow: tooltipPreferBottom,
              showDuration: tooltipWaitDuration,
              triggerMode: tooltipTriggerMode,
              child: child!,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
