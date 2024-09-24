import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../core/core.dart';
import '../components.dart';

typedef MaybeScrollableBuilder = Widget Function(
  BuildContext context,
  ScrollController? scrollController,
  SheetController? sheetController,
);

Future<T?> showModal<T>({
  required BuildContext context,
  required MaybeScrollableBuilder builder,
  double? minHeight,
  double? initHeight,
  double? maxHeight,
  bool isDismissible = true,
  bool isDraggable = false,
  bool useRootNavigator = false,
  CupertinoDynamicColor? bottomSheetColor,
  CupertinoDynamicColor? barrierColor,
  Duration? duration,
  EdgeInsetsGeometry dialogPadding = k24HPadding,
  Decoration? decoration,
  BoxConstraints? dialogContraints,
}) {
  if (MediaQuery.of(context).size.width < 500) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push(
      CupertinoModalSheetRoute(
        swipeDismissible: isDismissible,
        barrierDismissible: isDismissible,
        barrierColor: barrierColor,
        transitionDuration: duration ?? const Duration(milliseconds: 300),
        builder: (modalContext) {
          final child = ReTheme(
            builder: (context) {
              decoration ??= ShapeDecoration(
                shape: const PContinuousRectangleBorder(
                  cornerRadius: 24.0,
                ),
                color: bottomSheetColor?.resolveFrom(context) ??
                    Theme.of(context)
                        .resolveColor(PColors.offWhite, PColors.dark),
                // shadows: PDecors.broadShadows(context),
              );
              return Container(
                decoration: decoration,
                clipBehavior: Clip.hardEdge,
                child: Builder(
                  builder: (context) {
                    final scrollController =
                        PrimaryScrollController.maybeOf(context);
                    final sheetController =
                        DefaultSheetController.maybeOf(context);
                    return builder(
                      context,
                      scrollController,
                      sheetController,
                    );
                  },
                ),
              );
            },
          );

          final initialExtent = Extent.proportional(initHeight ?? 1.0);
          final minExtent = Extent.proportional(minHeight ?? 1.0);
          final maxExtent = Extent.proportional(maxHeight ?? 1.0);

          return isDraggable
              ? DraggableSheet(
                  initialExtent: initialExtent,
                  minExtent: minExtent,
                  maxExtent: maxExtent,
                  physics: const BouncingSheetPhysics(
                    parent: SnappingSheetPhysics(),
                  ),
                  child: child,
                )
              : ScrollableSheet(
                  initialExtent: initialExtent,
                  minExtent: minExtent,
                  maxExtent: maxExtent,
                  physics: const BouncingSheetPhysics(
                    parent: SnappingSheetPhysics(),
                  ),
                  child: child,
                );
        },
      ),
    );
  } else {
    return showPDialog<T>(
      context: context,
      builder: (context) => builder(context, null, null),
      isDismissible: isDismissible,
      maxHeight: maxHeight,
      dialogContraints: dialogContraints,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      padding: dialogPadding,
    );
  }
}

enum DialogTransition {
  fadeSlide,
  fadeScale,
  ;

  Widget Function(Animation<double> animation, Widget background, Widget child)
      get builder => switch (this) {
            DialogTransition.fadeSlide => _slideFadeTransitionBuilder,
            DialogTransition.fadeScale => _fadeScaleInTransitionBuilder,
          };
}

Future<T?> showPDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  EdgeInsetsGeometry padding = k24HPadding,
  bool isDismissible = true,
  double? maxHeight,
  double? maxWidth,
  double? elevation,
  BoxConstraints? dialogContraints,
  CupertinoDynamicColor? barrierColor,
  bool useRootNavigator = false,
  double backgroundOpacity = 1.0,
  DialogTransition transition = DialogTransition.fadeSlide,
}) =>
    showGeneralDialog<T>(
      context: context,
      barrierColor: barrierColor?.resolveFrom(context) ?? Colors.transparent,
      barrierDismissible: isDismissible,
      barrierLabel: 'Dismiss',
      useRootNavigator: useRootNavigator,
      transitionDuration: PEffects.shortDuration,
      pageBuilder: (context, anim1, anim2) => _DialogWrapper(
        animation: anim1,
        transition: transition,
        elevation: elevation,
        backgroundOpacity: backgroundOpacity,
        padding: padding,
        isDismissible: isDismissible,
        maxHeightPercentage: maxHeight,
        maxWidthPercentage: maxWidth,
        childConstraints: dialogContraints,
        child: builder(context),
      ),
    );

