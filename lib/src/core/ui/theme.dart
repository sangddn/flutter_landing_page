part of 'ui.dart';

final kLightTheme = _baseLightTheme.copyWith(
  cupertinoOverrideTheme: CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      primaryColor: const Color(0xff323232),
      textStyle: _lightTextTheme.bodyMedium,
      actionTextStyle: _lightTextTheme.bodyMedium,
      dateTimePickerTextStyle: _lightTextTheme.bodyMedium,
      navActionTextStyle: _lightTextTheme.bodyMedium,
      navLargeTitleTextStyle: _lightTextTheme.titleLarge,
      navTitleTextStyle: _lightTextTheme.titleMedium,
      pickerTextStyle: _lightTextTheme.bodyMedium,
      tabLabelTextStyle: _lightTextTheme.labelLarge,
    ),
  ),
  applyElevationOverlayColor: false,
  brightness: Brightness.light,
  canvasColor: PColors.offWhite,
  cardColor: Colors.white,
  colorScheme: _lightColorScheme,
  dialogBackgroundColor: const Color(0xfffffefc),
  scaffoldBackgroundColor: PColors.white,
  disabledColor: const Color(0x61000000),
  dividerColor: PColors._grayLightMode,
  focusColor: const Color(0x1f000000),
  highlightColor: PColors._lightGrayLightMode,
  hintColor: const Color(0x99000000),
  hoverColor: const Color(0x0a000000),
  indicatorColor: const Color(0xfffffefc),
  secondaryHeaderColor: const Color(0xffe3f2fd),
  shadowColor: Colors.black,
  splashColor:
      Target.isNativeAndroid ? const Color(0x66c8c8c8) : Colors.transparent,
  splashFactory: InkRipple.splashFactory,
  unselectedWidgetColor: const Color(0x8a000000),
  visualDensity: VisualDensity.compact,
  inputDecorationTheme: _baseLightTheme.inputDecorationTheme.copyWith(
    alignLabelWithHint: true,
    filled: false,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    isCollapsed: false,
    isDense: false,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
  ),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  primaryColor: const Color(0xff323232),
  primaryColorDark: const Color(0xff1976d2),
  primaryColorLight: const Color(0xffbbdefb),
  primaryIconTheme: _baseLightTheme.iconTheme.copyWith(
    color: Colors.white,
  ),
  iconTheme: _baseLightTheme.iconTheme.copyWith(
    color: const Color(0xdd000000),
  ),
  switchTheme: _baseLightTheme.switchTheme.copyWith(
    // ! This is a hack to get the current animation value of [ThemeData]
    // ! to animate custom theme properties like [PColors].
    //
    // See also:
    // * [kDarkTheme.switchTheme.splashRadius], which is set to 1.0.
    // * [ThemeData.interpolationValue], which is set to [switchTheme.splashRadius].
    //
    splashRadius: 0.0,
    thumbColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0x52000000);
        }
        return const Color(0xff323232);
      },
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0x1f000000);
        }
        return const Color(0x52000000);
      },
    ),
  ),
  textTheme: _lightTextTheme,
  appBarTheme: _baseLightTheme.appBarTheme.copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: PColors.white,
  ),
  dividerTheme: _baseLightTheme.dividerTheme.copyWith(
    color: PColors._grayLightMode,
    space: 0.5,
    thickness: 0.5,
  ),
);

