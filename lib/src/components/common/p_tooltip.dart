import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class PTooltip extends StatelessWidget {
  const PTooltip({
    required this.child,
    this.onTriggered,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.message,
    this.richMessage,
    this.preferBelow,
    this.toolTipKey,
    this.showDuration,
    super.key,
  }) : assert(
          !(message != null && richMessage != null),
          'Only one of message or richMessage can be provided',
        );

  final TooltipTriggerMode triggerMode;
  final VoidCallback? onTriggered;
  final String? message;
  final InlineSpan? richMessage;
  final bool? preferBelow;
  final GlobalKey<TooltipState>? toolTipKey;
  final Duration? showDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (message == null && richMessage == null) {
      return child;
    }

    final theme = Theme.of(context);

    return Tooltip(
      key: toolTipKey,
      onTriggered: onTriggered,
      message: message,
      richMessage: richMessage,
      waitDuration: const Duration(milliseconds: 300),
      showDuration: showDuration,
      triggerMode: triggerMode,
      preferBelow: preferBelow,
      decoration: ShapeDecoration(
        color: theme.colorScheme.onSurface,
        shape: const PContinuousRectangleBorder(
          cornerRadius: 8.0,
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: Target.select(
        android: null,
        ios: null,
        macos: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 6.0,
        ),
        web: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 6.0,
        ),
      ),
      textStyle: richMessage != null
          ? null
          : theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.surface,
            ),
      child: child,
    );
  }
}
