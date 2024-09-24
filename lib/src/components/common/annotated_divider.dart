import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class AnnotatedDivider extends StatelessWidget {
  const AnnotatedDivider({
    this.text,
    this.textStyle,
    this.trailingChild,
    this.widget,
    this.thickness,
    this.dividerColor,
    this.textColor,
    this.leftDividerIsVisible = true,
    this.rightDividerIsVisible = true,
    super.key,
  });

  final String? text;
  final Widget? trailingChild;
  final Widget? widget;
  final double? thickness;
  final Color? dividerColor;
  final Color? textColor;
  final bool leftDividerIsVisible;
  final bool rightDividerIsVisible;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    assert(
      ((text != null) ? 1 : 0) + ((widget != null) ? 1 : 0) == 1,
      'AnnotatedDivider must have either text or widget',
    );
    assert(
      leftDividerIsVisible || rightDividerIsVisible,
      'AnnotatedDivider must have at least one divider',
    );

    final theme = Theme.of(context);

    final dividerColor = this.dividerColor ??
        theme.resolveColor(
          PColors.offDark,
          PColors.bhOffWhite,
        );

    return DefaultTextStyle(
      style: textStyle ??
          (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
            color: textColor ?? dividerColor,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leftDividerIsVisible)
            Expanded(
              child: Divider(
                thickness: thickness ?? 0.5,
                color: dividerColor,
              ),
            ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                text!,
                style: textStyle,
              ),
            ),
          if (widget != null) widget!,
          if (rightDividerIsVisible)
            Expanded(
              child: Divider(
                thickness: thickness ?? 0.5,
                color: dividerColor,
              ),
            ),
          if (trailingChild != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: trailingChild,
            ),
        ],
      ),
    );
  }
}

class GradientDivider extends StatelessWidget {
  const GradientDivider({
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.annotation,
    super.key,
  });

  final double indent, endIndent;
  final Widget? annotation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final leftDivider = Container(
      height: 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            theme.lightGray,
            theme.darkGray,
            theme.lightGray,
          ],
          stops: const [0.0, 0.1, 0.5, 1.0],
        ),
      ),
    );

    return Row(
      children: [
        Gap(indent),
        leftDivider.expand(),
        if (annotation case final annotation?) ...[
          const Gap(16.0),
          DefaultTextStyle(
            style: theme.textTheme.bodySmall ?? const TextStyle(),
            child: annotation,
          ),
          const Gap(16.0),
          RotatedBox(
            quarterTurns: 2,
            child: leftDivider,
          ).expand(),
        ],
        Gap(endIndent),
      ],
    );
  }
}
