part of 'ui.dart';

const _kToastPadding = EdgeInsets.symmetric(
  vertical: 16.0,
  horizontal: 20.0,
);

class Toaster {
  static GlobalKey<ScaffoldMessengerState> get _globalScaffoldKey =>
      KeysManager.topScaffold;

  /// ---------------------------- Snackbars ----------------------------

  static ScaffoldMessengerState? getMessenger([BuildContext? context]) {
    return context != null
        ? ScaffoldMessenger.of(context)
        : _globalScaffoldKey.currentState;
  }

  static void _showSnackBar(
    String message, {
    ScaffoldMessengerState? messenger,
    BuildContext? context,
    Widget? leading,
    bool dismissible = true,
    bool isError = false,
    Duration? duration,
  }) {
    if (context == null &&
        _globalScaffoldKey.currentWidget == null &&
        messenger == null) {
      return;
    }

    if (messenger == null && context != null && !context.mounted) {
      return;
    }

    final state = messenger ?? getMessenger(context);

    state?.clearSnackBars();
    state?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ??
            (isError
                ? const Duration(
                    seconds: 5,
                  )
                : const Duration(
                    seconds: 2,
                  )),
        elevation: 0.0,
        shape: PDecors.border12,
        backgroundColor: Colors.transparent,
        content: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: PDecors.broadShadowsCard(context),
                padding: _kToastPadding,
                margin: const EdgeInsets.only(bottom: 16.0),
                constraints: const BoxConstraints(
                  maxWidth: 500.0,
                  minWidth: 300.0,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    size: 20.0,
                    color: isError ? Colors.red : theme.colorScheme.onSurface,
                  ),
                  child: DefaultTextStyle(
                    style: (theme.textTheme.bodyMedium ?? const TextStyle())
                        .copyWith(
                      color: isError ? Colors.red : null,
                      overflow: TextOverflow.ellipsis,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isError)
                          const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              CupertinoIcons.exclamationmark_circle,
                            ),
                          ),
                        if (leading != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: leading,
                          ),
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().scaleXY(
                    duration: PEffects.mediumDuration,
                    curve: Curves.easeOut,
                    alignment: Alignment.bottomRight,
                    begin: 0.2,
                    end: 1.0,
                  ),
            );
          },
        ),
        dismissDirection:
            dismissible ? DismissDirection.down : DismissDirection.none,
      ),
    );

    return;
  }

  static void showSnackbar(
    BuildContext context,
    String message, {
    bool dismissible = true,
    Duration? duration,
    Widget? leading,
  }) {
    return _showSnackBar(
      message,
      context: context,
      dismissible: dismissible,
      duration: duration,
      leading: leading,
    );
  }

  static void showMSnackbar(
    ScaffoldMessengerState messenger,
    String message, {
    bool dismissible = true,
    Duration? duration,
    Widget? leading,
  }) {
    return _showSnackBar(
      message,
      messenger: messenger,
      dismissible: dismissible,
      duration: duration,
      leading: leading,
    );
  }

  static void showError(BuildContext context, [String? customMessage]) {
    return _showSnackBar(
      customMessage ?? 'Something went wrong.',
      context: context,
      isError: true,
    );
  }

  static void showMError(
    ScaffoldMessengerState messenger, [
    String? customMessage,
  ]) {
    return _showSnackBar(
      customMessage ?? 'Something went wrong.',
      messenger: messenger,
      isError: true,
    );
  }

  static void showGlobal(
    String customMessage,
  ) {
    _showSnackBar(
      customMessage,
    );
    return;
  }

  static void showGlobalError([
    String? customMessage,
  ]) {
    _showSnackBar(
      customMessage ?? 'Something went wrong. Please try again.',
      isError: true,
    );
    return;
  }
}

