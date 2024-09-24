import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';

class TileButton extends StatefulWidget {
  const TileButton({
    this.additionalInfo,
    this.subtitleWhenEnabled,
    this.disabledText,
    this.trailing = const CupertinoListTileChevron(),
    this.enableBlurredBackground = false,
    this.leading,
    this.decoration,
    this.padding = k16H8VPadding,
    this.idleBackgroundColor,
    this.highlightColor,
    required this.title,
    required this.onTap,
    super.key,
  }) : assert(decoration is ShapeDecoration? || decoration is BoxDecoration?);

  final EdgeInsets padding;
  final Widget? subtitleWhenEnabled;
  final String? disabledText;
  final Widget? additionalInfo;
  final Widget? trailing;
  final bool enableBlurredBackground;
  final Widget title;
  final Widget? leading;
  final Decoration? decoration;
  final Color? idleBackgroundColor, highlightColor;
  final VoidCallback? onTap;

  @override
  State<TileButton> createState() => _TileButtonState();
}

class _TileButtonState extends State<TileButton> {
  bool _isHovering = false;
  bool _isFocusing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onTap == null;
    final disabledColor = theme.colorScheme.onSurface.withOpacity(0.5);

    final effectiveDecoration = widget.decoration ??
        PDecors.stdCard(
          context,
          elevation: 0.05,
          increaseElevationIntensity: true,
          opacity: widget.enableBlurredBackground ? 0.0 : 1.0,
        );

    final shape = switch (effectiveDecoration) {
      ShapeDecoration() => effectiveDecoration.shape,
      BoxDecoration() => switch (effectiveDecoration.shape) {
          BoxShape.circle => const CircleBorder(),
          BoxShape.rectangle => RoundedRectangleBorder(
              borderRadius:
                  effectiveDecoration.borderRadius ?? BorderRadius.zero,
            )
        },
      _ => null,
    };

    return Material(
      color: Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        cursor: isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Focus(
          onFocusChange: (value) => setState(() => _isFocusing = value),
          onKeyEvent: (_, event) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              widget.onTap?.call();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: AnimatedDefaultTextStyle(
            duration: PEffects.shortDuration,
            curve: Easing.emphasizedDecelerate,
            style: TextStyle(
              color: isDisabled ? disabledColor : theme.colorScheme.onSurface,
            ),
            child: Builder(
              builder: (context) {
                final foregroundColor =
                    DefaultTextStyle.of(context).style.color;
                final backgroundColor = _isHovering
                    ? theme.gray
                    : _isFocusing
                        ? CupertinoColors.activeBlue
                            .resolveFrom(context)
                            .withOpacity(0.2)
                        : widget.idleBackgroundColor ??
                            theme.colorScheme.surface.withOpacity(0.9);
                final title = IconTheme(
                  data: IconThemeData(
                    color: foregroundColor,
                  ),
                  child: DefaultTextStyle(
                    style: (theme.textTheme.bodyMedium ?? const TextStyle())
                        .copyWith(color: foregroundColor),
                    child: widget.title,
                  ),
                );
                final leading = widget.leading != null
                    ? IconTheme(
                        data: IconThemeData(
                          color: foregroundColor,
                        ),
                        child: DefaultTextStyle(
                          style: TextStyle(color: foregroundColor),
                          child: widget.leading!,
                        ),
                      )
                    : null;
                final tile = CupertinoListTile.notched(
                  backgroundColor: backgroundColor,
                  backgroundColorActivated: widget.highlightColor ??
                      PColors.gray.resolveFrom(context),
                  padding: widget.padding,
                  leading: leading,
                  title: title,
                  subtitle: isDisabled &&
                          widget.disabledText != null &&
                          foregroundColor == disabledColor
                      ? Text(
                          widget.disabledText!,
                          style: TextStyle(
                            color: foregroundColor,
                          ),
                        ).animate().fadeIn()
                      : widget.subtitleWhenEnabled,
                  trailing: widget.trailing,
                  additionalInfo: widget.additionalInfo != null
                      ? DefaultTextStyle(
                          style:
                              (theme.textTheme.bodyMedium ?? const TextStyle())
                                  .copyWith(
                            color: theme.darkGray,
                          ),
                          child: widget.additionalInfo ?? const SizedBox(),
                        )
                      : null,
                  onTap: widget.onTap,
                );

                final tileWithBackground = widget.enableBlurredBackground
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                        child: tile,
                      )
                    : tile;

                return AnimatedContainer(
                  duration: PEffects.veryShortDuration,
                  decoration: effectiveDecoration,
                  clipBehavior: Clip.antiAlias,
                  child: tileWithBackground,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
