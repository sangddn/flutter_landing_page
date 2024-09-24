import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/core.dart';
import '../components.dart';

extension AnimationX on Widget {
  Widget animateOnHover({
    required List<Effect<dynamic>> effects,
  }) =>
      AnimateOnHover(
        effects: effects,
        child: this,
      );

  Widget animateOnTap({
    required List<Effect<dynamic>> effects,
    VoidCallback? onTap,
    bool autoPlay = true,
  }) =>
      AnimateOnTap(
        effects: effects,
        onTap: onTap,
        autoPlay: autoPlay,
        child: this,
      );

  Widget enlargeOnHover({
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.easeInQuad,
    double scale = 1.1,
  }) =>
      EnlargeOnHover(
        duration: duration,
        curve: curve,
        scale: scale,
        child: this,
      );

  Widget shimmerOnHover({
    Duration duration = PEffects.mediumDuration,
    Curve curve = Curves.ease,
  }) =>
      ShimmerOnHover(
        duration: duration,
        curve: curve,
        child: this,
      );

  Widget jumpOnHover({
    required double jumpScale,
    VoidCallback? onTap,
  }) =>
      JumpingCard(
        onTap: onTap,
        jumpScale: jumpScale,
        child: this,
      );

  Widget shimmerOnTap({
    Duration duration = PEffects.mediumDuration,
    Curve curve = Curves.ease,
    VoidCallback? onTap,
  }) =>
      AnimateOnTap(
        effects: [
          ShimmerEffect(
            duration: duration,
            curve: curve,
          ),
        ],
        onTap: onTap,
        child: this,
      );
}

extension CommonAnimations on Animate {
  Widget scaleOutAndBack({
    Duration duration = PEffects.veryShortDuration,
    Curve? curve,
    double scale = 1.2,
  }) =>
      scaleXY(
        duration: duration,
        curve: curve ?? Curves.easeOutBack,
        begin: 1.0 / scale,
        end: scale,
      ).then().scaleXY(
            duration: duration,
            curve: curve ?? Curves.easeOutBack,
            begin: scale,
            end: 1.0 / scale,
          );
}
