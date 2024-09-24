import 'dart:math' as math;

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.color,
    this.size = 24.0,
    this.value,
    this.strokeWidth,
    super.key,
  });

  final Color? color;
  final double size;
  final double? strokeWidth;

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  ///
  final double? value;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return RepaintBoundary(
      child: DiscreteCircle(
        color: color,
        secondCircleColor: color.withOpacity(0.8),
        thirdCircleColor: color.withOpacity(0.6),
        size: size,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class WideLoadingIndicator extends StatefulWidget {
  const WideLoadingIndicator({
    this.width,
    this.dotSize = 8.0,
    this.color,
    this.offsetFactor = 1 / 4,
    super.key,
  });

  final double? width;
  final double dotSize;
  final double offsetFactor;
  final Color? color;

  @override
  State<WideLoadingIndicator> createState() => _WideLoadingIndicatorState();
}

class _WideLoadingIndicatorState extends State<WideLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get size => widget.width ?? (IconTheme.of(context).size ?? 24.0) * 1.5;
  Color get color => widget.color ?? Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBottomDot({required double begin, required double end}) {
    final double offset = -size * widget.offsetFactor;
    return _Dot(
      controller: _controller,
      color: color,
      size: widget.dotSize,
      begin: Offset.zero,
      end: Offset(0.0, offset),
      interval: Interval(begin, end),
    );
  }

  Widget _buildTopDot({required double begin, required double end}) {
    final double offset = -size * widget.offsetFactor;
    return _Dot(
      controller: _controller,
      color: color,
      size: widget.dotSize,
      begin: Offset(0.0, offset),
      end: Offset.zero,
      interval: Interval(begin, end),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (_controller.value <= 0.50)
                    _buildBottomDot(begin: 0.12, end: 0.50)
                  else
                    _buildTopDot(begin: 0.62, end: 1.0),
                  if (_controller.value <= 0.44)
                    _buildBottomDot(begin: 0.06, end: 0.44)
                  else
                    _buildTopDot(begin: 0.56, end: 0.94),
                  if (_controller.value <= 0.38)
                    _buildBottomDot(begin: 0.0, end: 0.38)
                  else
                    _buildTopDot(begin: 0.50, end: 0.88),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.controller,
    required this.color,
    required this.size,
    required this.begin,
    required this.end,
    required this.interval,
  });

  final AnimationController controller;
  final Color color;
  final double size;
  final Offset begin;
  final Offset end;
  final Interval interval;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Tween<Offset>(begin: begin, end: end)
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: interval,
            ),
          )
          .value,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

class DiscreteCircle extends StatefulWidget {
  const DiscreteCircle({
    super.key,
    required this.color,
    required this.size,
    this.strokeWidth,
    required this.secondCircleColor,
    required this.thirdCircleColor,
  });

  final double size;
  final double? strokeWidth;
  final Color color;
  final Color secondCircleColor;
  final Color thirdCircleColor;

  @override
  State<DiscreteCircle> createState() => _DiscreteCircleState();
}

class _DiscreteCircleState extends State<DiscreteCircle>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  @override
  void initState() {
    super.initState();
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color;
    final double size = widget.size;
    final double strokeWidth = widget.strokeWidth ?? size / 8;
    final Color secondRingColor = widget.secondCircleColor;
    final Color thirdRingColor = widget.thirdCircleColor;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        return Stack(
          children: <Widget>[
            Transform.rotate(
              angle: Tween<double>(begin: 0, end: 2 * math.pi)
                  .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(
                        0.68,
                        0.95,
                        curve: Curves.easeOut,
                      ),
                    ),
                  )
                  .value,
              child: Visibility(
                visible: _animationController.value >= 0.5,
                child: Arc.draw(
                  color: thirdRingColor,
                  size: size,
                  strokeWidth: strokeWidth,
                  startAngle: -math.pi / 2,
                  endAngle: Tween<double>(
                    begin: math.pi / 2,
                    end: math.pi / (size * size),
                  )
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(
                            0.7,
                            0.95,
                            curve: Curves.easeOutSine,
                          ),
                        ),
                      )
                      .value,
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value >= 0.5,
              child: Arc.draw(
                color: secondRingColor,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                endAngle: Tween<double>(
                  begin: -2 * math.pi,
                  end: math.pi / (size * size),
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.6,
                          0.95,
                          // curve: Curves.easeIn,
                          curve: Curves.easeOutSine,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
            Visibility(
              visible: _animationController.value <= 0.5,
              // visible: true,
              child: Transform.rotate(
                angle: Tween<double>(begin: 0, end: math.pi * 0.06)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.48,
                          0.5,
                        ),
                      ),
                    )
                    .value,
                child: Arc.draw(
                  color: color,
                  size: size,
                  strokeWidth: strokeWidth,
                  startAngle: -math.pi / 2,
                  // endAngle: 1.94 * math.pi,
                  endAngle: Tween<double>(
                    begin: math.pi / (size * size),
                    end: 1.94 * math.pi,
                  )
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(
                            0.05,
                            0.48,
                            curve: Curves.easeOutSine,
                          ),
                        ),
                      )
                      .value,
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value >= 0.5,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: -1.94 * math.pi
                endAngle: Tween<double>(
                  // begin: -2 * math.pi,
                  begin: -1.94 * math.pi,
                  end: math.pi / (size * size),
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.5,
                          0.95,
                          curve: Curves.easeOutSine,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Arc extends CustomPainter {
  Arc._(
    this._color,
    this._strokeWidth,
    this._startAngle,
    this._sweepAngle,
  );

  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
    required double startAngle,
    required double endAngle,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Arc._(
            color,
            strokeWidth,
            startAngle,
            endAngle,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
