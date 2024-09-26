part of 'ui.dart';

const k24HPadding = EdgeInsets.symmetric(horizontal: 24.0);
const k16HPadding = EdgeInsets.symmetric(horizontal: 16.0);
const k16H4VPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0);
const k16H8VPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
const k16H12VPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
const k16APadding = EdgeInsets.all(16.0);
const k8APadding = EdgeInsets.all(8.0);
const k12HPadding = EdgeInsets.symmetric(horizontal: 12.0);
const k8HPadding = EdgeInsets.symmetric(horizontal: 8.0);
const k4VPadding = EdgeInsets.symmetric(vertical: 4.0);
const k4HPadding = EdgeInsets.symmetric(horizontal: 4.0);
const k8VPadding = EdgeInsets.symmetric(vertical: 8.0);
const k12VPadding = EdgeInsets.symmetric(vertical: 12.0);
const k16VPadding = EdgeInsets.symmetric(vertical: 16.0);

class PDecors {
  static const border24 = PContinuousRectangleBorder(cornerRadius: 24.0);
  static const border16 = PContinuousRectangleBorder(cornerRadius: 16.0);
  static const border12 = PContinuousRectangleBorder(cornerRadius: 12.0);
  static const border8 = PContinuousRectangleBorder(cornerRadius: 8.0);
  static const border4 = PContinuousRectangleBorder(cornerRadius: 4.0);
  static const borderRadius16 = BorderRadius.all(Radius.circular(16.0));
  static const borderRadius8 = BorderRadius.all(Radius.circular(8.0));

  static Decoration stdCard(
    BuildContext context, {
    Color? color,
    double? opacity,
    double elevation = 1.0,
    BorderSide side = BorderSide.none,
    double cornerRadius = 16.0,
    bool increaseElevationIntensity = false,
  }) {
    final theme = Theme.of(context);
    final baseColor = color ?? theme.colorScheme.surface;
    return ShapeDecoration(
      shape: PContinuousRectangleBorder(cornerRadius: cornerRadius, side: side),
      color: opacity != null ? baseColor.withOpacity(opacity) : baseColor,
      shadows: PDecors.elevation(
        elevation,
        isOuter: opacity != null,
        increaseIntensity: increaseElevationIntensity,
      ),
    );
  }

  static Decoration broadShadowsCard(
    BuildContext context, {
    Color? color,
    double? opacity,
    double cornerRadius = 16.0,
    double elevation = 1.0,
    Color? baseElevationColor,
    BorderSide? side,
  }) {
    final theme = Theme.of(context);

    return ShapeDecoration(
      color: (color ?? theme.colorScheme.surface).withOpacity(opacity ?? 1.0),
      shape: PContinuousRectangleBorder(
        cornerRadius: cornerRadius,
        side: side ??
            BorderSide(
              color: theme.gray,
              width: 0.5,
            ),
      ),
      shadows: PDecors.broadShadows(
        context,
        style: opacity != null ? BlurStyle.outer : BlurStyle.normal,
        elevation: elevation,
        baseColor: baseElevationColor,
      ),
    );
  }

  static List<BoxShadow> elevation(
    double elevation, {
    bool isOuter = false,
    bool increaseIntensity = false,
    Color baseColor = Colors.black,
  }) {
    if (elevation < 0.0) {
      return [];
    }

    return [
      BoxShadow(
        color: baseColor.withOpacity(
          0.08 + (increaseIntensity ? 1.0 : 0.0) * elevation * 0.01,
        ),
        blurRadius: 4.0 + elevation * 2,
        offset: isOuter ? Offset.zero : Offset(0, elevation),
        // spreadRadius: isOuter ? elevation : 0.0,
        blurStyle: isOuter ? BlurStyle.outer : BlurStyle.normal,
      ),
    ];
  }

  static List<BoxShadow> focusedShadows({
    double elevation = 1.0,
    Color baseColor = Colors.black,
    double opacity = 0.06,
    BlurStyle style = BlurStyle.normal,
    Offset offsetDelta = Offset.zero,
    double offsetFactor = 1.0,
  }) =>
      List.generate(
        6,
        (index) {
          final factor = pow(2, index - 2).toDouble() * elevation;
          final blur = switch (index) {
            0 || 1 => index.toDouble(),
            _ => 3 * factor,
          };
          final yOffset = blur;
          final spread = switch (index) {
            0 => 1.0,
            1 => -0.5,
            _ => -1.5 * factor,
          };

          return BoxShadow(
            color: baseColor.withOpacity(opacity),
            blurRadius: blur,
            offset: Offset(0, yOffset) * offsetFactor + offsetDelta,
            spreadRadius: spread,
            blurStyle: style,
          );
        },
      );

  static List<BoxShadow> mediumShadows({
    double elevation = 1.0,
    Color baseColor = Colors.black,
    double opacity = 0.05,
    BlurStyle style = BlurStyle.normal,
    Offset offsetDelta = Offset.zero,
    double offsetFactor = 1.0,
    double spreadFactor = 1.0,
    double spreadDelta = 0.0,
    double blurFactor = 1.0,
    double blurDelta = 0.0,
  }) =>
      elevation <= 0.0
          ? []
          : List.generate(
              6,
              (index) {
                final blur =
                    index == 0 ? 0.0 : pow(2, index - 1).toDouble() * elevation;
                final yOffset = blur;
                final spread = switch (index) {
                  0 => 1.0,
                  _ => 0.0,
                };
                return BoxShadow(
                  color: baseColor.withOpacity(opacity),
                  blurRadius: blur * blurFactor + blurDelta,
                  offset: Offset(0, yOffset) * offsetFactor + offsetDelta,
                  spreadRadius: spread * spreadFactor + spreadDelta,
                  blurStyle: style,
                );
              },
            );

  static List<BoxShadow> broadShadows(
    BuildContext context, {
    double elevation = 1.0,
    Color? baseColor,
    BlurStyle style = BlurStyle.normal,
  }) {
    if (elevation < 0.0) {
      return [];
    }
    final theme = Theme.of(context);
    final Color color = baseColor ??
        theme.resolveColor(
          theme.gray,
          const ui.Color.fromARGB(255, 27, 27, 27),
        );
    return [
      BoxShadow(
        color: color.withOpacityFactor(min(2.0, 0.3 * elevation)),
        blurRadius: 16.0 * elevation,
        blurStyle: style,
      ),
    ];
  }
}
