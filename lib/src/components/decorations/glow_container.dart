import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../core/core.dart';

/// This Widget creates a glowing, animated gradient border around your widgets.
///
class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    this.transitionDuration = PEffects.shortDuration,
    this.duration = const Duration(milliseconds: 2000),
    this.borderThickness = 0.0,
    this.glowSize = 5.0,
    this.animationProgress,
    required this.gradientColors,
    required this.outerDecoration,
    required this.child,
    super.key,
  });

  final double borderThickness;

  /// How far and intense the glow should be.
  ///
  final double glowSize;

  /// The colors to use for the gradient.
  ///
  final List<Color> gradientColors;

  /// The decoration of the super-container.
  ///
  final ShapeDecoration outerDecoration;

  /// The duration of the animation.
  ///
  final Duration duration;

  /// The duration of the transition.
  ///
  final Duration transitionDuration;

  /// If != null, the gradient will rotate towards its destination.
  /// Value between 0..1.
  ///
  final double? animationProgress;

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedGradientState();
}

class AnimatedGradientState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final _angleAnimation =
      Tween<double>(begin: 0.1, end: 2 * math.pi).animate(_controller);

  @override
  void initState() {
    super.initState();
    if (widget.animationProgress != null && widget.glowSize > 0.0) {
      _controller.forward();
    } else {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    final animateTo = widget.animationProgress;
    if (animateTo != null) {
      _controller.animateTo(animateTo);
    } else {
      _controller.repeat();
    }
    if (widget.glowSize != oldWidget.glowSize ||
        widget.outerDecoration != oldWidget.outerDecoration) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final negativeMargin = -1.0 * (widget.borderThickness);
    final backGradient = Positioned(
      top: negativeMargin,
      left: negativeMargin,
      right: negativeMargin,
      bottom: negativeMargin,
      child: AnimatedOpacity(
        duration: widget.transitionDuration,
        curve: Curves.ease,
        opacity: widget.glowSize > 0.0 ? 1.0 : 0.0,
        child: AnimatedBuilder(
          animation: _angleAnimation,
          builder: (context, _) {
            return AnimatedGradientContainer(
              gradientColors: widget.gradientColors,
              shape: widget.outerDecoration.shape,
              gradientAngle: _angleAnimation.value,
            );
          },
        ),
      ),
    );
    final stacked = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        backGradient,
        widget.child,
      ],
    );
    final filtered = widget.glowSize > 0.0
        ? BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.glowSize,
              sigmaY: widget.glowSize,
            ),
            child: stacked,
          )
        : stacked;
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: widget.transitionDuration,
        curve: Curves.ease,
        padding: EdgeInsets.all(widget.borderThickness),
        clipBehavior: Clip.hardEdge,
        decoration: widget.outerDecoration,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            backGradient,
            filtered,
          ],
        ),
      ),
    );
  }
}

class AnimatedGradientContainer extends StatefulWidget {
  const AnimatedGradientContainer({
    super.key,
    required this.gradientColors,
    required this.gradientAngle,
    required this.shape,
    this.child,
  });

  final List<Color> gradientColors;
  final double gradientAngle;
  final ShapeBorder shape;
  final Widget? child;

  @override
  State<AnimatedGradientContainer> createState() => _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer> {
  late var _colors = [...widget.gradientColors, ...widget.gradientColors.reversed];
  late var _stops = _generateColorStops(_colors);

  List<double> _generateColorStops(List<dynamic> colors) {
    return colors.asMap().entries.map((entry) {
      final double percentageStop = entry.key / colors.length;
      return percentageStop;
    }).toList();
  }
  
  @override
  void didUpdateWidget (AnimatedGradientContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.gradientColors, oldWidget.gradientColors)) {
      setState(() {
        _colors = [...widget.gradientColors, ...widget.gradientColors.reversed];
        _stops = _generateColorStops(_colors);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: widget.shape,
        gradient: SweepGradient(
          colors: _colors,
          stops: _stops,
          transform: GradientRotation(widget.gradientAngle),
        ),
      ),
      child: widget.child,
    );
  }

}