final kDarkTheme = _baseDarkTheme.copyWith(
  cupertinoOverrideTheme: CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      primaryColor: const Color(0xfffffefc),
      textStyle: _darkTextTheme.bodyMedium,
      actionTextStyle: _darkTextTheme.bodyMedium,
      dateTimePickerTextStyle: _darkTextTheme.bodyMedium,
      navActionTextStyle: _darkTextTheme.bodyMedium,
      navLargeTitleTextStyle: _darkTextTheme.titleLarge,
      navTitleTextStyle: _darkTextTheme.titleMedium,
      pickerTextStyle: _darkTextTheme.bodyMedium,
      tabLabelTextStyle: _darkTextTheme.labelLarge,
    ),
  ),
  applyElevationOverlayColor: false,
  brightness: Brightness.dark,
  canvasColor: Colors.black,
  cardColor: PColors.dark2,
  colorScheme: _darkColorScheme,
  dialogBackgroundColor: PColors.dark,
  scaffoldBackgroundColor: Colors.black,
  disabledColor: const Color(0x62ffffff),
  dividerColor: PColors._grayDarkMode,
  focusColor: const Color(0x1fffffff),
  highlightColor: PColors._lightGrayDarkMode,
  hintColor: const Color(0x99ffffff),
  hoverColor: const Color.fromARGB(9, 211, 211, 211),
  indicatorColor: const Color(0xffe4e2dd),
  secondaryHeaderColor: const Color(0xff616161),
  shadowColor: Colors.black.withOpacity(0.0),
  splashColor:
      Target.isNativeAndroid ? const Color(0x40cccccc) : Colors.transparent,
  splashFactory: InkRipple.splashFactory,
  unselectedWidgetColor: const Color(0xb3ffffff),
  visualDensity: VisualDensity.compact,
  inputDecorationTheme: _baseDarkTheme.inputDecorationTheme.copyWith(
    alignLabelWithHint: true,
    filled: false,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    isCollapsed: false,
    isDense: false,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
  ),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  primaryColor: PColors.offDark,
  primaryColorDark: Colors.black,
  primaryColorLight: const Color(0xff9e9e9e),
  primaryIconTheme: _baseDarkTheme.iconTheme.copyWith(
    color: Colors.white,
  ),
  iconTheme: _baseDarkTheme.iconTheme.copyWith(
    color: Colors.white,
  ),
  switchTheme: _baseDarkTheme.switchTheme.copyWith(
    // ! This is a hack to get the current animation value of [ThemeData]
    // ! to animate custom theme properties like [PColors].
    //
    // See also:
    // * [kLightTheme.switchTheme.splashRadius], which is set to 0.0.
    // * [ThemeData.interpolationValue], which is set to [switchTheme.splashRadius].
    //
    splashRadius: 1.0,
    thumbColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0x52000000);
        }
        return const Color(0xfffffefc);
      },
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0x1fe4e2dd);
        }
        return const Color(0x52000000);
      },
    ),
  ),
  textTheme: _darkTextTheme,
  appBarTheme: _baseDarkTheme.appBarTheme.copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: Colors.black,
  ),
  dividerTheme: _baseDarkTheme.dividerTheme.copyWith(
    color: PColors._grayDarkMode,
    space: 0.5,
    thickness: 0.5,
  ),
);

final _baseLightTheme = ThemeData.light(useMaterial3: true);
final _baseDarkTheme = ThemeData.dark(useMaterial3: true);

extension BrightnessCheck on Theme {
  bool get isDark => data.isDark;
  bool get isLight => data.isLight;
}

extension BrightnessCheckData on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;

  /// Returns the interpolation value between different [Theme]s when app's
  /// [Theme] animates.
  ///
  /// Returns 0.0 when the theme is light, 1.0 when the theme is dark.
  ///
  /// The app's [Theme] at any point is not only determined by [kLightTheme] or
  /// [kDarkTheme] (or [kLightMacosTheme] or [kDarkMacosTheme] on macOS) but also
  /// by the animation state of [AnimatedTheme], which is not 0.0 or 1.0 when
  /// user is switching between light and dark themes.
  ///
  /// In order to provide a similarly smooth transition for custom defined colors
  /// like "gray" or "lightGray", as in [MoreColors], this method calculates the
  /// current "lerp value" between the light and dark themes, so even custom
  /// colors animates.
  ///
  /// The trick here is to use the [switchTheme.splashRadius] property, which is
  /// a double value that we define to animate between 0.0 and 1.0. This value
  /// is not used anywhere else in the app.
  ///
  double get interpolationValue => switchTheme.splashRadius!;

  double resolveNum<T extends num>(
    T light,
    T dark, {
    ThemeMode mode = ThemeMode.system,
    bool inverse = false,
  }) {
    final a = (inverse ? dark : light).toDouble();
    final b = (inverse ? light : dark).toDouble();
    switch (mode) {
      case ThemeMode.light:
        return a;
      case ThemeMode.dark:
        return b;
      case ThemeMode.system:
        final a = light.toDouble();
        final b = dark.toDouble();
        final t = interpolationValue;
        if (a == b || (a.isNaN) && (b.isNaN)) {
          return a;
        }
        assert(
          a.isFinite,
          'Cannot interpolate between finite and non-finite values',
        );
        assert(
          b.isFinite,
          'Cannot interpolate between finite and non-finite values',
        );
        assert(
          t.isFinite,
          't must be finite when interpolating between values',
        );
        return a * (1.0 - t) + b * t;
    }
  }

  BorderSide resolveBorderSide(BorderSide light, BorderSide dark) {
    return BorderSide.lerp(light, dark, interpolationValue);
  }

  /// Resolves any type [T] between [light] and [dark] based on the current
  /// [Theme.brightness] and an optional [mode].
  ///
  /// Should not be used in favor of type-specific methods like [resolveColor]
  /// or [resolveNum] when possible, since this method does not interpolate
  /// between the two values when the theme is animating.
  ///
  T resolveBrightness<T>(
    T light,
    T dark, [
    ThemeMode mode = ThemeMode.system,
  ]) {
    switch (mode) {
      case ThemeMode.system:
        return isDark ? dark : light;
      case ThemeMode.light:
        return light;
      case ThemeMode.dark:
        return dark;
    }
  }
}