class PSnackBar extends SnackBar {
  /// Creates a snack bar.
  ///
  /// The [elevation] must be null or non-negative.
  const PSnackBar({
    required super.content,
    super.backgroundColor,
    super.elevation,
    super.margin,
    super.padding,
    super.width,
    super.shape,
    super.hitTestBehavior,
    super.behavior,
    super.action,
    super.actionOverflowThreshold,
    super.showCloseIcon,
    super.closeIconColor,
    super.duration,
    super.animation,
    super.onVisible,
    super.dismissDirection,
    super.clipBehavior,
    super.key,
  });

  @override
  State<PSnackBar> createState() => _PSnackBarState();

  /// Creates a copy of this snack bar but with the animation replaced with the given animation.
  ///
  /// If the original snack bar lacks a key, the newly created snack bar will
  /// use the given fallback key.
  @override
  PSnackBar withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) {
    return PSnackBar(
      key: key ?? fallbackKey,
      content: content,
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      hitTestBehavior: hitTestBehavior,
      behavior: behavior,
      action: action,
      actionOverflowThreshold: actionOverflowThreshold,
      showCloseIcon: showCloseIcon,
      closeIconColor: closeIconColor,
      duration: duration,
      animation: newAnimation,
      onVisible: onVisible,
      dismissDirection: dismissDirection,
      clipBehavior: clipBehavior,
    );
  }
}

