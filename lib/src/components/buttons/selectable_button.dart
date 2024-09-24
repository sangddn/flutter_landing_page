import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

import '../../core/core.dart';
import '../components.dart';

class PSelectableButton extends StatefulWidget {
  const PSelectableButton({
    this.titleStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.isSelected = false,
    this.tooltip,
    required this.onTap,
    this.leading,
    this.labelWidget,
    required this.label,
    super.key,
  });

  final TextStyle? titleStyle;
  final String? tooltip;

  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? leading, labelWidget;
  final String label;

  final Color? backgroundColor,
      foregroundColor,
      selectedBackgroundColor,
      selectedForegroundColor;

  @override
  State<PSelectableButton> createState() => _PSelectableButtonState();
}

class _PSelectableButtonState extends State<PSelectableButton> {
  bool _isHovering = false;
  bool _animateIcon = false;

  @override
  void didUpdateWidget(PSelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected ||
        ((oldWidget.backgroundColor != widget.backgroundColor ||
                oldWidget.foregroundColor != widget.foregroundColor) &&
            (widget.backgroundColor != null &&
                widget.foregroundColor != null)) ||
        ((oldWidget.selectedBackgroundColor != widget.selectedBackgroundColor ||
                oldWidget.selectedForegroundColor !=
                    widget.selectedForegroundColor) &&
            (widget.selectedBackgroundColor != null &&
                widget.selectedForegroundColor != null)) ||
        oldWidget.label != widget.label ||
        widget.leading != oldWidget.leading ||
        widget.labelWidget != oldWidget.labelWidget) {
      setState(() {
        _animateIcon = !_animateIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultSelectionColors = PColors.selectionColors(context);

    final effectiveForegroundColor = widget.isSelected
        ? (widget.selectedForegroundColor ?? defaultSelectionColors.$2)
        : (widget.foregroundColor ?? theme.colorScheme.onSurface);

    final backgroundColor = widget.isSelected
        ? (widget.selectedBackgroundColor ?? defaultSelectionColors.$1)
        : (widget.backgroundColor ?? theme.colorScheme.surface);

    final effectiveBackgroundColor =
        _isHovering ? backgroundColor.withOpacity(0.8) : backgroundColor;

    final iconTheme = IconThemeData(
      size: 20.0,
      color: effectiveForegroundColor,
    );

    const innerPadding = 12.0;

    return PTooltip(
      message: widget.tooltip ?? widget.label,
      child: IconTheme(
        data: iconTheme,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTap: () {
              widget.onTap?.call();
            },
            child: Tilt(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              shadowConfig: ShadowConfig(
                disable: !_isHovering,
                color: Colors.black,
                spreadInitial: 2.0,
                maxBlurRadius: 16.0,
                maxIntensity: 0.1,
                offsetInitial: const Offset(0, 2),
              ),
              childLayout: ChildLayout(
                outer: [
                  if (widget.leading case final leading?)
                    AnimatedPositioned(
                      duration: PEffects.mediumDuration,
                      curve: Curves.easeInOut,
                      top: innerPadding - 2.0,
                      left: innerPadding,
                      child: TiltParallax(
                        child: leading
                            .animate(
                              target: _animateIcon ? 1.0 : 0.0,
                            )
                            .scaleXY(
                              duration: PEffects.veryShortDuration,
                              curve: Curves.easeOut,
                              begin: 1.0,
                              end: 1.3,
                            )
                            .then()
                            .scaleXY(
                              duration: PEffects.veryShortDuration,
                              curve: Curves.easeIn,
                              begin: 1.3,
                              end: 1.0,
                            ),
                      ),
                    ),
                ],
              ),
              child: AnimatedContainer(
                duration: PEffects.shortDuration,
                curve: Curves.decelerate,
                decoration: ShapeDecoration(
                  shape: PDecors.border12,
                  color: effectiveBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: innerPadding,
                  vertical: innerPadding - 4.0,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.leading case final leading?) ...[
                      Visibility(
                        visible: false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: leading,
                      ),
                      const Gap(4.0),
                    ],
                    Flexible(
                      child: widget.labelWidget ??
                          AutoSizeText(
                            widget.label,
                            maxFontSize:
                                theme.textTheme.bodyLarge?.fontSize ?? 24.0,
                            style:
                                (widget.titleStyle ?? theme.textTheme.bodyLarge)
                                    ?.copyWith(
                              color: effectiveForegroundColor,
                            ),
                            maxLines: 1,
                          ),
                    ),
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
