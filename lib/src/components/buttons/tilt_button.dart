import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

import '../../core/core.dart';
import '../components.dart';

/// A button that has a tilt effect when pressed or interacted with.
///
/// [leading], if provided, will be placed before [child]. Both [leading] and [child]
/// are replicated twice to ensure center alignment when [leading] is provided.
///
class TiltButton extends StatelessWidget {
  const TiltButton({
    required this.tooltip,
    required this.onTap,
    this.leading,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 8.0,
    ),
    this.backgroundColor,
    this.foregroundColor,
    required this.child,
    super.key,
  });

  final String? tooltip;
  final VoidCallback? onTap;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = this.backgroundColor ?? theme.colorScheme.surface;
    final foregroundColor = this.foregroundColor ?? theme.colorScheme.onSurface;

    return PTooltip(
      message: tooltip,
      child: BouncingObject(
        onTap: onTap,
        child: DefaultTextStyle(
          style: TextStyle(
            color: foregroundColor,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: foregroundColor,
              size: 20.0,
            ),
            child: Tilt(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              shadowConfig: const ShadowConfig(
                disable: true,
              ),
              tiltConfig: const TiltConfig(
                enableGestureSensors: false,
              ),
              childLayout: ChildLayout(
                outer: [
                  if (leading case final leading?)
                    Align(
                      child: TiltParallax(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            leading,
                            const Gap(4.0),
                            Flexible(
                              child: Visibility(
                                visible: false,
                                maintainState: true,
                                maintainSize: true,
                                maintainAnimation: true,
                                child: child,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              child: Container(
                padding: k16H8VPadding,
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: PDecors.border12,
                  color: backgroundColor,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading case final leading?) ...[
                      Visibility(
                        visible: false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: leading,
                      ),
                      const Gap(4.0),
                    ],
                    Flexible(child: child),
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