// ------------------------------
// BEGIN COLOR SCHEME
// ------------------------------

const _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: PColors.dark,
  onPrimary: Colors.white,
  primaryContainer: Colors.white,
  onPrimaryContainer: Colors.black,
  primaryFixed: PColors.dark3,
  primaryFixedDim: PColors.dark2,
  onPrimaryFixed: Colors.white,
  onPrimaryFixedVariant: PColors.offWhite,
  secondary: PColors.offDark,
  onSecondary: Colors.white,
  secondaryContainer: PColors.offWhite,
  onSecondaryContainer: PColors.dark,
  tertiary: PColors.dark5,
  onTertiary: Colors.white,
  tertiaryContainer: PColors.bhOffWhite,
  onTertiaryContainer: PColors.dark3,
  error: PColors.bhRed,
  errorContainer: PColors.bhRedLight8,
  onError: Colors.white,
  onErrorContainer: PColors.offDark,
  surface: PColors.offWhite,
  onSurface: PColors.dark2,
  surfaceTint: PColors.offWhite,
  onSurfaceVariant: PColors.dark5,
  surfaceDim: PColors.bhOffWhite,
  surfaceBright: Colors.white,
  surfaceContainerLowest: PColors.bhOffWhite8,
  surfaceContainerLow: PColors.bhOffWhite6,
  surfaceContainer: PColors.bhOffWhite4,
  surfaceContainerHigh: PColors._grayLightModeNoOpacity,
  surfaceContainerHighest: Color(0xffcdcbc7),
  outline: PColors.dark9,
  outlineVariant: PColors._grayLightModeNoOpacity,
  inverseSurface: PColors.offDark,
  onInverseSurface: Colors.white,
  inversePrimary: PColors.bhOffWhite,
  shadow: Colors.black,
  scrim: Colors.black,
);

const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: PColors.bhOffWhite8,
  onPrimary: PColors.dark,
  primaryContainer: PColors.dark2,
  onPrimaryContainer: PColors.offWhite,
  primaryFixed: PColors.bhOffWhite4,
  primaryFixedDim: PColors.bhOffWhite,
  onPrimaryFixed: PColors.dark,
  onPrimaryFixedVariant: PColors.dark3,
  secondary: PColors.bhOffWhite3,
  onSecondary: PColors.dark,
  secondaryContainer: PColors.dark3,
  onSecondaryContainer: PColors.bhOffWhite,
  tertiary: PColors.bhOffWhite,
  onTertiary: PColors.dark,
  tertiaryContainer: PColors.dark5,
  onTertiaryContainer: PColors.bhOffWhite4,
  error: PColors.bhRedLight3,
  errorContainer: PColors.bhRedDark5,
  onError: PColors.dark,
  onErrorContainer: PColors.bhOffWhite,
  surface: PColors.dark,
  onSurface: PColors.offWhite,
  surfaceTint: PColors.offDark,
  onSurfaceVariant: PColors.bhOffWhite8,
  surfaceDim: PColors.dark,
  surfaceBright: PColors.dark9,
  surfaceContainerLowest: PColors.dark2,
  surfaceContainerLow: PColors.dark3,
  surfaceContainer: PColors.dark4,
  surfaceContainerHigh: PColors.dark6,
  surfaceContainerHighest: PColors.dark8,
  outline: PColors.dark8,
  outlineVariant: PColors.dark5,
  inverseSurface: PColors.bhOffWhite,
  onInverseSurface: PColors.dark,
  inversePrimary: PColors.dark,
  shadow: Colors.black,
  scrim: Colors.black,
);

// ------------------------------
// END COLOR SCHEME
// ------------------------------

// ------------------------------
// BEGIN TYPEFACES
// ------------------------------

