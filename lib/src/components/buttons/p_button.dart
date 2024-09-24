import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

import '../../core/core.dart';
import '../../services/services.dart';
import '../components.dart';

class PButtonController extends RButtonController {
  PButtonController();

  bool get isLoading => currentState == ButtonState.loading;
  set isLoading(bool value) {
    value ? start() : stop();
  }

  bool get isError => currentState == ButtonState.error;
  set isError(bool value) {
    value ? error() : stop();
  }

  bool get isSuccess => currentState == ButtonState.success;
  set isSuccess(bool value) {
    value ? success() : stop();
  }

  bool get isIdle => currentState == ButtonState.idle;
  set isIdle(bool value) {
    value ? reset() : stop();
  }

  bool get isCompleted => isSuccess || isError;
}

class PButton extends StatefulWidget {
  const PButton({
    this.controller,
    this.borderRadius = 16.0,
    this.idleBorderSide = BorderSide.none,
    this.focusedBorderSide,
    this.shadows = const [],
    this.leading,
    this.trailing,
    this.disabledTooltip,
    this.activeTooltip,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.animateOnTap = false,
    this.analyticsEvent,
    required this.onTap,
    required this.child,
    super.key,
  }) : assert(backgroundGradient == null || backgroundColor == null);

  final PButtonController? controller;
  final double borderRadius;
  final BorderSide idleBorderSide;
  final BorderSide? focusedBorderSide;
  final List<BoxShadow> shadows;
  final AnalyticsEvent? analyticsEvent;
  final ValueChanged<PButtonController>? onTap;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Widget? leading, trailing;
  final String? disabledTooltip, activeTooltip;
  final bool animateOnTap;
  final Widget child;

  @override
  State<PButton> createState() => _PButtonState();
}

class _PButtonState extends State<PButton> {
  late final _controller = widget.controller ?? PButtonController();
  late final _tooltipKey = GlobalKey<TooltipState>();
  bool _isFocused = false;

  void _showTooltip() {
    _tooltipKey.currentState?.ensureTooltipVisible();
    Future.delayed(
      PEffects.veryLongDuration,
      () => Tooltip.dismissAllToolTips(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasNavigator = Navigator.maybeOf(context) != null;

    final button = LayoutBuilder(
      builder: (context, constraints) => RButton(
        controller: _controller,
        height: math.min(constraints.maxHeight, 56.0),
        width: constraints.maxWidth,
        borderRadius: widget.borderRadius,
        borderSide: _isFocused
            ? widget.focusedBorderSide ?? widget.idleBorderSide
            : widget.idleBorderSide,
        shadows: widget.shadows,
        backgroundColor: widget.backgroundColor,
        backgroundGradient: widget.backgroundGradient,
        foregroundColor: widget.foregroundColor,
        animateOnTap: widget.animateOnTap,
        onPressed: widget.onTap == null
            ? null
            : () {
                widget.analyticsEvent?.track();
                widget.onTap?.call(_controller);
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leading case final leading?) ...[
              leading,
              const Gap(8.0),
            ],
            widget.child,
            if (widget.trailing case final trailing?) ...[
              const Gap(8.0),
              trailing,
            ],
          ],
        ),
      ),
    );

    if (!hasNavigator) {
      return button;
    }

    final theme = Theme.of(context);
    final isDisabled = widget.onTap == null;
    final borderThickness = _isFocused ? 1.5 : 0.0;
    final effectivePadding = 3.0 - borderThickness;
    final effectiveBorderRadius = widget.borderRadius + effectivePadding;

    return PTooltip(
      triggerMode: widget.onTap == null && widget.disabledTooltip != null
          ? TooltipTriggerMode.tap
          : TooltipTriggerMode.manual,
      toolTipKey: _tooltipKey,
      message: isDisabled ? (widget.disabledTooltip ?? 'Disabled') : null,
      child: Focus(
        onFocusChange: (focus) {
          if (focus) {
            _showTooltip();
          }
          setState(() => _isFocused = focus);
        },
        onKeyEvent: (node, event) {
          if (_isFocused && event.logicalKey == LogicalKeyboardKey.enter) {
            if (widget.onTap != null) {
              widget.onTap?.call(_controller);
            } else {
              _showTooltip();
            }
            return KeyEventResult.handled;
          } else {
            return KeyEventResult.ignored;
          }
        },
        child: AnimatedContainer(
          duration: PEffects.veryShortDuration,
          curve: Curves.easeInOut,
          decoration: ShapeDecoration(
            shape: PContinuousRectangleBorder(
              cornerRadius: effectiveBorderRadius + 0.2,
              side: _isFocused
                  ? BorderSide(
                      color:
                          widget.backgroundColor ?? theme.colorScheme.primary,
                      width: borderThickness,
                    )
                  : BorderSide.none,
            ),
          ),
          padding: EdgeInsets.all(effectivePadding),
          child: AnimatedOpacity(
            duration: PEffects.shortDuration,
            curve: Curves.easeInOut,
            opacity: widget.onTap == null ? 0.5 : 1.0,
            child: button,
          ),
        ),
      ),
    );
  }
}

