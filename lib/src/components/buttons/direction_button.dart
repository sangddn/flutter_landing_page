import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';
import '../components.dart';

class DirectionButton extends StatefulWidget {
  const DirectionButton({
    required this.onPressed,
    required this.title,
    this.subtitle,
    required this.direction,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget title;
  final Widget? subtitle;
  final AxisDirection direction;

  @override
  State<DirectionButton> createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<DirectionButton> {
  bool _isHovering = false;
  bool _isPressed = false;
  bool _hasPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final leftArrow = widget.direction == AxisDirection.left;
    final rightArrow = widget.direction == AxisDirection.right;
    final upArrow = widget.direction == AxisDirection.up;
    final downArrow = widget.direction == AxisDirection.down;

    final icon = switch (widget.direction) {
      AxisDirection.up => CupertinoIcons.arrow_up,
      AxisDirection.right => CupertinoIcons.arrow_right,
      AxisDirection.down => CupertinoIcons.arrow_down,
      AxisDirection.left => CupertinoIcons.arrow_left,
    };
    final gray = theme.gray;
    final darkGray = theme.darkGray;

    return AnimatedContainer(
      duration: PEffects.shortDuration,
      curve: Easing.emphasizedDecelerate,
      child: Material(
        color: gray,
        shape: PDecors.border16,
        clipBehavior: Clip.antiAlias,
        child: InkResponse(
          onTap: widget.onPressed,
          highlightShape: BoxShape.rectangle,
          onHover: (value) => setState(() {
            _isHovering = value;
          }),
          onTapDown: (_) => setState(() {
            // debugPrint('$runtimeType tapped down');
            _isPressed = true;
          }),
          onTapCancel: () => setState(() {
            // debugPrint('$runtimeType tap canceled');
            _isPressed = false;
          }),
          onTapUp: (_) {
            setState(() {
              _hasPressed = true;
            });
            Future.delayed(PEffects.shortDuration, () {
              if (mounted) {
                setState(() {
                  _isPressed = false;
                  _hasPressed = false;
                });
              }
            });
          },
          child: Padding(
            padding: k16H12VPadding + k8HPadding,
            child: Row(
              children: [
                if (leftArrow || upArrow) ...[
                  Icon(
                    icon,
                    size: 24.0,
                    color: darkGray,
                  )
                      .animate(
                        target: _isHovering ? 1.0 : 0.0,
                        effects: [
                          SlideEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset.zero,
                            end: leftArrow
                                ? const Offset(-0.5, 0.0)
                                : const Offset(0.0, -0.5),
                          ),
                        ],
                      )
                      .animate(
                        target: _isPressed ? 1.0 : 0.0,
                        effects: [
                          const ScaleEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset(1.0, 1.0),
                            end: Offset(0.8, 0.8),
                          ),
                          TintEffect(
                            duration: PEffects.veryShortDuration,
                            color: PColors.matteBlue.adaptForContext(context),
                            begin: 0.0,
                            end: 1.0,
                          ),
                        ],
                      )
                      .animate(
                        target: _hasPressed ? 1.0 : 0.0,
                        effects: [
                          const ScaleEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset(0.8, 0.8),
                            end: Offset(0.6, 0.6),
                          ),
                        ],
                      )
                      .then()
                      .animate(
                        effects: [
                          const ScaleEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset(0.6, 0.6),
                            end: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                  const Gap(16.0),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style:
                            (theme.textTheme.titleMedium ?? const TextStyle())
                                .modifyWeight(1.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: widget.title,
                      ),
                      if (widget.subtitle case final subtitle?)
                        DefaultTextStyle(
                          style:
                              (theme.textTheme.bodyMedium ?? const TextStyle())
                                  .copyWith(
                            color: darkGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: subtitle,
                        ),
                    ],
                  ),
                ),
                if (rightArrow || downArrow) ...[
                  const Gap(16.0),
                  Icon(
                    icon,
                    size: 24.0,
                    color: darkGray,
                  )
                      .animate(
                        target: _isHovering ? 1.0 : 0.0,
                        effects: [
                          SlideEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset.zero,
                            end: rightArrow
                                ? const Offset(0.5, 0.0)
                                : const Offset(0.0, 0.5),
                          ),
                        ],
                      )
                      .animate(
                        target: _isPressed ? 1.0 : 0.0,
                        effects: [
                          const ScaleEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset(1.0, 1.0),
                            end: Offset(0.8, 0.8),
                          ),
                          TintEffect(
                            duration: PEffects.veryShortDuration,
                            color: PColors.matteBlue.adaptForContext(context),
                            begin: 0.0,
                            end: 1.0,
                          ),
                        ],
                      )
                      .animate(
                        target: _hasPressed ? 1.0 : 0.0,
                        effects: [
                          const ScaleEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset(0.8, 0.8),
                            end: Offset(0.6, 0.6),
                          ),
                        ],
                      )
                      .then()
                      .animate(
                        effects: [
                          const ScaleEffect(
                            duration: PEffects.veryShortDuration,
                            begin: Offset(0.6, 0.6),
                            end: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                ],
              ],
            ),
          ),
        ),
      ).animate(
        effects: [
          ScaleEffect(
            duration: PEffects.shortDuration,
            begin: Offset.zero,
            end: const Offset(1.0, 1.0),
            alignment: leftArrow
                ? Alignment.centerRight
                : rightArrow
                    ? Alignment.centerLeft
                    : upArrow
                        ? Alignment.bottomCenter
                        : Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