const kFontFamily = 'Figtree';
const kLabelFontFamily = 'Inter';
const kMonoFontFamily = 'Azeret Mono';
const kStylizedFontFamily = 'Neuton';
const kStylizedSansFontFamily = 'Rubik Mono One';
const kStylizedSans2FontFamily = 'Days One';
const kReadOptimalFontFamily = 'Crimson Text';

final _figtreeLightTextTheme = _baseLightTheme.textTheme.apply(
  fontFamily: kLabelFontFamily,
);

final _lightTextTheme = _figtreeLightTextTheme.copyWith(
  displayLarge: _figtreeLightTextTheme.displayLarge!.displayFont,
  displayMedium: _figtreeLightTextTheme.displayMedium!.displayFont,
  displaySmall: _figtreeLightTextTheme.displaySmall!.displayFont,
  headlineLarge: _figtreeLightTextTheme.headlineLarge!.displayFont,
  headlineMedium: _figtreeLightTextTheme.headlineMedium!.displayFont,
  headlineSmall: _figtreeLightTextTheme.headlineSmall!.displayFont,
  titleLarge: _figtreeLightTextTheme.titleLarge!.mediumWeight,
  titleMedium: _figtreeLightTextTheme.titleMedium!.mediumWeight,
  titleSmall: _figtreeLightTextTheme.titleSmall!.mediumWeight,
  bodyLarge: _figtreeLightTextTheme.bodyLarge!.regularWeight,
  bodyMedium: _figtreeLightTextTheme.bodyMedium!.regularWeight,
  bodySmall: _figtreeLightTextTheme.bodySmall!.regularWeight,
  labelLarge: _figtreeLightTextTheme.labelLarge!.labelFont.mediumWeight,
  labelMedium: _figtreeLightTextTheme.labelMedium!.labelFont.regularWeight,
  labelSmall: _figtreeLightTextTheme.labelSmall!.labelFont.regularWeight
      .enableFeature('cpsp'),
);

final _figtreeDarkTextTheme =
    _baseDarkTheme.textTheme.apply(fontFamily: kLabelFontFamily);

final _darkTextTheme = _figtreeDarkTextTheme.copyWith(
  displayLarge: _figtreeDarkTextTheme.displayLarge!.displayFont,
  displayMedium: _figtreeDarkTextTheme.displayMedium!.displayFont,
  displaySmall: _figtreeDarkTextTheme.displaySmall!.displayFont,
  headlineLarge: _figtreeDarkTextTheme.headlineLarge!.displayFont,
  headlineMedium: _figtreeDarkTextTheme.headlineMedium!.displayFont,
  headlineSmall: _figtreeDarkTextTheme.headlineSmall!.displayFont,
  titleLarge: _figtreeDarkTextTheme.titleLarge!.mediumWeight,
  titleMedium: _figtreeDarkTextTheme.titleMedium!.mediumWeight,
  titleSmall: _figtreeDarkTextTheme.titleSmall!.mediumWeight,
  bodyLarge: _figtreeDarkTextTheme.bodyLarge!.regularWeight,
  bodyMedium: _figtreeDarkTextTheme.bodyMedium!.regularWeight,
  bodySmall: _figtreeDarkTextTheme.bodySmall!.regularWeight,
  labelLarge: _figtreeDarkTextTheme.labelLarge!.labelFont.mediumWeight,
  labelMedium: _figtreeDarkTextTheme.labelMedium!.labelFont.regularWeight,
  labelSmall: _figtreeDarkTextTheme.labelSmall!.labelFont.regularWeight
      .enableFeature('cpsp'),
);

extension TextStyleUtils on TextStyle {
  TextStyle get displayFont =>
      copyWith(fontFamily: kLabelFontFamily).enableFeatures(['cv08', 'ss03']);

  TextStyle get monoFont => GoogleFonts.getFont(
        kMonoFontFamily,
        textStyle: this,
      );

  TextStyle get labelFont => copyWith(fontFamily: kLabelFontFamily);

  TextStyle get stylized => GoogleFonts.getFont(
        kStylizedFontFamily,
        textStyle: this,
      );

  TextStyle get stylizedSans => GoogleFonts.getFont(
        kStylizedSansFontFamily,
        textStyle: this,
      );

  TextStyle get stylizedSansAlt => GoogleFonts.getFont(
        kStylizedSans2FontFamily,
        textStyle: this,
      );

  TextStyle get readOptimal => GoogleFonts.getFont(
        kReadOptimalFontFamily,
        textStyle: this,
      );

