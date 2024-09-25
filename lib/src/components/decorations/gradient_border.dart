import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GradientBoxBorder extends BoxBorder {
  const GradientBoxBorder({required this.gradient, this.width = 1.0});

  final Gradient gradient;

  final double width;

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    switch (shape) {
      case BoxShape.circle:
        assert(
          borderRadius == null,
          'A borderRadius can only be given for rectangular boxes.',
        );
        _paintCircle(canvas, rect);
      case BoxShape.rectangle:
        if (borderRadius != null) {
          _paintRRect(canvas, rect, borderRadius);
          return;
        }
        _paintRect(canvas, rect);
    }
  }

  void _paintRect(Canvas canvas, Rect rect) {
    canvas.drawRect(rect.deflate(width / 2), _getPaint(rect));
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final rrect = borderRadius.toRRect(rect).deflate(width / 2);
    canvas.drawRRect(rrect, _getPaint(rect));
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final paint = _getPaint(rect);
    final radius = (rect.shortestSide - width) / 2.0;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  Paint _getPaint(Rect rect) {
    return Paint()
      ..strokeWidth = width
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;
  }
}

@immutable
class GradientSquircleBorder extends ShapeBorder {
  const GradientSquircleBorder({
    required this.gradient,
    this.width = 1.0,
    this.borderRadius = BorderRadius.zero,
  });

