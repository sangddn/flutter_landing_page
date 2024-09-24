import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../components.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    this.isSelected = false,
    this.leading,
    this.trailing,
    this.padding,
    this.subtitle,
    this.shape,
    this.isDestructive = false,
    this.leadingGap,
    this.trailingGap,
    required this.title,
    required this.onPressed,
    super.key,
  });

  final bool isSelected, isDestructive;
  final EdgeInsetsGeometry? padding;
  final double? leadingGap, trailingGap;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final ShapeBorder? shape;
  final Widget title;
  final VoidCallback? onPressed;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _isHovering = false, _isPressing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuButtonTheme = PMenuButtonTheme.of(context);
    final destructiveColor = CupertinoColors.systemRed.resolveFrom(context);

    final backgroundColor = _isPressing || _isHovering
        ? Colors.transparent
        : widget.isSelected
            ? menuButtonTheme.selectedBackgroundColor ?? theme.gray
            : menuButtonTheme.backgroundColor ?? Colors.transparent;

    final shape = widget.shape ?? menuButtonTheme.shape ?? PDecors.border12;

    final iconColor = widget.isSelected || _isHovering
        ? menuButtonTheme.selectedIconColor ??
            (widget.isDestructive
                ? destructiveColor
                : theme.colorScheme.onSurface)
        : menuButtonTheme.iconColor ??
            (widget.isDestructive ? destructiveColor : theme.textGray);

    final titleStyle = (widget.isSelected || _isHovering
            ? menuButtonTheme.selectedTextStyle ??
                (theme.textTheme.bodyMedium ?? const TextStyle())
                    .copyWith(
                      color: widget.isDestructive
                          ? destructiveColor
                          : theme.colorScheme.onSurface,
                    )
                    .modifyWeight(3)
            : menuButtonTheme.titleStyle ??
                (theme.textTheme.bodyMedium ?? const TextStyle())
                    .copyWith(
                      color: theme.textGray,
                    )
                    .modifyWeight(1))
        .copyWith(
      color: widget.isDestructive && _isHovering ? iconColor : null,
    );

    final subtitleStyle = widget.isSelected || _isHovering
        ? menuButtonTheme.selectedSubtitleStyle ??
            (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
              color: widget.isDestructive
                  ? destructiveColor
                  : theme.colorScheme.onSurface.withOpacity(0.8),
            )
        : menuButtonTheme.subtitleStyle ??
            (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
              color: widget.isDestructive ? destructiveColor : theme.darkGray,
            );

    final padding = widget.padding ?? menuButtonTheme.padding ?? k16H4VPadding;

    final iconTheme = TextStyle(
      color: widget.isDestructive ? destructiveColor : iconColor,
      fontSize: theme.textTheme.titleLarge?.fontSize?.subtract(3.0),
    );

    Widget wrapAnimTheme(Widget child) => AnimatedDefaultTextStyle(
          duration: PEffects.veryShortDuration,
          style: iconTheme,
          child: Builder(
            builder: (context) {
              final style = DefaultTextStyle.of(context).style;
              final iconColor = style.color!;
              final iconSize = style.fontSize!;
              return IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: iconSize,
                ),
                child: child,
              );
            },
          ),
        );

    return AnimatedContainer(
      duration: PEffects.veryShortDuration,
      curve: Easing.emphasizedDecelerate,
      decoration: ShapeDecoration(
        shape: shape,
        color: backgroundColor,
      ),
      child: AnimatedOpacity(
        duration: PEffects.veryShortDuration,
        opacity: widget.onPressed == null ? 0.5 : 1.0,
        child: BouncingObject(
          onTap: () {},
          onAnimation: (controller) {},
          child: Material(
            color: Colors.transparent,
            shape: shape,
            clipBehavior: Clip.antiAlias,
            child: InkResponse(
              onTap: widget.onPressed == null
                  ? null
                  : () {
                      widget.onPressed?.call();
                    },
              onHover: (isHovering) {
                setState(() => _isHovering = isHovering);
              },
              onTapDown: (_) => setState(() => _isPressing = true),
              onTapCancel: () => setState(() => _isPressing = false),
              onTapUp: (_) {
                setState(() => _isPressing = false);
                scheduleMicrotask(
                  context.read<ActiveContextMenu?>()?.hide ?? () {},
                );
              },
              highlightShape: BoxShape.rectangle,
              // highlightColor: Colors.transparent,
              // focusColor: Colors.transparent,
              // hoverColor: Colors.transparent,
              // splashColor: Colors.transparent,
              // overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    if (widget.leading case final leading?)
                      wrapAnimTheme(leading),
                    Gap(
                      widget.leadingGap ??
                          menuButtonTheme.leadingGap ??
                          min(4.0, padding.horizontal / 2 - 2.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: PEffects.veryShortDuration,
                            style: titleStyle,
                            child: widget.title,
                          ),
                          if (widget.subtitle case final subtitle?)
                            AnimatedDefaultTextStyle(
                              duration: PEffects.veryShortDuration,
                              style: subtitleStyle,
                              child: subtitle,
                            ),
                        ],
                      ),
                    ),
                    if (widget.trailing case final trailing?) ...[
                      Gap(
                        widget.trailingGap ??
                            min(4.0, padding.horizontal / 2 - 4.0),
                      ),
                      wrapAnimTheme(trailing),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PMenuButtonTheme extends InheritedWidget {
  const PMenuButtonTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final PMenuButtonThemeData data;

  static PMenuButtonThemeData of(BuildContext context) {
    final PMenuButtonTheme? menuButtonTheme =
        context.dependOnInheritedWidgetOfExactType<PMenuButtonTheme>();
    return menuButtonTheme?.data ?? const PMenuButtonThemeData();
  }

  @override
  bool updateShouldNotify(PMenuButtonTheme oldWidget) {
    return data != oldWidget.data;
  }
}

@immutable
class PMenuButtonThemeData {
  const PMenuButtonThemeData({
    this.leadingGap,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.iconColor,
    this.iconSize,
    this.selectedBackgroundColor,
    this.selectedTextStyle,
    this.selectedSubtitleStyle,
    this.selectedIconColor,
    this.shape,
    this.padding,
  });

  final Color? backgroundColor,
      selectedBackgroundColor,
      iconColor,
      selectedIconColor;
  final TextStyle? titleStyle,
      subtitleStyle,
      selectedTextStyle,
      selectedSubtitleStyle;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;
  final double? leadingGap, iconSize;

  PMenuButtonThemeData copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? iconColor,
    double? iconSize,
    Color? selectedBackgroundColor,
    Color? selectedIconColor,
    TextStyle? selectedTextStyle,
    TextStyle? selectedSubtitleStyle,
    ShapeBorder? shape,
    EdgeInsetsGeometry? padding,
    double? leadingGap,
  }) {
    return PMenuButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedSubtitleStyle:
          selectedSubtitleStyle ?? this.selectedSubtitleStyle,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
      leadingGap: leadingGap ?? this.leadingGap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PMenuButtonThemeData &&
        other.backgroundColor == backgroundColor &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.selectedTextStyle == selectedTextStyle &&
        other.selectedSubtitleStyle == selectedSubtitleStyle &&
        other.selectedIconColor == selectedIconColor &&
        other.shape == shape &&
        other.padding == padding &&
        other.leadingGap == leadingGap;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      titleStyle,
      subtitleStyle,
      iconColor,
      iconSize,
      selectedBackgroundColor,
      selectedTextStyle,
      selectedSubtitleStyle,
      selectedIconColor,
      shape,
      padding,
      leadingGap,
    );
  }
}