class _PSnackBarState extends State<PSnackBar> {
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    widget.animation!.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void didUpdateWidget(PSnackBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation!.removeStatusListener(_onAnimationStatusChanged);
      widget.animation!.addStatusListener(_onAnimationStatusChanged);
    }
  }

  @override
  void dispose() {
    widget.animation!.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.dismissed:
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        if (widget.onVisible != null && !_wasVisible) {
          widget.onVisible!();
        }
        _wasVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final bool accessibleNavigation =
        MediaQuery.accessibleNavigationOf(context);
    assert(widget.animation != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final SnackBarThemeData snackBarTheme = theme.snackBarTheme;
    final bool isThemeDark = theme.brightness == Brightness.dark;
    final Color buttonColor =
        isThemeDark ? colorScheme.primary : colorScheme.secondary;
    final SnackBarThemeData defaults = _PSnackbarDefaults(context);

    final TextStyle? contentTextStyle =
        snackBarTheme.contentTextStyle ?? defaults.contentTextStyle;
    final SnackBarBehavior snackBarBehavior =
        widget.behavior ?? snackBarTheme.behavior ?? defaults.behavior!;
    final double? width = widget.width ?? snackBarTheme.width;
    assert(() {
      // Whether the behavior is set through the constructor or the theme,
      // assert that our other properties are configured properly.
      if (snackBarBehavior != SnackBarBehavior.floating) {
        String message(String parameter) {
          final String prefix =
              '$parameter can only be used with floating behavior.';
          if (widget.behavior != null) {
            return '$prefix SnackBarBehavior.fixed was set in the SnackBar constructor.';
          } else if (snackBarTheme.behavior != null) {
            return '$prefix SnackBarBehavior.fixed was set by the inherited SnackBarThemeData.';
          } else {
            return '$prefix SnackBarBehavior.fixed was set by default.';
          }
        }

        assert(widget.margin == null, message('Margin'));
        assert(width == null, message('Width'));
      }
      return true;
    }());

    final bool showCloseIcon = widget.showCloseIcon ??
        snackBarTheme.showCloseIcon ??
        defaults.showCloseIcon!;

    final bool isFloatingSnackBar =
        snackBarBehavior == SnackBarBehavior.floating;
    final double horizontalPadding = isFloatingSnackBar ? 16.0 : 24.0;
    final EdgeInsetsGeometry padding = widget.padding ??
        EdgeInsetsDirectional.only(
          start: horizontalPadding,
          end: widget.action != null || showCloseIcon ? 0 : horizontalPadding,
        );

    final double actionHorizontalMargin =
        (widget.padding?.resolve(TextDirection.ltr).right ??
                horizontalPadding) /
            2;
    final double iconHorizontalMargin =
        (widget.padding?.resolve(TextDirection.ltr).right ??
                horizontalPadding) /
            12.0;

    final CurvedAnimation fadeInM3Animation = CurvedAnimation(
      parent: widget.animation!,
      curve: _snackBarM3FadeInCurve,
    );
    final CurvedAnimation fadeOutAnimation = CurvedAnimation(
      parent: widget.animation!,
      curve: _snackBarFadeOutCurve,
      reverseCurve: const Threshold(0.0),
    );
    // Material 3 Animation has a height animation on entry, but a direct fade out on exit.
    final CurvedAnimation heightM3Animation = CurvedAnimation(
      parent: widget.animation!,
      curve: _snackBarM3HeightCurve,
      reverseCurve: const Threshold(0.0),
    );

    final IconButton? iconButton = showCloseIcon
        ? IconButton(
            icon: const Icon(Icons.close),
            iconSize: 24.0,
            color: widget.closeIconColor ??
                snackBarTheme.closeIconColor ??
                defaults.closeIconColor,
            onPressed: () => ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
          )
        : null;

    // Calculate combined width of Action, Icon, and their padding, if they are present.
    final TextPainter actionTextPainter = TextPainter(
      text: TextSpan(
        text: widget.action?.label ?? '',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final double actionAndIconWidth = actionTextPainter.size.width +
        (widget.action != null ? actionHorizontalMargin : 0) +
        (showCloseIcon
            ? (iconButton?.iconSize ?? 0 + iconHorizontalMargin)
            : 0);
    actionTextPainter.dispose();

    final EdgeInsets margin = widget.margin?.resolve(TextDirection.ltr) ??
        snackBarTheme.insetPadding ??
        defaults.insetPadding!;

    final double snackBarWidth = widget.width ??
        MediaQuery.sizeOf(context).width - (margin.left + margin.right);
    final double actionOverflowThreshold = widget.actionOverflowThreshold ??
        snackBarTheme.actionOverflowThreshold ??
        defaults.actionOverflowThreshold!;

    final bool willOverflowAction =
        actionAndIconWidth / snackBarWidth > actionOverflowThreshold;

    final List<Widget> maybeActionAndIcon = <Widget>[
      if (widget.action != null)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: actionHorizontalMargin),
          child: TextButtonTheme(
            data: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: buttonColor,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              ),
            ),
            child: widget.action!,
          ),
        ),
      if (showCloseIcon)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: iconHorizontalMargin),
          child: iconButton,
        ),
    ];

    Widget snackBar = Padding(
      padding: padding,
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: widget.padding == null
                      ? const EdgeInsets.symmetric(
                          vertical: _singleLineVerticalPadding,
                        )
                      : null,
                  child: DefaultTextStyle(
                    style: contentTextStyle!,
                    child: widget.content,
                  ),
                ),
              ),
              if (!willOverflowAction) ...maybeActionAndIcon,
              if (willOverflowAction) SizedBox(width: snackBarWidth * 0.4),
            ],
          ),
          if (willOverflowAction)
            Padding(
              padding:
                  const EdgeInsets.only(bottom: _singleLineVerticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: maybeActionAndIcon,
              ),
            ),
        ],
      ),
    );

    if (!isFloatingSnackBar) {
      snackBar = SafeArea(
        // top: false,
        child: snackBar,
      );
    }

    final double elevation =
        widget.elevation ?? snackBarTheme.elevation ?? defaults.elevation!;
    final Color backgroundColor = widget.backgroundColor ??
        snackBarTheme.backgroundColor ??
        defaults.backgroundColor!;
    final ShapeBorder? shape = widget.shape ??
        snackBarTheme.shape ??
        (isFloatingSnackBar ? defaults.shape : null);
    final DismissDirection dismissDirection = widget.dismissDirection ??
        snackBarTheme.dismissDirection ??
        DismissDirection.down;

    snackBar = Material(
      shape: shape,
      elevation: elevation,
      color: backgroundColor,
      clipBehavior: widget.clipBehavior,
      child: AnimatedTheme(
        data: theme,
        child: accessibleNavigation || theme.useMaterial3
            ? snackBar
            : FadeTransition(
                opacity: fadeOutAnimation,
                child: snackBar,
              ),
      ),
    );

    if (isFloatingSnackBar) {
      // If width is provided, do not include horizontal margins.
      if (width != null) {
        snackBar = Container(
          margin: EdgeInsets.only(
            top: margin.top,
            bottom: margin.bottom,
          ),
          width: width,
          child: snackBar,
        );
      } else {
        snackBar = Padding(
          padding: margin,
          child: snackBar,
        );
      }
      snackBar = SafeArea(
        top: false,
        bottom: false,
        child: snackBar,
      );
    }

    snackBar = Align(
      alignment: AlignmentDirectional.topEnd,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 140.0),
        child: Semantics(
          container: true,
          liveRegion: true,
          onDismiss: () {
            ScaffoldMessenger.of(context)
                .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500.0,
            ),
            child: Dismissible(
              key: const Key('dismissible'),
              direction: dismissDirection,
              resizeDuration: null,
              behavior: widget.hitTestBehavior ??
                  (widget.margin != null
                      ? HitTestBehavior.deferToChild
                      : HitTestBehavior.opaque),
              onDismissed: (DismissDirection direction) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar(
                  reason: SnackBarClosedReason.swipe,
                );
              },
              child: snackBar,
            ),
          ),
        ),
      ),
    );

    final Widget snackBarTransition;
    if (accessibleNavigation) {
      snackBarTransition = snackBar;
    } else if (isFloatingSnackBar) {
      snackBarTransition = FadeTransition(
        opacity: fadeInM3Animation,
        child: AnimatedBuilder(
          animation: heightM3Animation,
          builder: (BuildContext context, Widget? child) {
            return Align(
              alignment: AlignmentDirectional.bottomStart,
              heightFactor: heightM3Animation.value,
              child: child,
            );
          },
          child: snackBar,
        ),
      );
    } else {
      snackBarTransition = AnimatedBuilder(
        animation: heightM3Animation,
        builder: (BuildContext context, Widget? child) {
          return Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: heightM3Animation.value,
            child: child,
          );
        },
        child: snackBar,
      );
    }

    return Hero(
      tag: '<SnackBar Hero tag - ${widget.content}>',
      transitionOnUserGestures: true,
      child: ClipRect(
        clipBehavior: widget.clipBehavior,
        child: snackBarTransition,
      ),
    );
  }
}