  TextStyle get w300 =>
      copyWith(fontVariations: const [FontVariation.weight(300)]);
  TextStyle get w400 =>
      copyWith(fontVariations: const [FontVariation.weight(400)]);
  TextStyle get w500 =>
      copyWith(fontVariations: const [FontVariation.weight(500)]);
  TextStyle get w600 =>
      copyWith(fontVariations: const [FontVariation.weight(600)]);
  TextStyle get w700 =>
      copyWith(fontVariations: const [FontVariation.weight(700)]);
  TextStyle get w800 =>
      copyWith(fontVariations: const [FontVariation.weight(800)]);
  TextStyle get w900 =>
      copyWith(fontVariations: const [FontVariation.weight(900)]);

  /// Modifies the weight of the font.
  ///
  /// Fractional weight deltas are only supported for variable fonts such as
  /// [kLabelFontFamily] and [kFontFamily]. For non-variable fonts such as
  /// [kDisplayFontFamily], [delta] will be rounded to the nearest integer.
  ///
  /// A [delta] value of `0.0` will return the current [TextStyle] without any
  /// changes. A non-zero [delta] value will be added the weight in multiples
  /// of `100`. Typically, the weight is clamped below by `100` and above by
  /// `900`, but the exact effect can vary depending on the font.
  ///
  TextStyle modifyWeight(double delta) {
    if (delta == 0.0) {
      return this;
    }
    final weight = fontVariations
        ?.firstWhereOrNull((variation) => variation.axis == 'wght')
        ?.value as num?;
    if (weight == null) {
      return apply(fontWeightDelta: delta.round());
    }
    return copyWith(
      fontVariations: [FontVariation.weight(weight + delta * 100)],
    );
  }

  /// Modifies the width of the font. This is only supported
  /// for variable fonts such as [kLabelFontFamily].
  ///
  /// Note that [kFontFamily] does not support width modification.
  ///
  /// Defaults to `1.0`, which is the normal width. A value greater
  /// than `1.0` will expand the width, and a value less than `1.0`
  /// will condense the width.
  ///
  // TextStyle modifyWidth([double width = 1.0]) => copyWith(
  //       fontVariations: [FontVariation.width(width * 100.0)],
  //     );

  TextStyle enableFeature(String feature) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        FontFeature.enable(feature),
      ],
    );
  }

  TextStyle enableFeatures(List<String> features) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        ...features.map(FontFeature.enable),
      ],
    );
  }

  TextStyle disableFeature(String feature) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        FontFeature.disable(feature),
      ],
    );
  }

  TextStyle disableFeatures(List<String> features) {
    return copyWith(
      fontFeatures: [
        ...?fontFeatures,
        ...features.map(FontFeature.disable),
      ],
    );
  }

  TextStyle get lightWeight => w300;
  TextStyle get regularWeight => w400;
  TextStyle get mediumWeight => w500;
}

// ------------------------------
// END TYPEFACES
// ------------------------------

/// A parent widget that re-themes its child based on the user's theme preference
/// and the system's platform brightness.
///
/// Typically used for spawned windows or dialogs.
///
class ReTheme extends StatefulWidget {
  const ReTheme({
    this.includeNewScaffoldMessenger = false,
    required this.builder,
    super.key,
  });

  /// Whether to include a new [ScaffoldMessenger] in the [builder]'s context.
  ///
  /// Including a new [ScaffoldMessenger] may be useful for spawned windows or
  /// dialogs when we don't want SnackBar messages to be displayed in the main
  /// Navigator and the dialog at the same time.
  ///
  final bool includeNewScaffoldMessenger;
  final WidgetBuilder builder;

  @override
  State<ReTheme> createState() => _ReThemeState();
}

class _ReThemeState extends State<ReTheme> {
  final _themePrefs = Stream.value(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    final themedChild = StreamBuilder(
      stream: _themePrefs,
      builder: (context, snapshot) {
        final mode = snapshot.data ?? ThemeMode.system;
        final theme = mode == ThemeMode.dark
            ? kDarkTheme
            : mode == ThemeMode.light
                ? kLightTheme
                : MediaQuery.platformBrightnessOf(context) == Brightness.dark
                    ? kDarkTheme
                    : kLightTheme;

        final Widget child = Builder(builder: widget.builder);

        return AnimatedTheme(
          data: theme,
          child: child,
        );
      },
    );
    if (widget.includeNewScaffoldMessenger) {
      return ScaffoldMessenger(
        child: themedChild,
      );
    }
    return themedChild;
  }
}
