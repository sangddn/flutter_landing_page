part of '../home_page.dart';

class _Ticket extends StatelessWidget {
  const _Ticket();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gray = PColors.gray.resolveFrom(context);
    final orange = CupertinoColors.activeOrange.resolveFrom(context);

    return Container(
      decoration: ShapeDecoration(
        shape: const TicketShapeBorder(),
        color: theme.neutral,
        shadows: PDecors.mediumShadows(),
      ),
      clipBehavior: Clip.antiAlias,
      // padding: k16APadding,
      width: 500.0,

      child: Column(
        children: [
          Container(
            color: gray,
            height: 32.0,
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Departure',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Arrival',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Gap(8.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(32.0),
              Row(
                children: [
                  Text(
                    'HAN',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const Gap(8.0),
                  Icon(
                    CupertinoIcons.arrow_up_right_circle_fill,
                    size: 24.0,
                    color: orange,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      shape: const SquircleStadiumBorder(),
                      color: orange,
                    ),
                    height: 3.0,
                  ).expand(),
                ],
              ).expand(),
              const Icon(
                CupertinoIcons.airplane,
                size: 28.0,
              ),
              Row(
                children: [
                  DottedLine(
                    lineThickness: 2.5,
                    dashRadius: 10.0,
                    dashLength: 6.0,
                    dashColor: orange,
                  ).expand(),
                  Icon(
                    CupertinoIcons.arrow_down_right_circle_fill,
                    size: 24.0,
                    color: orange,
                  ),
                  const Gap(8.0),
                  Text(
                    'IAD',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ],
              ).expand(),
              const Gap(32.0),
            ],
          ),
          Row(
            children: [
              const Gap(32.0),
              Text(
                'Hanoi',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: PColors.textGray.resolveFrom(context),
                ),
              ),
              const Spacer(),
              Text(
                'Washington, D.C.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: PColors.textGray.resolveFrom(context),
                ),
              ),
              const Gap(32.0),
            ],
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Date: 2024-12-25',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'PNR: ABC123',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Gap(16.0),
          Container(
            color: gray,
            height: 32.0,
          ),
        ],
      ),
    );
  }
}