const double _singleLineVerticalPadding = 14.0;
const Curve _snackBarM3HeightCurve = Curves.easeInOutQuart;

const Curve _snackBarM3FadeInCurve =
    Interval(0.4, 0.6, curve: Curves.easeInCirc);
const Curve _snackBarFadeOutCurve =
    Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

/// A button for a [SnackBar], known as an "action".
///
/// Snack bar actions are always enabled. Instead of disabling a snack bar
/// action, avoid including it in the snack bar in the first place.
///
/// Snack bar actions can only be pressed once. Subsequent presses are ignored.
///
/// See also:
///
///  * [SnackBar]
///  * <https://material.io/design/components/snackbars.html>
class SnackBarAction extends StatefulWidget {
  /// Creates an action for a [SnackBar].
  const SnackBarAction({
    super.key,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    required this.label,
    required this.onPressed,
  }) : assert(
            backgroundColor is! WidgetStateColor ||
                disabledBackgroundColor == null,
            'disabledBackgroundColor must not be provided when background color is '
            'a MaterialStateColor');

  /// The button label color. If not provided, defaults to
  /// [SnackBarThemeData.actionTextColor].
  ///
  /// If [textColor] is a [WidgetStateColor], then the text color will be
  /// resolved against the set of [WidgetState]s that the action text
  /// is in, thus allowing for different colors for states such as pressed,
  /// hovered and others.
  final Color? textColor;

  /// The button background fill color. If not provided, defaults to
  /// [SnackBarThemeData.actionBackgroundColor].
  ///
  /// If [backgroundColor] is a [WidgetStateColor], then the text color will
  /// be resolved against the set of [WidgetState]s that the action text is
  /// in, thus allowing for different colors for the states.
  final Color? backgroundColor;

