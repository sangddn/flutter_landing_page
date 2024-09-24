import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

class AnimatedLinearGradientMask extends StatefulWidget {
  const AnimatedLinearGradientMask({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.colors,
    required this.stops,
    this.curve = Curves.easeInOut,
    this.duration = PEffects.shortDuration,
    required this.child,
    super.key,
  });

  final AlignmentGeometry begin, end;

  /// The colors to use for the gradient. There must be at least two colors.
  /// If there are more than two, [stops] must have the same length as [colors]
  /// and specifies the position of each color stop.
  ///
  /// The length of this list, once set, must not change throughout the
  /// lifetime of the widget.
  ///
  final IList<Color> colors;

  /// The stops for each color in the gradient. The stops must be non-null and
  /// in ascending order. There must be the same number of stops as colors.
  ///
  /// The length of this list, once set, must not change throughout the
  /// lifetime of the widget.
  ///
  final IList<double> stops;

  final Curve curve;

  final Duration duration;

  final Widget child;

  @override
  State<AnimatedLinearGradientMask> createState() =>
      _AnimatedLinearGradientMaskState();
}

class _AnimatedLinearGradientMaskState extends State<AnimatedLinearGradientMask>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: PEffects.veryShortDuration,
    vsync: this,
  );
  late final _animation =
      CurvedAnimation(parent: _controller, curve: widget.curve);

  List<ColorTween>? _colorTweens;
  List<Tween<double>>? _stopTweens;
  AlignmentGeometryTween? _beginTween;
  AlignmentGeometryTween? _endTween;

  @override
  void didUpdateWidget(covariant AnimatedLinearGradientMask oldWidget) {
    super.didUpdateWidget(oldWidget);

    var changed = false;

    if (oldWidget.colors != widget.colors) {
      assert(
        widget.colors.length >= 2 &&
            widget.colors.length == oldWidget.colors.length,
      );
      changed = true;
      _colorTweens = List.generate(
        widget.colors.length,
        (index) => ColorTween(
          begin: oldWidget.colors[index],
          end: widget.colors[index],
        ),
      );
    } else {
      _colorTweens = null;
    }

    if (oldWidget.stops != widget.stops) {
      assert(widget.stops.length == oldWidget.stops.length);
      changed = true;
      _stopTweens = List.generate(
        widget.stops.length,
        (index) => Tween<double>(
          begin: oldWidget.stops[index],
          end: widget.stops[index],
        ),
      );
    } else {
      _stopTweens = null;
    }

    if (oldWidget.begin != widget.begin) {
      _beginTween =
          AlignmentGeometryTween(begin: oldWidget.begin, end: widget.begin);
      changed = true;
    } else {
      _beginTween = null;
    }

    if (oldWidget.end != widget.end) {
      _endTween = AlignmentGeometryTween(begin: oldWidget.end, end: widget.end);
      changed = true;
    } else {
      _endTween = null;
    }

    if (changed) {
      _controller.duration = widget.duration;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final colors =
              _colorTweens?.map((e) => e.evaluate(_animation)!).toList() ??
                  widget.colors.toList();
          final stops =
              _stopTweens?.map((e) => e.evaluate(_animation)).toList() ??
                  widget.stops.toList();
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: _beginTween?.evaluate(_animation) ?? widget.begin,
                end: _endTween?.evaluate(_animation) ?? widget.end,
                colors: colors,
                stops: stops,
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: widget.child,
          );
        },
      ),
    );
  }
}
