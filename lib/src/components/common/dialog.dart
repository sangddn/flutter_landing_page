import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components.dart';

Future<T?> showRAlert<T>({
  required BuildContext context,
  Widget? icon,
  EdgeInsetsGeometry? iconPadding,
  Color? iconColor,
  Widget? title,
  EdgeInsetsGeometry? titlePadding,
  TextStyle? titleTextStyle,
  Widget? content,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? contentTextStyle,
  List<AdaptiveDialogAction>? actions,
  EdgeInsetsGeometry? actionsPadding,
  MainAxisAlignment? actionsAlignment,
  OverflowBarAlignment? actionsOverflowAlignment,
  VerticalDirection? actionsOverflowDirection,
  double? actionsOverflowButtonSpacing,
  EdgeInsetsGeometry? buttonPadding,
  Color? backgroundColor,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor,
  String? semanticLabel,
  EdgeInsets insetPadding =
      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  Clip clipBehavior = Clip.none,
  ShapeBorder? shape,
  AlignmentGeometry? alignment,
  bool scrollable = false,
  ScrollController? scrollController,
  ScrollController? actionScrollController,
  Duration insetAnimationDuration = const Duration(milliseconds: 100),
  Curve insetAnimationCurve = Easing.standardDecelerate,
  bool? barrierDismissible,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,

  /// Only works on macOS.
  bool horizontalActions = true,
}) async {
  assert(actions == null || actions.length <= 2);
  assert(actions == null || actions.isEmpty || actions.first.isDefault);
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        icon: icon,
        iconColor: iconColor,
        iconPadding: iconPadding,
        title: title,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        content: content,
        contentPadding: contentPadding,
        contentTextStyle: contentTextStyle,
        actions: actions,
        actionsPadding: actionsPadding,
        actionsAlignment: actionsAlignment,
        actionsOverflowAlignment: actionsOverflowAlignment,
        actionsOverflowDirection: actionsOverflowDirection,
        actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
        buttonPadding: buttonPadding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        semanticLabel: semanticLabel,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        shape: shape,
        alignment: alignment,
        scrollable: scrollable,
        scrollController: scrollController,
        actionScrollController: actionScrollController,
        insetAnimationDuration: insetAnimationDuration,
        insetAnimationCurve: insetAnimationCurve,
      );
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    traversalEdgeBehavior: traversalEdgeBehavior,
  );
}

class AdaptiveDialogAction extends StatelessWidget {
  const AdaptiveDialogAction({
    super.key,
    required this.tooltip,
    this.isDefault = false,
    this.isDestructive = false,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final bool isDefault;
  final bool isDestructive;
  final void Function(BuildContext context)? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return CButton(
          tooltip: tooltip,
          onTap: onPressed == null ? null : () => onPressed?.call(context),
          child: DefaultTextStyle(
            style: TextStyle(
              color: isDestructive ? theme.colorScheme.error : null,
              fontWeight: isDefault ? FontWeight.w600 : null,
            ),
            child: child,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(
          isDefaultAction: isDefault,
          isDestructiveAction: isDestructive,
          onPressed: onPressed == null ? null : () => onPressed?.call(context),
          child: child,
        );
    }
  }
}