  /// The button disabled label color. This color is shown after the
  /// [SnackBarAction] is dismissed.
  final Color? disabledTextColor;

  /// The button diabled background color. This color is shown after the
  /// [SnackBarAction] is dismissed.
  ///
  /// If not provided, defaults to [SnackBarThemeData.disabledActionBackgroundColor].
  final Color? disabledBackgroundColor;

  /// The button label.
  final String label;

  /// The callback to be called when the button is pressed.
  ///
  /// This callback will be called at most once each time this action is
  /// displayed in a [SnackBar].
  final VoidCallback onPressed;

  @override
  State<SnackBarAction> createState() => _SnackBarActionState();
}

class _SnackBarActionState extends State<SnackBarAction> {
  bool _haveTriggeredAction = false;

  void _handlePressed() {
    if (_haveTriggeredAction) {
      return;
    }
    setState(() {
      _haveTriggeredAction = true;
    });
    widget.onPressed();
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
  }

  @override
  Widget build(BuildContext context) {
    final SnackBarThemeData defaults = _PSnackbarDefaults(context);
    final SnackBarThemeData snackBarTheme = Theme.of(context).snackBarTheme;

    WidgetStateColor resolveForegroundColor() {
      if (widget.textColor != null) {
        if (widget.textColor is WidgetStateColor) {
          return widget.textColor! as WidgetStateColor;
        }
      } else if (snackBarTheme.actionTextColor != null) {
        if (snackBarTheme.actionTextColor is WidgetStateColor) {
          return snackBarTheme.actionTextColor! as WidgetStateColor;
        }
      } else if (defaults.actionTextColor != null) {
        if (defaults.actionTextColor is WidgetStateColor) {
          return defaults.actionTextColor! as WidgetStateColor;
        }
      }

      return WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return widget.disabledTextColor ??
              snackBarTheme.disabledActionTextColor ??
              defaults.disabledActionTextColor!;
        }
        return widget.textColor ??
            snackBarTheme.actionTextColor ??
            defaults.actionTextColor!;
      });
    }

    WidgetStateColor? resolveBackgroundColor() {
      if (widget.backgroundColor is WidgetStateColor) {
        return widget.backgroundColor! as WidgetStateColor;
      }
      if (snackBarTheme.actionBackgroundColor is WidgetStateColor) {
        return snackBarTheme.actionBackgroundColor! as WidgetStateColor;
      }
      return WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return widget.disabledBackgroundColor ??
              snackBarTheme.disabledActionBackgroundColor ??
              Colors.transparent;
        }
        return widget.backgroundColor ??
            snackBarTheme.actionBackgroundColor ??
            Colors.transparent;
      });
    }

    return TextButton(
      style: ButtonStyle(
        foregroundColor: resolveForegroundColor(),
        backgroundColor: resolveBackgroundColor(),
      ),
      onPressed: _haveTriggeredAction ? null : _handlePressed,
      child: Text(widget.label),
    );
  }
}

class _PSnackbarDefaults extends SnackBarThemeData {
  _PSnackbarDefaults(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color get backgroundColor => _colors.inverseSurface;

  @override
  Color get actionTextColor =>
      WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return _colors.inversePrimary;
        }
        if (states.contains(WidgetState.pressed)) {
          return _colors.inversePrimary;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.inversePrimary;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.inversePrimary;
        }
        return _colors.inversePrimary;
      });

  @override
  Color get disabledActionTextColor => _colors.inversePrimary;

  @override
  TextStyle get contentTextStyle =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: _colors.onInverseSurface,
          );

  @override
  double get elevation => 6.0;

  @override
  ShapeBorder get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      );

  @override
  SnackBarBehavior get behavior => SnackBarBehavior.fixed;

  @override
  EdgeInsets get insetPadding =>
      const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0);

  @override
  bool get showCloseIcon => false;

  @override
  Color? get closeIconColor => _colors.onInverseSurface;

  @override
  double get actionOverflowThreshold => 0.25;

  @override
  DismissDirection get dismissDirection => DismissDirection.up;
}
