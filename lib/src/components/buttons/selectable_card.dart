import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

import '../../core/core.dart';
import '../components.dart';

class SelectableCard extends StatefulWidget {
  const SelectableCard({
    this.selectedBadge,
    this.onTap,
    this.titleStyle,
    this.timeStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.shouldRespondToGyro = false,
    this.icon,
    required this.isSelected,
    required this.child,
    super.key,
  });

  final Widget? selectedBadge;
  final ValueChanged<bool>? onTap;
  final TextStyle? titleStyle;
  final TextStyle? timeStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool shouldRespondToGyro;

  final bool isSelected;
  final Widget? icon;
  final Widget child;

  @override
  State<SelectableCard> createState() => _ReminderTimeOfDayPickerState();
}

class _ReminderTimeOfDayPickerState extends State<SelectableCard> {
  late bool _isSelected = widget.isSelected;
  bool _isHovering = false;
  bool _isPressing = false;

  @override
  void didUpdateWidget(SelectableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      setState(() {
        _isSelected = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveForegroundColor =
        widget.foregroundColor ?? theme.colorScheme.onSurface;

    final effectiveBackgroundColor =
        widget.backgroundColor ?? theme.colorScheme.surface;

    final iconTheme = IconThemeData(
      size: 24.0,
      color: effectiveForegroundColor,
    );

    const innerPadding = 12.0;
    final isSelected = _isSelected;
    const margin = 8.0;

    return IconTheme(
      data: iconTheme,
      child: InkResponse(
        onHover: (hovering) => setState(() => _isHovering = hovering),
        onTapDown: (_) => setState(() => _isPressing = true),
        onTapUp: (_) => setState(() => _isPressing = false),
        onTapCancel: () => setState(() => _isPressing = false),
        child: BouncingObject(
          onTap: widget.onTap == null
              ? null
              : () => widget.onTap?.call(!_isSelected),
          child: Tilt(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            shadowConfig: ShadowConfig(
              color: Colors.black12,
              spreadInitial: _isHovering ? 8.0 : 4.0,
              offsetInitial: const Offset(0, 2),
            ),
            lightConfig: const LightConfig(
              disable: true,
            ),
            tiltConfig: TiltConfig(
              enableGestureSensors: widget.shouldRespondToGyro,
            ),
            childLayout: ChildLayout(
              outer: [
                if (widget.icon case final icon?)
                  AnimatedPositioned(
                    duration: PEffects.shortDuration,
                    curve: Curves.easeInOut,
                    top: innerPadding + margin,
                    left: innerPadding,
                    child: TiltParallax(
                      child: icon,
                    ),
                  ),
                Positioned(
                  top: 0.0,
                  right: 4.0,
                  child: TiltParallax(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: SimpleBadge(
                        content: null,
                        widgetContent: isSelected
                            ? const Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Icon(
                                  CupertinoIcons.check_mark,
                                  size: 12.0,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(),
                        backgroundColor: isSelected
                            ? CupertinoColors.activeGreen
                            : effectiveBackgroundColor,
                        // foregroundColor: effectiveForegroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: AnimatedPadding(
              duration: PEffects.shortDuration,
              curve: Curves.easeInOut,
              padding: const EdgeInsets.only(
                top: margin,
                right: margin,
              ),
              child: AnimatedContainer(
                duration: PEffects.shortDuration,
                curve: Curves.decelerate,
                decoration: ShapeDecoration(
                  shape: const PContinuousRectangleBorder(cornerRadius: 16.0),
                  color: effectiveBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: innerPadding - 4.0,
                  vertical: innerPadding - 4.0,
                ),
                alignment: Alignment.bottomLeft,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleBadge extends StatefulWidget {
  const SimpleBadge({
    required this.content,
    this.widgetContent,
    this.tooltip,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.elevated = true,
    super.key,
  }) : assert((content == null) != (widgetContent == null));

  final String? content;
  final Widget? widgetContent;
  final String? tooltip;
  final VoidCallback? onTap;
  final Color? backgroundColor, foregroundColor;
  final bool elevated;

  @override
  State<SimpleBadge> createState() => _SimpleBadgeState();
}

class _SimpleBadgeState extends State<SimpleBadge>
    with SingleTickerProviderStateMixin {
  late final _animController = AnimationController(
    vsync: this,
    duration: PEffects.shortDuration,
  );

  Widget _buildContent() {
    if (widget.widgetContent case final widget?) {
      return widget;
    } else if (widget.content case final content?) {
      return AutoSizeText(
        content,
        maxFontSize: 16.0,
        minFontSize: 8.0,
        maxLines: 1,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  void didUpdateWidget(SimpleBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content ||
        widget.widgetContent != oldWidget.widgetContent) {
      setState(() {});

      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = _buildContent();

    final effectiveBackgroundColor =
        widget.backgroundColor ?? PColors.matteBlue;

    final effectiveForegroundColor = widget.foregroundColor ?? PColors.offDark;

    final badge = AnimatedContainer(
      duration: PEffects.mediumDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: effectiveBackgroundColor,
        boxShadow: widget.elevated
            ? const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DefaultTextStyle(
            style: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
              color: widget.foregroundColor ?? effectiveForegroundColor,
            ),
            child: content,
          ),
        ),
      ),
    )
        .animate(
          autoPlay: true,
          controller: _animController,
        )
        .scaleXY(
          duration: PEffects.shortDuration,
          curve: Curves.easeOut,
          begin: 1.0,
          end: 1.3,
        )
        .then()
        .scaleXY(
          duration: PEffects.shortDuration,
          curve: Curves.easeIn,
          begin: 1.3,
          end: 1.0,
        );

    final tappable = BouncingObject(
      onTap: widget.onTap,
      child: badge,
    );

    if (widget.tooltip != null) {
      return PTooltip(
        message: widget.tooltip,
        triggerMode: TooltipTriggerMode.tap,
        child: tappable,
      );
    }

    return tappable;
  }
}