  final Gradient gradient;
  final double width;
  final BorderRadiusGeometry borderRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  ShapeBorder scale(double t) {
    return GradientSquircleBorder(
      gradient: gradient,
      width: width * t,
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientSquircleBorder) {
      return GradientSquircleBorder(
        gradient: Gradient.lerp(a.gradient, gradient, t)!,
        width: lerpDouble(a.width, width, t)!,
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientSquircleBorder) {
      return GradientSquircleBorder(
        gradient: Gradient.lerp(gradient, b.gradient, t)!,
        width: lerpDouble(width, b.width, t)!,
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  Path _getSquirclePath(Rect rect) {
    final RRect rrect = borderRadius.resolve(null).toRRect(rect);

    late double limitedRadius;
    final double width = rrect.width;
    final double height = rrect.height;
    final double centerX = rrect.center.dx;
    final double centerY = rrect.center.dy;

    final double tlRadiusX = math.max(0.0, rrect.tlRadiusX);
    final double tlRadiusY = math.max(0.0, rrect.tlRadiusY);
    final double tlRadius = math.min(tlRadiusX, tlRadiusY);
    final double trRadiusX = math.max(0.0, rrect.trRadiusX);
    final double trRadiusY = math.max(0.0, rrect.trRadiusY);
    final double trRadius = math.min(trRadiusX, trRadiusY);
    final double blRadiusX = math.max(0.0, rrect.blRadiusX);
    final double blRadiusY = math.max(0.0, rrect.blRadiusY);
    final double blRadius = math.min(blRadiusX, blRadiusY);
    final double brRadiusX = math.max(0.0, rrect.brRadiusX);
    final double brRadiusY = math.max(0.0, rrect.brRadiusY);
    final double brRadius = math.min(brRadiusX, brRadiusY);

    final double minSideLength = math.min(rrect.width, rrect.height);

    double largestRadius = math.max(tlRadius, trRadius);
    largestRadius = math.max(largestRadius, blRadius);
    largestRadius = math.max(largestRadius, brRadius);

    const double maxStadiumRatio = 0.65;
    limitedRadius =
        math.min(largestRadius, minSideLength / 2 * maxStadiumRatio);

    Path bezierRoundedRect() {
      double leftX(double x) => centerX + x * limitedRadius - width / 2;
      double rightX(double x) => centerX - x * limitedRadius + width / 2;
      double topY(double y) => centerY + y * limitedRadius - height / 2;
      double bottomY(double y) => centerY - y * limitedRadius + height / 2;

      return Path()
        ..moveTo(leftX(1.52866483), topY(0.0))
        ..lineTo(rightX(1.52866471), topY(0.0))
        ..cubicTo(
          rightX(1.08849323),
          topY(0.0),
          rightX(0.86840689),
          topY(0.0),
          rightX(0.66993427),
          topY(0.06549600),
        )
        ..lineTo(rightX(0.63149399), topY(0.07491100))
        ..cubicTo(
          rightX(0.37282392),
          topY(0.16905899),
          rightX(0.16906013),
          topY(0.37282401),
          rightX(0.07491176),
          topY(0.63149399),
        )
        ..cubicTo(
          rightX(0),
          topY(0.86840701),
          rightX(0.0),
          topY(1.08849299),
          rightX(0.0),
          topY(1.52866483),
        )
        ..lineTo(rightX(0.0), bottomY(1.52866471))
        ..cubicTo(
          rightX(0.0),
          bottomY(1.08849323),
          rightX(0.0),
          bottomY(0.86840689),
          rightX(0.06549600),
          bottomY(0.66993427),
        )
        ..lineTo(rightX(0.07491100), bottomY(0.63149399))
        ..cubicTo(
          rightX(0.16905899),
          bottomY(0.37282392),
          rightX(0.37282401),
          bottomY(0.16906013),
          rightX(0.63149399),
          bottomY(0.07491176),
        )
        ..cubicTo(
          rightX(0.86840701),
          bottomY(0),
          rightX(1.08849299),
          bottomY(0.0),
          rightX(1.52866483),
          bottomY(0.0),
        )
        ..lineTo(leftX(1.52866483), bottomY(0.0))
        ..cubicTo(
          leftX(1.08849323),
          bottomY(0.0),
          leftX(0.86840689),
          bottomY(0.0),
          leftX(0.66993427),
          bottomY(0.06549600),
        )
        ..lineTo(leftX(0.63149399), bottomY(0.07491100))
        ..cubicTo(
          leftX(0.37282392),
          bottomY(0.16905899),
          leftX(0.16906013),
          bottomY(0.37282401),
          leftX(0.07491176),
          bottomY(0.63149399),
        )
        ..cubicTo(
          leftX(0),
          bottomY(0.86840701),
          leftX(0.0),
          bottomY(1.08849299),
          leftX(0.0),
          bottomY(1.52866483),
        )
        ..lineTo(leftX(0.0), topY(1.52866471))
        ..cubicTo(
          leftX(0.0),
          topY(1.08849323),
          leftX(0.0),
          topY(0.86840689),
          leftX(0.06549600),
          topY(0.66993427),
        )
        ..lineTo(leftX(0.07491100), topY(0.63149399))
        ..cubicTo(
          leftX(0.16905899),
          topY(0.37282392),
          leftX(0.37282401),
          topY(0.16906013),
          leftX(0.63149399),
          topY(0.07491176),
        )
        ..cubicTo(
          leftX(0.86840701),
          topY(0),
          leftX(1.08849299),
          topY(0.0),
          leftX(1.52866483),
          topY(0.0),
        )
        ..close();
    }

    return bezierRoundedRect();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getSquirclePath(rect.deflate(width / 2));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getSquirclePath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..strokeWidth = width
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;

    final path = _getSquirclePath(rect.deflate(width / 2));
    canvas.drawPath(path, paint);
  }

  GradientSquircleBorder copyWith({
    Gradient? gradient,
    double? width,
    BorderRadiusGeometry? borderRadius,
  }) {
    return GradientSquircleBorder(
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! GradientSquircleBorder) {
      return false;
    }
    return other.gradient == gradient &&
        other.width == width &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(gradient, width, borderRadius);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'GradientSquircleBorder')}($gradient, $width, $borderRadius)';
  }
}

class GradientSquircleStadiumBorder extends ShapeBorder {
  const GradientSquircleStadiumBorder({
    required this.gradient,
    this.width = 1.0,
  });

  final Gradient gradient;
  final double width;

  Path _getPath(Rect rect) {
    final double actualSideWidth =
        math.min(this.width, math.min(rect.width, rect.height) / 2.0);

    const double totalAffectedCornerPixelRatio = 1.52865;
    const double minimalUnclippedSideToCornerRadiusRatio =
        2.0 * totalAffectedCornerPixelRatio;
    const double minimalEdgeLengthSideToCornerRadiusRatio =
        1.0 / minimalUnclippedSideToCornerRadiusRatio;
    const double maxEdgeLengthAspectRatio = 0.79;

    final double rectWidth = rect.width;
    final double rectHeight = rect.height;
    final bool widthLessThanHeight = rectWidth < rectHeight;
    final double width = widthLessThanHeight
        ? rectWidth.clamp(
            0.0,
            maxEdgeLengthAspectRatio * (rectHeight + actualSideWidth) -
                actualSideWidth,
          )
        : rectWidth;
    final double height = widthLessThanHeight
        ? rectHeight
        : rectHeight.clamp(
            0.0,
            maxEdgeLengthAspectRatio * (rectWidth + actualSideWidth) -
                actualSideWidth,
          );

    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;
    final double originX = centerX - width / 2.0;
    final double originY = centerY - height / 2.0;
    final double minDimension = math.min(width, height);
    final double radius =
        minDimension * minimalEdgeLengthSideToCornerRadiusRatio;

    double leftX(double x) => centerX + x * radius - width / 2;
    double rightX(double x) => centerX - x * radius + width / 2;
    double topY(double y) => centerY + y * radius - height / 2;
    double bottomY(double y) => centerY - y * radius + height / 2;
    double bottomMidY(double y) => originY + height - y * radius;
    double leftMidX(double x) => originX + x * height;
    double rightMidX(double x) => originX + width - x * radius;

    Path bezierStadiumHorizontal() {
      return Path()
        ..moveTo(leftX(2.00593972), topY(0.0))
        ..lineTo(originX + width - 1.52866483 * radius, originY)
        ..cubicTo(
          rightX(1.63527834),
          topY(0.0),
          rightX(1.29884040),
          topY(0.0),
          rightX(0.99544263),
          topY(0.10012127),
        )
        ..lineTo(rightX(0.93667978), topY(0.11451437))
        ..cubicTo(
          rightX(0.37430558),
          topY(0.31920183),
          rightX(0.00000051),
          topY(0.85376567),
          rightX(0.00000051),
          topY(1.45223188),
        )
        ..cubicTo(
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
        )
        ..lineTo(rightMidX(0.0), centerY)
        ..cubicTo(
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
          rightMidX(0.0),
          centerY,
        )
        ..lineTo(rightX(0.0), bottomY(1.45223165))
        ..cubicTo(
          rightX(0.0),
          bottomY(0.85376561),
          rightX(0.37430558),
          bottomY(0.31920174),
          rightX(0.93667978),
          bottomY(0.11451438),
        )
        ..cubicTo(
          rightX(1.29884040),
          bottomY(0.0),
          rightX(1.63527834),
          bottomY(0.0),
          rightX(2.30815363),
          bottomY(0.0),
        )
        ..lineTo(originX + 1.52866483 * radius, originY + height)
        ..cubicTo(
          leftX(1.63527822),
          bottomY(0.0),
          leftX(1.29884040),
          bottomY(0.0),
          leftX(0.99544257),
          bottomY(0.10012124),
        )
        ..lineTo(leftX(0.93667972), bottomY(0.11451438))
        ..cubicTo(
          leftX(0.37430549),
          bottomY(0.31920174),
          leftX(-0.00000007),
          bottomY(0.85376561),
          leftX(-0.00000001),
          bottomY(1.45223176),
        )
        ..cubicTo(
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
        )
        ..lineTo(leftMidX(0.0), centerY)
        ..cubicTo(
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
          leftMidX(0.0),
          centerY,
        )
        ..lineTo(leftX(-0.00000001), topY(1.45223153))
        ..cubicTo(
          leftX(0.00000004),
          topY(0.85376537),
          leftX(0.37430561),
          topY(0.31920177),
          leftX(0.93667978),
          topY(0.11451436),
        )
        ..cubicTo(
          leftX(1.29884040),
          topY(0.0),
          leftX(1.63527822),
          topY(0.0),
          leftX(2.30815363),
          topY(0.0),
        )
        ..lineTo(leftX(2.00593972), topY(0.0))
        ..close();
    }

    Path bezierStadiumVertical() {
      return Path()
        ..moveTo(centerX, topY(0.0))
        ..lineTo(centerX, topY(0.0))
        ..cubicTo(centerX, topY(0.0), centerX, topY(0.0), centerX, topY(0.0))
        ..lineTo(rightX(1.45223153), topY(0.0))
        ..cubicTo(
          rightX(0.85376573),
          topY(0.00000001),
          rightX(0.31920189),
          topY(0.37430537),
          rightX(0.11451442),
          topY(0.93667936),
        )
        ..cubicTo(
          rightX(0.0),
          topY(1.29884040),
          rightX(0.0),
          topY(1.63527822),
          rightX(0.0),
          topY(2.30815387),
        )
        ..lineTo(
          rect.left + rect.width,
          rect.top + rect.height - 1.52866483 * radius,
        )
        ..cubicTo(
          rightX(0.0),
          bottomY(1.63527822),
          rightX(0.0),
          bottomY(1.29884028),
          rightX(0.10012137),
          bottomY(0.99544269),
        )
        ..lineTo(rightX(0.11451442), bottomY(0.93667972))
        ..cubicTo(
          rightX(0.31920189),
          bottomY(0.37430552),
          rightX(0.85376549),
          bottomY(0.0),
          rightX(1.45223165),
          bottomY(0.0),
        )
        ..cubicTo(
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
        )
        ..lineTo(centerX, bottomMidY(0.0))
        ..cubicTo(
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
          centerX,
          bottomMidY(0.0),
        )
        ..lineTo(leftX(1.45223141), bottomY(0.0))
        ..cubicTo(
          leftX(0.85376543),
          bottomY(0.0),
          leftX(0.31920180),
          bottomY(0.37430552),
          leftX(0.11451442),
          bottomY(0.93667972),
        )
        ..cubicTo(
          leftX(0.0),
          bottomY(1.29884028),
          leftX(0.0),
          bottomY(1.63527822),
          leftX(0.0),
          bottomY(2.30815387),
        )
        ..lineTo(rect.left, rect.top + 1.52866483 * radius)
        ..cubicTo(
          leftX(0.0),
          topY(1.63527822),
          leftX(0.0),
          topY(1.29884028),
          leftX(0.10012137),
          topY(0.99544269),
        )
        ..lineTo(leftX(0.11451442), topY(0.93667936))
        ..cubicTo(
          leftX(0.31920189),
          topY(0.37430537),
          leftX(0.85376543),
          topY(0.0),
          leftX(1.45223141),
          topY(0.0),
        )
        ..lineTo(centerX, topY(0.0))
        ..close();
    }

    return widthLessThanHeight
        ? bezierStadiumVertical()
        : bezierStadiumHorizontal();
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  ShapeBorder scale(double t) => GradientSquircleStadiumBorder(
        gradient: gradient,
        width: width * t,
      );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect.deflate(width / 2.0));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect.inflate(width / 2.0));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final Path path = _getPath(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool get preferPaintInterior => false;
}
