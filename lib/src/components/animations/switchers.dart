import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/ui/ui.dart';
import '../components.dart';

const _flipCurveIn = Curves.easeOutQuad;
const _flipCurveOut = Curves.easeInQuad;
const _translationCurveIn = Easing.emphasizedDecelerate;
const _translationCurveOut = Easing.emphasizedAccelerate;
const _zoomCurveIn = Curves.easeIn;
const _zoomCurveOut = Curves.easeOut;

/// Switcher with flip transition
class FlipSwitcher extends AnimatedSwitcher {
  /// Switcher with flip transition around x axis
  FlipSwitcher.flipX({
    super.duration = PEffects.mediumDuration,
    super.reverseDuration,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.switchInCurve = _flipCurveIn,
    super.switchOutCurve = _flipCurveOut,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: fadeTransitionBuilder(false),
        );

  /// Switcher with flip transition around y axis
  FlipSwitcher.flipY({
    super.duration = PEffects.mediumDuration,
    super.reverseDuration,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.switchInCurve = _flipCurveIn,
    super.switchOutCurve = _flipCurveOut,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: fadeTransitionBuilder(true),
        );
}

AnimatedSwitcherTransitionBuilder fadeTransitionBuilder(bool isYAxis) =>
    (final child, final animation) => _FlipTransition(
          rotate: animation,
          isYAxis: isYAxis,
          child: child,
        );

class _FlipTransition extends AnimatedWidget {
  const _FlipTransition({
    required Animation<double> rotate,
    required this.isYAxis,
    this.child,
  }) : super(listenable: rotate);

  final bool isYAxis;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (rotate.value < 0.5) {
      return SizedBox.shrink(child: child);
    }
    final transform = Matrix4.identity()..setEntry(3, 2, 0.001);

    if (isYAxis) {
      transform.rotateY((1 - rotate.value) * math.pi);
    } else {
      transform.rotateX((1 - rotate.value) * math.pi);
    }

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }

  Animation<double> get rotate => listenable as Animation<double>;
}

/// Switcher with blur transition
///
class BlurSwitcher extends AnimatedSwitcher {
  /// Switcher with blur in transition
  BlurSwitcher.blurIn({
    super.duration = PEffects.mediumDuration,
    double blurAmount = 4.0,
    super.reverseDuration,
    super.switchInCurve = Curves.easeOut,
    super.switchOutCurve = Curves.easeIn,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: blurTransitionBuilder(true, blurAmount),
        );

  /// Switcher with blur out transition
  BlurSwitcher.blurOut({
    super.duration = PEffects.mediumDuration,
    double blurAmount = 4.0,
    super.reverseDuration,
    super.switchInCurve = Curves.easeOut,
    super.switchOutCurve = Curves.easeIn,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: blurTransitionBuilder(false, blurAmount),
        );
}

AnimatedSwitcherTransitionBuilder blurTransitionBuilder(
  bool isBlurIn,
  double blurAmount,
) =>
    (final child, final animation) {
      final bool isReversed = animation.status.isCompletedOrReversed;

      return BlurTransition(
        blur: Tween<double>(
          begin: isReversed ? 4.0 : 0.0,
          end: isReversed ? 0.0 : 4.0,
        ).animate(animation),
        child: child,
      );
    };

/// Blur transition
///
class BlurTransition extends AnimatedWidget {
  const BlurTransition({
    required Animation<double> blur,
    required this.child,
    super.key,
  }) : super(listenable: blur);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: blur.value,
        sigmaY: blur.value,
      ),
      child: child,
    );
  }

  Animation<double> get blur => listenable as Animation<double>;
}

