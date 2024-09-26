part of '../home_page.dart';

class _Ticket extends StatelessWidget {
  const _Ticket();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) => ValueNotifier<Offset>(Offset.zero),
      builder: (context, _) {
        final notifier = context.watch<ValueNotifier<Offset>>();
        final offsetDelta = notifier.value;
        final blurDelta = offsetDelta.distance;
        final container = Container(
            decoration: ShapeDecoration(
              shape: const TicketShapeBorder(),
              color: theme.resolveColor(PColors.offWhite, PColors.dark.shade20),
              shadows: PDecors.mediumShadows(
                offsetDelta: notifier.value,
                blurDelta: blurDelta,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            // padding: k16APadding,
            width: 500.0,
            child: const Column(
              children: [
                _QatarLogo(),
                Gap(32.0),
                _DepartureLine(),
                Gap(8.0),
                _Airports(),
                Gap(4.0),
                _Cities(),
                Gap(24.0),
                _Dates(),
                Gap(16.0),
                _Bottom(),
              ],
            ),
          );
          return container;
        // return Tilt(
        //   lightConfig: const LightConfig(disable: true),
        //   shadowConfig: const ShadowConfig(disable: true),
        //   borderRadius: BorderRadius.circular(16.0),
        //   clipBehavior: Clip.none,
        //   onGestureMove: (data, _) {
        //     notifier.value = data.angle / 2;
        //   },
        //   onGestureLeave: (data, _) {
        //     notifier.value = Offset.zero;
        //   },
        //   child: container ,
        // );
      },
    );
  }
}

class _Bottom extends StatefulWidget {
  const _Bottom();

  @override
  State<_Bottom> createState() => _BottomState();
}

class _BottomState extends State<_Bottom> {
  var _duration = 26 * 60 * 60 + 15 * 60;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      maybeSetState(() {
        _duration -= 1;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lightGray = PColors.gray.resolveFrom(context);
    final hours = _duration ~/ 3600;
    final minutes = (_duration ~/ 60) % 60;
    final seconds = _duration % 60;

    return Container(
      color: lightGray,
      height: 48.0,
      child: Row(
        children: [
          const Gap(8.0),
          _Counter(hours),
          const Gap(4.0),
          _Counter(minutes),
          const Gap(4.0),
          _Counter(seconds),
          const Gap(4.0),
          Text(
            'until promised land',
            style: theme.textTheme.labelMedium?.copyWith(
              color: PColors.textGray.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelLarge
        ?.enableFeatures(['calt', 'zero', 'tnum']).apply(fontSizeFactor: 1.1);

    return Container(
      decoration: ShapeDecoration(
        shape: PDecors.border8,
        color: PColors.gray.resolveFrom(context),
      ),
      padding: k8HPadding + k4VPadding,
      child: NumericCounter(
        textScaler: TextScaler.noScaling,
        leadingZeros: count < 10 ? 1 : 0,
        count: count,
        style: style,
      ),
    );
  }
}

class _Dates extends StatelessWidget {
  const _Dates();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '17 JAN 2021',
          style: theme.textTheme.labelMedium,
        ),
        const Gap(6.0),
        const Circle(),
        const Gap(4.0),
        Text(
          'ONE-WAY',
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _Cities extends StatelessWidget {
  const _Cities();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Gap(32.0),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hanoi ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: PColors.textGray.resolveFrom(context),
                ),
              ),
              TextSpan(
                text: '10:10',
                style: theme.textTheme.labelLarge
                    ?.enableFeatures(['calt', 'zero']),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Washington, D.C. ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: PColors.textGray.resolveFrom(context),
                ),
              ),
              TextSpan(
                text: '14:15',
                style: theme.textTheme.labelLarge?.enableFeature('calt'),
              ),
              TextSpan(
                text: '\u207A1',
                style: theme.textTheme.labelLarge?.enableFeature('sups'),
              ),
            ],
          ),
        ),
        const Gap(32.0),
      ],
    );
  }
}

class _Airports extends StatelessWidget {
  const _Airports();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orange = CupertinoColors.activeOrange.resolveFrom(context);

    return Row(
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
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  duration: 2000.milliseconds,
                  color: Colors.white,
                )
                .expand(),
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
    );
  }
}

class _DepartureLine extends StatelessWidget {
  const _DepartureLine();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(32.0),
        Text(
          'Departure'.toUpperCase(),
          style: theme.textTheme.labelSmall,
        ),
        const Spacer(),
        Text(
          'STOP: DOH'.toUpperCase(),
          style: theme.textTheme.labelSmall?.enableFeature('calt'),
        ),
        const Spacer(),
        Text(
          'Arrival'.toUpperCase(),
          style: theme.textTheme.labelSmall,
        ),
        const Gap(32.0),
      ],
    );
  }
}

class _QatarLogo extends StatelessWidget {
  const _QatarLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        // gradient: RadialGradient(
        //   colors: [
        //     const Color(0xff64013D).tint90,
        //     const Color(0xff64013D),
        //   ],
        //   // stops: const [0.0, 0.6],
        //   radius: 3.0,
        //   center: AlignmentDirectional.centerStart,
        // ),
        color: theme.resolveColor(PColors.offWhite, PColors.dark9),
      ),
      child: Row(
        children: [
          const Gap(16.0),
          Image.asset(
            UiAsset.qatarAirwaysLogo.path,
            height: 26.0,
          ),
          const Spacer(),
          Text(
            'QR707-QR977',
            style: theme.textTheme.headlineSmall
                ?.copyWith(
              color: const Color(0xff64013D),
            )
                .enableFeatures(['zero', 'calt', 'ss01']),
          ),
          const Gap(16.0),
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
