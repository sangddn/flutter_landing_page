import 'package:flutter/material.dart';

class CloudShapeBorder extends ShapeBorder {
  const CloudShapeBorder({this.side = BorderSide.none});
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _generateCloudPath(rect);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) {
      return getOuterPath(rect, textDirection: textDirection);
    }
    return _generateCloudPath(rect.deflate(side.width));
  }

  Path _generateCloudPath(Rect rect) {
    final width = rect.width;
    final height = rect.height;

    final path = Path();
    final topLeft = Offset(rect.left, rect.top + height * 0.6);
    final topRight = Offset(rect.right, rect.top + height * 0.6);
    final bottomLeft = Offset(rect.left, rect.bottom);
    final bottomRight = Offset(rect.right, rect.bottom);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.cubicTo(
      rect.left - width * 0.1, rect.top + height * 0.3, // Control point 1
      rect.right + width * 0.1, rect.top + height * 0.3, // Control point 2
      topRight.dx, topRight.dy, // Endpoint
    );
    path.arcToPoint(
      bottomRight,
      radius: Radius.circular(width * 0.2),
      clockwise: false,
    );
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.arcToPoint(
      topLeft,
      radius: Radius.circular(width * 0.2),
      clockwise: false,
    );
    path.close();

    return path;
  }

  @override
  ShapeBorder scale(double t) => CloudShapeBorder(side: side.scale(t));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.solid) {
      final path = getOuterPath(rect, textDirection: textDirection);
      final paint = Paint()
        ..color = side.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = side.width;
      canvas.drawPath(path, paint);
    }
  }
}