/// States that your button can assume via the controller
enum ButtonState { idle, loading, success, error }

/// A low-level button widget that can be used to create custom buttons.
/// It is used by the [PButton] widget.
///
class RButton extends StatefulWidget {
  const RButton({
    super.key,
    required this.controller,
    required this.onPressed,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    required this.height,
    required this.width,
    this.loaderSize = 24.0,
    this.animateOnTap = true,
    this.borderRadius = 16.0,
    this.borderSide = BorderSide.none,
    this.shadows = const [],
    this.elevation = 0.0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.resetDuration = const Duration(seconds: 5),
    this.resetAfterDuration = false,
    this.successIcon = CupertinoIcons.checkmark_alt,
    this.failedIcon = CupertinoIcons.exclamationmark_circle,
    this.completionCurve = Curves.elasticOut,
    this.completionDuration = const Duration(milliseconds: 1000),
    required this.child,
  });

  /// Button controller, now required
  final RButtonController controller;

  /// The callback that is called when
  /// the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// The button's label
  final Widget child;

  /// The primary color of the button
  final Color? backgroundColor;

  /// The gradient of the button
  final Gradient? backgroundGradient;

  /// The color of the button's text and icon
  final Color? foregroundColor;

  /// The vertical extent of the button.
  final double height;

  /// The horizontal extent of the button.
  final double width;

  /// The size of the [ProgressIndicator]
  ///
  final double loaderSize;

  /// Whether to trigger the animation on the tap event
  final bool animateOnTap;

  /// reset the animation after specified duration,
  /// use resetDuration parameter to set Duration, defaults to 15 seconds
  final bool resetAfterDuration;

  /// The curve of the shrink animation
  final Curve curve;

  /// The radius of the button border
  final double borderRadius;

  /// The border side of the button
  final BorderSide borderSide;

  /// Shadows
  final List<BoxShadow> shadows;

  /// The duration of the button animation
  final Duration duration;

  /// The elevation of the raised button
  final double elevation;

  /// Duration after which reset the button
  final Duration resetDuration;

  /// The icon for the success state
  final IconData successIcon;

  /// The icon for the failed state
  final IconData failedIcon;

  /// The success and failed animation curve
  final Curve completionCurve;

  /// The duration of the success and failed animation
  final Duration completionDuration;

  Duration get _borderDuration {
    return Duration(milliseconds: (duration.inMilliseconds / 2).round());
  }

  @override
  State<StatefulWidget> createState() => _RButtonState();
}

