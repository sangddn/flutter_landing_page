import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

import '../../core/core.dart';
import '../components.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    this.milliseconds = 1000,
    this.enableShimmer = true,
    this.baseColor = PColors.bhOffWhite,
    this.highlightColor = PColors.offWhite,
    required this.child,
    super.key,
  });

  final int milliseconds;
  final bool enableShimmer;
  final Color baseColor;
  final Color highlightColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: enableShimmer
          ? shimmer.Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              period: Duration(milliseconds: milliseconds),
              child: child,
            )
          : child,
    );
  }
}

class GrayShimmer extends StatelessWidget {
  const GrayShimmer({
    this.milliseconds = 1000,
    this.enableShimmer = true,
    this.baseOpacity = 0.9,
    this.highlightOpacity = 0.5,
    this.baseShade = 300,
    this.highlightShade = 200,
    this.ignorePointer = false,
    required this.child,
    super.key,
  });

  final int milliseconds;
  final bool enableShimmer, ignorePointer;
  final Widget child;
  final double baseOpacity;
  final double highlightOpacity;
  final int baseShade;
  final int highlightShade;

  Widget transition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = !enableShimmer
        ? this.child
        : shimmer.Shimmer.fromColors(
            baseColor: Colors.grey[baseShade]!.withOpacity(baseOpacity),
            highlightColor:
                Colors.grey[highlightShade]!.withOpacity(highlightOpacity),
            period: Duration(milliseconds: milliseconds),
            child: this.child,
          );

    return IgnorePointer(
      ignoring: ignorePointer,
      child: AnimatedSwitcher(
        duration: PEffects.shortDuration,
        transitionBuilder: transition,
        child: child,
      ),
    );
  }
}

class RainbowShimmer extends StatelessWidget {
  const RainbowShimmer({
    this.milliseconds = 1000,
    this.enableShimmer = true,
    required this.child,
    super.key,
  });

  final int milliseconds;
  final bool enableShimmer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: PEffects.shortDuration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: enableShimmer
          ? shimmer.Shimmer(
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.red,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                  Colors.blue,
                ],
              ),
              period: Duration(milliseconds: milliseconds),
              child: child,
            )
          : child,
    );
  }
}

class ContainerShimmer extends StatelessWidget {
  const ContainerShimmer({
    this.height = 75,
    this.width = double.infinity,
    this.enableShimmer = true,
    this.milliseconds = 1000,
    this.margin = const EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    this.radius = 20.0,
    super.key,
  });

  final double height;
  final double width;
  final double radius;
  final bool enableShimmer;
  final int milliseconds;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final container = Container(
      height: height,
      margin: margin,
      decoration: ShapeDecoration(
        color: theme.inverseNeutral,
        shape: PContinuousRectangleBorder(
          cornerRadius: radius,
        ),
      ),
    );

    if (!enableShimmer) {
      return container;
    }

    return GrayShimmer(
      baseOpacity: 0.6,
      highlightOpacity: 0.45,
      enableShimmer: enableShimmer,
      milliseconds: milliseconds,
      child: container,
    );
  }
}

class ContainerFadeShimmer extends StatelessWidget {
  const ContainerFadeShimmer({
    this.height = 75,
    this.width = double.infinity,
    this.enableShimmer = true,
    this.duration = const Duration(milliseconds: 1500),
    this.initialDelay = Duration.zero,
    this.periodicDelay = Duration.zero,
    this.margin = const EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    this.radius = 20.0,
    super.key,
  });

  final double height;
  final double width;
  final double radius;
  final bool enableShimmer;
  final Duration duration, periodicDelay, initialDelay;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final container = Container(
      height: height,
      margin: margin,
      decoration: ShapeDecoration(
        color: theme.grayNoOpacity,
        shape: PContinuousRectangleBorder(
          cornerRadius: radius,
        ),
      ),
    );

    if (!enableShimmer) {
      return container;
    }

    return FadeShimmer(
      enabled: enableShimmer,
      duration: duration,
      periodicDelay: periodicDelay,
      initialDelay: initialDelay,
      child: container,
    );
  }
}

class FadeShimmer extends StatefulWidget {
  const FadeShimmer({
    this.enabled = true,
    this.loop = 0,
    this.duration = const Duration(milliseconds: 1500),
    this.periodicDelay = Duration.zero,
    this.initialDelay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.reverseCurve,
    required this.child,
    super.key,
  });

  final bool enabled;
  final int loop;
  final Duration duration;
  final Duration periodicDelay, initialDelay;
  final Curve curve;
  final Curve? reverseCurve;
  final Widget child;

  @override
  State<FadeShimmer> createState() => _FadeShimmerState();
}

class _FadeShimmerState extends State<FadeShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve ?? widget.curve.flipped,
      ),
    );

    _controller.addStatusListener(_handleAnimationStatus);

    if (widget.enabled) {
      Future.delayed(widget.initialDelay, _startAnimation);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _count++;
      if (widget.loop <= 0 || _count < widget.loop) {
        _startAnimation();
      }
    }
  }

  void _startAnimation() {
    Future.delayed(widget.periodicDelay, () {
      if (mounted && widget.enabled) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(FadeShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _startAnimation();
      } else {
        _controller.stop();
      }
    }

    if (widget.loop != oldWidget.loop) {
      _count = 0;
    }

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.curve != oldWidget.curve ||
        widget.reverseCurve != oldWidget.reverseCurve) {
      _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: widget.curve,
          reverseCurve: widget.reverseCurve ?? widget.curve.flipped,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