/// A custom ShapeBorder that represents a ticket with rounded corners
/// and semicircular notches on both shorter sides.
class TicketShapeBorder extends ShapeBorder {
  /// Creates a TicketShapeBorder.
  ///
  /// [borderRadius] controls the roundness of the ticket's corners.
  /// [notchRadius] controls the size of the semicircular notches on the sides.
  /// [borderSide] defines the border's properties.
  ///
  const TicketShapeBorder({
    this.borderRadius = 16.0,
    this.notchRadius = 10.0,
    this.borderSide = BorderSide.none,
  });
  final double borderRadius;
  final double notchRadius;
  final BorderSide borderSide;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  /// Defines the outer path of the ticket shape.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildTicketPath(rect);
  }

  /// Defines the inner path of the ticket shape, offset by the border width.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // Calculate the inset based on the border width
    final double inset = borderSide.width;

    // Define the inner rectangle by insetting the outer rectangle
    final Rect innerRect = rect.deflate(inset);

    return _buildTicketPath(innerRect);
  }

  /// Helper method to build the ticket-shaped Path within the given Rect.
  Path _buildTicketPath(Rect rect) {
    final Path path = Path();

    final double width = rect.width;
    final double height = rect.height;

    // Define centers for the notches
    final Offset leftNotchCenter = Offset(rect.left, rect.top + height / 2);
    final Offset rightNotchCenter = Offset(rect.right, rect.top + height / 2);

    // Start at top-left corner
    path.moveTo(rect.left + borderRadius, rect.top);

    // Top edge
    path.lineTo(rect.right - borderRadius, rect.top);
    // Top-right corner
    path.quadraticBezierTo(
      rect.right,
      rect.top,
      rect.right,
      rect.top + borderRadius,
    );

    // Right edge before notch
    path.lineTo(rect.right, rightNotchCenter.dy - notchRadius);
    // Right notch (smoothed semicircle)
    path.arcToPoint(
      Offset(rect.right, rightNotchCenter.dy + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge after notch
    path.lineTo(rect.right, rect.bottom - borderRadius);
    // Bottom-right corner
    path.quadraticBezierTo(
      rect.right,
      rect.bottom,
      rect.right - borderRadius,
      rect.bottom,
    );

    // Bottom edge
    path.lineTo(rect.left + borderRadius, rect.bottom);
    // Bottom-left corner
    path.quadraticBezierTo(
      rect.left,
      rect.bottom,
      rect.left,
      rect.bottom - borderRadius,
    );

    // Left edge before notch
    path.lineTo(rect.left, leftNotchCenter.dy + notchRadius);
    // Left notch (smoothed semicircle)
    path.arcToPoint(
      Offset(rect.left, leftNotchCenter.dy - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge after notch
    path.lineTo(rect.left, rect.top + borderRadius);
    // Top-left corner
    path.quadraticBezierTo(
      rect.left,
      rect.top,
      rect.left + borderRadius,
      rect.top,
    );

    path.close();
    return path;
  }

  /// Paints the border around the shape.
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderSide.style == BorderStyle.none || borderSide.width == 0.0) {
      return;
    }

    final Paint paint = borderSide.toPaint();

    final Path outerPath = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(outerPath, paint);
  }

  /// Specifies whether the border should be scaled when the shape is scaled.
  @override
  ShapeBorder scale(double t) {
    return TicketShapeBorder(
      borderRadius: borderRadius * t,
      notchRadius: notchRadius * t,
      borderSide: borderSide.scale(t),
    );
  }

  /// Specifies whether this ShapeBorder is equal to another.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketShapeBorder &&
          runtimeType == other.runtimeType &&
          borderRadius == other.borderRadius &&
          notchRadius == other.notchRadius &&
          borderSide == other.borderSide;

  @override
  int get hashCode =>
      borderRadius.hashCode ^ notchRadius.hashCode ^ borderSide.hashCode;
}

/// Draw a dotted line.
///
/// Basic line settings
/// * [direction]
/// * [alignment]
/// * [lineLength]
/// * [lineThickness]
/// Dash settings
/// * [dashLength]
/// * [dashColor]
/// * [dashGradient]
/// * [dashRadius]
/// Dash gap settings
/// * [dashGapLength]
/// * [dashGapColor]
/// * [dashGapRadius]
/// * [dashGapGradient]
class DottedLine extends StatelessWidget {
  /// Creates dotted line with the given parameters
  const DottedLine({
    super.key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.center,
    this.lineLength = double.infinity,
    this.lineThickness = 1.0,
    this.dashLength = 4.0,
    this.dashColor = Colors.black,
    this.dashGradient,
    this.dashGapLength = 4.0,
    this.dashGapColor = Colors.transparent,
    this.dashGapGradient,
    this.dashRadius = 0.0,
    this.dashGapRadius = 0.0,
  })  : assert(
            dashGradient == null || dashGradient.length == 2,
            'The dashGradient must have only two colors.\n'
            'The beginning color and the ending color of the gradient.'),
        assert(
            dashGapGradient == null || dashGapGradient.length == 2,
            'The dashGapGradient must have only two colors.\n'
            'The beginning color and the ending color of the gradient.');

  /// The direction of the entire dotted line. Default [Axis.horizontal].
  final Axis direction;

  /// The alignment of the entire dotted line. Default [WrapAlignment.center].
  final WrapAlignment alignment;

  /// The length of the entire dotted line. Default [double.infinity].
  final double lineLength;

  /// The thickness of the entire dotted line. Default (1.0).
  final double lineThickness;

  /// The length of the dash. Default (4.0).
  final double dashLength;

  /// The color of the dash. Default [Colors.black].
  ///
  /// This is ignored if [dashGradient] is non-null.
  final Color dashColor;

  /// The gradient colors of the dash. Default null.
  /// The first color is beginning color, the second one is ending color.
  ///
  /// If this is specified, [dashColor] has no effect.
  final List<Color>? dashGradient;

  /// The radius of the dash. Default (0.0).
  final double dashRadius;

  /// The length of the dash gap. Default (4.0).
  final double dashGapLength;

  /// The color of the dash gap. Default [Colors.transparent].
  ///
  /// This is ignored if [dashGapGradient] is non-null.
  final Color dashGapColor;

  /// The gradient colors of the dash gap. Default null.
  /// The first color is beginning color, the second one is ending color.
  ///
  /// If this is specified, [dashGapColor] has no effect.
  final List<Color>? dashGapGradient;

  /// The radius of the dash gap. Default (0.0).
  final double dashGapRadius;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = direction == Axis.horizontal;

    return SizedBox(
      width: isHorizontal ? lineLength : lineThickness,
      height: isHorizontal ? lineThickness : lineLength,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final lineLength = _getLineLength(constraints, isHorizontal);
          final dashAndDashGapCount = _calculateDashAndDashGapCount(lineLength);
          final dashCount = dashAndDashGapCount[0];
          final dashGapCount = dashAndDashGapCount[1];

          return Wrap(
            direction: direction,
            alignment: alignment,
            children: List.generate(dashCount + dashGapCount, (index) {
              if (index % 2 == 0) {
                final dashColor = _getDashColor(dashCount, index ~/ 2);
                final dash = _buildDash(isHorizontal, dashColor);
                return dash;
              } else {
                final dashGapColor = _getDashGapColor(dashGapCount, index ~/ 2);
                final dashGap = _buildDashGap(isHorizontal, dashGapColor);
                return dashGap;
              }
            }).toList(growable: false),
          );
        },
      ),
    );
  }

  /// If [lineLength] is [double.infinity],
  /// get the maximum value of the parent widget.
  /// And if the value is specified, use the specified value.
  double _getLineLength(BoxConstraints constraints, bool isHorizontal) {
    return lineLength == double.infinity
        ? isHorizontal
            ? constraints.maxWidth
            : constraints.maxHeight
        : lineLength;
  }

  /// Calculate the count of (dash + dashGap).
  ///
  /// example1) [lineLength] is 10, [dashLength] is 1, [dashGapLength] is 1.
  /// "- - - - - "
  /// example2) [lineLength] is 10, [dashLength] is 1, [dashGapLength] is 2.
  /// "-  -  -  -"
  List<int> _calculateDashAndDashGapCount(double lineLength) {
    final dashAndDashGapLength = dashLength + dashGapLength;
    var dashCount = lineLength ~/ dashAndDashGapLength;
    final dashGapCount = lineLength ~/ dashAndDashGapLength;
    if (dashLength <= lineLength % dashAndDashGapLength) {
      dashCount += 1;
    }
    return [dashCount, dashGapCount];
  }

  Widget _buildDash(bool isHorizontal, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(dashRadius),
      ),
      width: isHorizontal ? dashLength : lineThickness,
      height: isHorizontal ? lineThickness : dashLength,
    );
  }

  Color _getDashColor(int maxDashCount, int index) {
    return dashGradient == null
        ? dashColor
        : _calculateGradientColor(
            dashGradient![0],
            dashGradient![1],
            maxDashCount,
            index,
          );
  }

  Widget _buildDashGap(bool isHorizontal, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(dashGapRadius),
      ),
      width: isHorizontal ? dashGapLength : lineThickness,
      height: isHorizontal ? lineThickness : dashGapLength,
    );
  }

  Color _getDashGapColor(int maxDashGapCount, int index) {
    return dashGapGradient == null
        ? dashGapColor
        : _calculateGradientColor(
            dashGapGradient![0],
            dashGapGradient![1],
            maxDashGapCount,
            index,
          );
  }

  Color _calculateGradientColor(
    Color startColor,
    Color endColor,
    int maxItemCount,
    int index,
  ) {
    final diffAlpha = endColor.alpha - startColor.alpha;
    final diffRed = endColor.red - startColor.red;
    final diffGreen = endColor.green - startColor.green;
    final diffBlue = endColor.blue - startColor.blue;

    final amountOfChangeInAlphaPerItem = diffAlpha ~/ maxItemCount;
    final amountOfChangeInRedPerItem = diffRed ~/ maxItemCount;
    final amountOfChangeInGreenPerItem = diffGreen ~/ maxItemCount;
    final amountOfChangeInBluePerItem = diffBlue ~/ maxItemCount;

    return startColor
        .withAlpha(startColor.alpha + amountOfChangeInAlphaPerItem * index)
        .withRed(startColor.red + amountOfChangeInRedPerItem * index)
        .withGreen(startColor.green + amountOfChangeInGreenPerItem * index)
        .withBlue(startColor.blue + amountOfChangeInBluePerItem * index);
  }
}