/// Switcher with translation transition
class TranslationSwitcher extends AnimatedSwitcher {
  /// Switcher with translation transition toward left
  TranslationSwitcher.left({
    super.duration = PEffects.shortDuration,
    double offset = 0.3,
    super.reverseDuration,
    super.switchInCurve = _translationCurveIn,
    super.switchOutCurve = _translationCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    bool enableBlur = true,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: translationTransitionBuilder(
            Offset(offset, 0),
            enableFade,
            enableBlur,
          ),
        );

  /// Switcher with translation transition toward right
  TranslationSwitcher.right({
    super.duration = PEffects.shortDuration,
    double offset = 0.3,
    super.reverseDuration,
    super.switchInCurve = _translationCurveIn,
    super.switchOutCurve = _translationCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    bool enableBlur = true,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: translationTransitionBuilder(
            Offset(-offset, 0),
            enableFade,
            enableBlur,
          ),
        );

  /// Switcher with translation transition toward top
  TranslationSwitcher.top({
    super.duration = PEffects.shortDuration,
    double offset = 0.3,
    super.reverseDuration,
    super.switchInCurve = _translationCurveIn,
    super.switchOutCurve = _translationCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    bool enableBlur = true,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: translationTransitionBuilder(
            Offset(0, offset),
            enableFade,
            enableBlur,
          ),
        );

  /// Switcher with translation transition toward bottom
  TranslationSwitcher.bottom({
    super.duration = PEffects.shortDuration,
    double offset = 0.3,
    super.reverseDuration,
    super.switchInCurve = _translationCurveIn,
    super.switchOutCurve = _translationCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    bool enableFade = true,
    bool enableBlur = true,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder: translationTransitionBuilder(
            Offset(0, -offset),
            enableFade,
            enableBlur,
          ),
        );

  const TranslationSwitcher.custom({
    super.duration = PEffects.shortDuration,
    super.reverseDuration,
    super.switchInCurve = _translationCurveIn,
    super.switchOutCurve = _translationCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    super.child,
    required super.transitionBuilder,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
        );
}

AnimatedSwitcherTransitionBuilder translationTransitionBuilder(
  Offset offset,
  bool enableFade,
  bool enableBlur,
) =>
    (var child, final animation) {
      final bool isReversed = animation.status.isCompletedOrReversed;

      if (enableFade) {
        child = FadeTransition(
          opacity: animation,
          child: child,
        );
      }

      if (enableBlur) {
        child = BlurTransition(
          blur: Tween<double>(
            begin: 4.0,
            end: 0.0,
          ).animate(animation),
          child: child,
        );
      }

      return ScaleTransition(
        scale: Tween<double>(
          begin: isReversed ? 0.7 : 1.15,
          end: 1.0,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: isReversed ? offset.scale(-1, -1) : offset,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    };

/// Switcher with zoom transition
class ZoomSwitcher extends AnimatedSwitcher {
  /// Switcher with zoom in transition
  ZoomSwitcher.zoomIn({
    super.duration = PEffects.mediumDuration,
    super.reverseDuration,
    super.switchInCurve = _zoomCurveIn,
    super.switchOutCurve = _zoomCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    double scaleInFactor = 0.88,
    double scaleOutFactor = 1.14,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              zoomTransitionBuilder(scaleInFactor, scaleOutFactor),
        );

  /// Switcher with zoom out transition
  ZoomSwitcher.zoomOut({
    super.duration = PEffects.mediumDuration,
    super.reverseDuration,
    super.switchInCurve = _zoomCurveIn,
    super.switchOutCurve = _zoomCurveOut,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    double scaleInFactor = 1.14,
    double scaleOutFactor = 0.88,
    super.child,
    super.key,
  }) : super(
          layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
          transitionBuilder:
              zoomTransitionBuilder(scaleInFactor, scaleOutFactor),
        );
}

class SizeFadeSwitcher extends StatelessWidget {
  const SizeFadeSwitcher({
    this.axis = Axis.vertical,
    this.axisAlignment = -1.0,
    this.reverseDuration,
    this.switchInCurve = Curves.easeOut,
    this.switchOutCurve = Curves.easeIn,
    this.layoutBuilder,
    this.duration = PEffects.mediumDuration,
    this.enableBlur = false,
    this.enableScale = false,
    required this.child,
    super.key,
  });

  final Axis axis;
  final double axisAlignment;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve, switchOutCurve;
  final bool enableBlur, enableScale;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (child, animation) {
        child = FadeTransition(
          opacity: animation,
          child: SizeTransition(
            axis: axis,
            axisAlignment: axisAlignment,
            sizeFactor: animation,
            child: child,
          ),
        );
        if (enableBlur) {
          child = BlurTransition(
            blur: animation,
            child: child,
          );
        }
        if (enableScale) {
          child = ScaleTransition(
            scale: animation,
            alignment: axis == Axis.horizontal
                ? Alignment(axisAlignment, 0.0)
                : Alignment(0.0, axisAlignment),
            child: child,
          );
        }
        return child;
      },
      child: child,
    );
  }
}

class FadeSwitcher extends StatelessWidget {
  const FadeSwitcher({
    required this.child,
    this.duration = PEffects.mediumDuration,
    this.reverseDuration,
    this.switchInCurve = Curves.easeOut,
    this.switchOutCurve = Curves.easeIn,
    this.layoutBuilder,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve, switchOutCurve;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}

class ScaleBlurSwitcher extends StatelessWidget {
  const ScaleBlurSwitcher({
    this.duration = PEffects.mediumDuration,
    this.reverseDuration,
    this.switchInCurve = Curves.easeOut,
    this.switchOutCurve = Curves.easeIn,
    this.layoutBuilder,
    this.blurAmount = 4.0,
    required this.child,
    super.key,
  });

  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve, switchOutCurve;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;
  final double blurAmount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (child, animation) {
        final tween = Tween<double>(begin: 0.0, end: 1.0);
        final curve = CurvedAnimation(
          parent: animation,
          curve: Sprung(),
        );

        return ScaleTransition(
          scale: tween.animate(curve),
          child: BlurTransition(
            blur: tween.animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

AnimatedSwitcherTransitionBuilder zoomTransitionBuilder(
  double scaleInFactor,
  double scaleOutFactor,
) =>
    (final child, final animation) {
      final bool isReversed = animation.status.isCompletedOrReversed;

      return ScaleTransition(
        scale: Tween<double>(
          begin: isReversed ? scaleOutFactor : scaleInFactor,
          end: 1.0,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    };

extension AnimationStatusExtension on AnimationStatus {
  bool get isCompletedOrReversed =>
      this == AnimationStatus.completed || this == AnimationStatus.reverse;
}

AnimatedSwitcherLayoutBuilder alignedLayoutBuilder(
  AlignmentGeometry alignment, {
  StackFit fit = StackFit.loose,
  Widget? Function(Widget?)? currentChildBuilder,
}) =>
    (
      Widget? currentChild,
      List<Widget> previousChildren,
    ) =>
        Stack(
          alignment: alignment,
          children: <Widget>[
            ...previousChildren,
            if (currentChildBuilder?.call(currentChild) ?? currentChild
                case final child?)
              child,
          ],
        );