Widget _slideFadeTransitionBuilder(
  Animation<double> animation,
  Widget background,
  Widget child,
) {
  // Apply Curves.easeInOut to the animation for a smooth transition.
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Easing.emphasizedDecelerate,
  );

  final slideTween = Tween<Offset>(
    begin: const Offset(0, 1), // Start from bottom
    end: Offset.zero, // End at current position
  );

  background = FadeTransition(
    opacity: curvedAnimation,
    child: background,
  );

  child = SlideTransition(
    position:
        slideTween.animate(curvedAnimation), // Slide up animation with curve
    child: FadeTransition(
      opacity: curvedAnimation, // Fade in animation with curve
      child: child,
    ),
  );

  return Stack(
    children: [
      Positioned.fill(child: background),
      Center(child: child),
    ],
  );
}

Widget _fadeScaleInTransitionBuilder(
  Animation<double> animation,
  Widget background,
  Widget child,
) {
  // Apply Curves.easeInOut to the animation for a smooth transition.
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Easing.emphasizedDecelerate,
  );

  final scaleTween = Tween<double>(
    begin: 1.2, // Start from 1.2
    end: 1.0, // End at 1
  );

  background = FadeTransition(
    opacity: curvedAnimation,
    child: background,
  );

  child = ScaleTransition(
    scale: scaleTween.animate(curvedAnimation), // Scale in animation with curve
    child: FadeTransition(
      opacity: curvedAnimation, // Fade in animation with curve
      child: child,
    ),
  );

  return Stack(
    children: [
      Positioned.fill(child: background),
      Center(child: child),
    ],
  );
}

class _DialogWrapper extends StatelessWidget {
  const _DialogWrapper({
    required this.animation,
    required this.transition,
    required this.backgroundOpacity,
    required this.padding,
    required this.isDismissible,
    required this.maxHeightPercentage,
    required this.maxWidthPercentage,
    required this.childConstraints,
    required this.elevation,
    required this.child,
  });

  final Animation<double> animation;
  final DialogTransition transition;
  final double backgroundOpacity;
  final EdgeInsetsGeometry padding;
  final bool isDismissible;
  final double? maxHeightPercentage, maxWidthPercentage, elevation;
  final BoxConstraints? childConstraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ReTheme(
      includeNewScaffoldMessenger: true,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barrierColor = theme.colorScheme.onSurface.withOpacity(0.2);
              final background = GestureDetector(
                onTap: isDismissible
                    ? () {
                        Navigator.of(context).pop();
                      }
                    : null,
                child: ColoredBox(
                  color: Target.select(
                    android: barrierColor,
                    ios: barrierColor,
                  ),
                ),
              );

              final child = ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: min(
                    constraints.maxWidth * (maxWidthPercentage ?? 0.9),
                    childConstraints?.maxWidth ?? 1200.0,
                  ),
                  maxHeight: min(
                    constraints.maxHeight * (maxHeightPercentage ?? 0.9),
                    childConstraints?.maxHeight ?? double.infinity,
                  ),
                ),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: PContinuousRectangleBorder(
                      cornerRadius: 24.0,
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                    ),
                    color: theme.scaffoldBackgroundColor
                        .withOpacityFactor(backgroundOpacity),
                    shadows: PDecors.elevation(
                      elevation ?? 16.0,
                      increaseIntensity: backgroundOpacity == 1.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  padding: padding,
                  child: this.child,
                ),
              );

              return transition.builder(animation, background, child);
            },
          ),
        );
      },
    );
  }
}