class _RButtonState extends State<RButton> with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _borderController;
  late AnimationController _checkButtonController;

  late Animation<double> _squeezeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _borderAnimation;

  final _state = BehaviorSubject<ButtonState>.seeded(ButtonState.idle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget check = Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      ),
      width: _bounceAnimation.value,
      height: _bounceAnimation.value,
      child: _bounceAnimation.value > 20
          ? Icon(
              widget.successIcon,
              color: theme.colorScheme.onPrimary,
            )
          : null,
    );

    final Widget cross = Container(
      alignment: FractionalOffset.center,
      decoration: ShapeDecoration(
        color: theme.colorScheme.errorContainer,
        shape: PContinuousRectangleBorder(
          cornerRadius: widget.borderRadius,
          side: widget.borderSide,
        ),
      ),
      width: _bounceAnimation.value,
      height: _bounceAnimation.value,
      child: _bounceAnimation.value > 20
          ? Icon(
              widget.failedIcon,
              color: theme.colorScheme.onErrorContainer,
            )
          : null,
    );

    final Widget loader = SizedBox(
      height: widget.loaderSize,
      width: widget.loaderSize,
      child: LoadingIndicator(
        color: theme.colorScheme.onPrimary,
      ),
    );

    final Widget childStream = StreamBuilder(
      stream: _state,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: snapshot.data == ButtonState.loading ? loader : widget.child,
        );
      },
    );

    final isDisabled = widget.onPressed == null;
    final buttonColor = isDisabled
        ? (widget.backgroundColor ?? theme.colorScheme.primary).withOpacity(0.7)
        : (widget.backgroundColor ?? theme.colorScheme.primary);
    final foregroundColor =
        widget.foregroundColor ?? theme.colorScheme.onPrimary;
    final borderRadius = _borderAnimation.value;
    final shape = PContinuousRectangleBorder(
      cornerRadius: borderRadius,
      side: widget.borderSide,
    );

    final btn = BouncingObject(
      onTap: widget.onPressed == null ? null : _btnPressed,
      child: IconTheme(
        data: IconThemeData(
          color: foregroundColor,
          size: widget.height / 3,
        ),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyLarge!.copyWith(
            color: foregroundColor,
          ),
          child: AnimatedContainer(
            duration: widget.duration ~/ 2,
            curve: Curves.elasticInOut,
            decoration: ShapeDecoration(
              color: widget.backgroundGradient == null ? buttonColor : null,
              gradient: widget.backgroundGradient,
              shape: shape,
              shadows: widget.shadows,
            ),
            constraints: BoxConstraints(
              minWidth: _squeezeAnimation.value,
              minHeight: widget.height,
            ),
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: childStream,
          ),
        ),
      ),
    );

    return SizedBox(
      height: widget.height,
      child: Center(
        child: _state.value == ButtonState.error
            ? cross
            : _state.value == ButtonState.success
                ? check
                : btn,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _buttonController =
        AnimationController(duration: widget.duration, vsync: this);

    _checkButtonController =
        AnimationController(duration: widget.completionDuration, vsync: this);

    _borderController =
        AnimationController(duration: widget._borderDuration, vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: widget.height).animate(
      CurvedAnimation(
        parent: _checkButtonController,
        curve: widget.completionCurve,
      ),
    );
    _bounceAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation =
        Tween<double>(begin: widget.width, end: widget.height).animate(
      CurvedAnimation(parent: _buttonController, curve: widget.curve),
    );

    _squeezeAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation.addStatusListener((state) {
      if (state == AnimationStatus.completed && widget.animateOnTap) {
        widget.onPressed?.call();
      }
    });

    _borderAnimation = Tween<double>(
      begin: widget.borderRadius,
      end: widget.height,
    ).animate(_borderController);

    _borderAnimation.addListener(() {
      setState(() {});
    });

    // There is probably a better way of doing this...
    _state.stream.listen((event) {
      if (!mounted) {
        return;
      }
      widget.controller._state.sink.add(event);
    });

    widget.controller._addListeners(_start, _stop, _success, _error, _reset);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _checkButtonController.dispose();
    _borderController.dispose();
    _state.close();
    super.dispose();
  }

  Future<void> _btnPressed() async {
    if (widget.animateOnTap) {
      _start();
    } else {
      widget.onPressed?.call();
    }
  }

  void _start() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.loading);
    _borderController.forward();
    _buttonController.forward();
    if (widget.resetAfterDuration) {
      _reset();
    }
  }

  void _stop() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.idle);
    _buttonController.reverse();
    _borderController.reverse();
  }

  void _success() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.success);
    _checkButtonController.forward();
  }

  void _error() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.error);
    _checkButtonController.forward();
  }

  Future<void> _reset() async {
    if (widget.resetAfterDuration) {
      await Future<void>.delayed(widget.resetDuration);
    }
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.idle);
    unawaited(_buttonController.reverse());
    unawaited(_borderController.reverse());
    _checkButtonController.reset();
  }
}

/// Options that can be chosen by the controller
/// each will perform a unique animation
class RButtonController {
  VoidCallback? _startListener;
  VoidCallback? _stopListener;
  VoidCallback? _successListener;
  VoidCallback? _errorListener;
  VoidCallback? _resetListener;

  void _addListeners(
    VoidCallback startListener,
    VoidCallback stopListener,
    VoidCallback successListener,
    VoidCallback errorListener,
    VoidCallback resetListener,
  ) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  final BehaviorSubject<ButtonState> _state =
      BehaviorSubject<ButtonState>.seeded(ButtonState.idle);

  /// A read-only stream of the button state
  Stream<ButtonState> get stateStream => _state.stream;

  /// Gets the current state
  ButtonState? get currentState => _state.value;

  /// Notify listeners to start the loading animation
  void start() {
    _startListener?.call();
  }

  /// Notify listeners to start the stop animation
  void stop() {
    _stopListener?.call();
  }

  /// Notify listeners to start the success animation
  void success() {
    _successListener?.call();
  }

  /// Notify listeners to start the error animation
  void error() {
    _errorListener?.call();
  }

  /// Notify listeners to start the reset animation
  void reset() {
    _resetListener?.call();
  }
}
