import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../core/ui/ui.dart';
import '../components.dart';

/// Signature for `action` callback function provided to [DialogButton.openBuilder].
///
/// Parameter `returnValue` is the value which will be provided to [DialogButton.onClosed]
/// when `action` is called.
typedef CloseContainerActionCallback<S> = void Function({S? returnValue});

/// Signature for a function that creates a [Widget] in open state within an
/// [DialogButton].
///
/// The `action` callback provided to [DialogButton.openBuilder] can be used
/// to close the container.
typedef OpenContainerBuilder<S> = Widget Function(
  BuildContext context,
  CloseContainerActionCallback<S> action,
);

/// Signature for a function that creates a [Widget] in closed state within an
/// [DialogButton].
///
/// The `action` callback provided to [DialogButton.closedBuilder] can be used
/// to open the container.
typedef CloseContainerBuilder = Widget Function(
  BuildContext context,
  VoidCallback action,
);

/// The [DialogButton] widget's fade transition type.
///
/// This determines the type of fade transition that the incoming and outgoing
/// contents will use.
enum ContainerTransitionType {
  /// Fades the incoming element in over the outgoing element.
  ///
  fade,

  /// First fades the outgoing element out, and starts fading the incoming
  /// element in once the outgoing element has completely faded out.
  ///
  fadeThrough,
}

/// Dismiss drag options for [DialogButton]'s open child.
///
class DismissDragOptions {
  const DismissDragOptions({
    this.onDismissed,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.direction = DismissiblePageDismissDirection.multi,
  });

  static const multi = DismissDragOptions();
  static const horizontal = DismissDragOptions(
    direction: DismissiblePageDismissDirection.horizontal,
  );
  static const vertical = DismissDragOptions(
    direction: DismissiblePageDismissDirection.vertical,
  );

  /// Called when the open child has been dismissed.
  ///
  /// `Navigator.pop` is called automatically, so this callback is only useful
  /// for updating state.
  ///
  final VoidCallback? onDismissed;

  /// Called when the open child has started to be dragged.
  ///
  /// This is called after the drag has started, but before the open child has
  /// been dragged.
  ///
  /// This is called regardless of whether the drag will result in a dismissal.
  ///
  /// This is called before [onDragEnd] and [onDragUpdate].
  ///
  final VoidCallback? onDragStart;

  /// Called when the open child has finished being dragged.
  ///
  final VoidCallback? onDragEnd;

  /// Called when the open child has been dragged and its drag position has
  /// changed.
  ///
  /// This is called before [onDragEnd].
  ///
  final ValueChanged<DismissiblePageDragUpdateDetails>? onDragUpdate;

  /// The direction in which the open child can be dismissed.
  ///
  final DismissiblePageDismissDirection direction;
}

/// Callback function which is called when the [DialogButton]
/// is closed.
typedef ClosedCallback<S> = void Function(S data);

/// A container that grows to fill the screen to reveal new content when tapped.
///
/// While the container is closed, it shows the [Widget] returned by
/// [closedBuilder]. When the container is tapped it grows to fill the entire
/// size of the surrounding [Navigator] while fading out the widget returned by
/// [closedBuilder] and fading in the widget returned by [openBuilder]. When the
/// container is closed again via the callback provided to [openBuilder] or via
/// Android's back button, the animation is reversed: The container shrinks back
/// to its original size while the widget returned by [openBuilder] is faded out
/// and the widget returned by [closedBuilder] is faded back in.
///
/// By default, the container is in the closed state. During the transition from
/// closed to open and vice versa the widgets returned by the [openBuilder] and
/// [closedBuilder] exist in the tree at the same time. Therefore, the widgets
/// returned by these builders cannot include the same global key.
///
/// `T` refers to the type of data returned by the route when the container
/// is closed. This value can be accessed in the `onClosed` function.
///
/// See also:
///
///  * [Transitions with animated containers](https://material.io/design/motion/choreography.html#transformation)
///    in the Material spec.
///
@optionalTypeArgs
class DialogButton<T extends Object?> extends StatefulWidget {
  /// Creates an [DialogButton].
  ///
  /// All arguments except for [key] must not be null. The arguments
  /// [openBuilder] and [closedBuilder] are required.
  const DialogButton({
    super.key,
    this.closedColor,
    this.openColor,
    this.middleColor,
    this.scrimColor = Colors.black12,
    this.closedElevation = 1.0,
    this.openElevation = 4.0,
    this.closedShape = const PContinuousRectangleBorder(cornerRadius: 16.0),
    this.openShape = const PContinuousRectangleBorder(cornerRadius: 16.0),
    this.openSize,
    this.openAlignment = Alignment.center,
    this.openPadding = EdgeInsets.zero,
    this.onClosed,
    this.openChildDismissDragOptions,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionType = ContainerTransitionType.fade,
    this.useRootNavigator = false,
    this.routeSettings,
    this.clipBehavior = Clip.antiAlias,
    this.transitionToOpenCurve,
    this.transitionToClosedCurve,
    required this.closedBuilder,
    required this.openBuilder,
  });

  /// Background color of the container while it is closed.
  ///
  /// When the container is opened, it will first transition from this color
  /// to [middleColor] and then transition from there to [openColor] in one
  /// smooth animation. When the container is closed, it will transition back to
  /// this color from [openColor] via [middleColor].
  ///
  /// Defaults to [Colors.white].
  ///
  final Color? closedColor;

  /// Background color of the container while it is open.
  ///
  /// When the container is closed, it will first transition from [closedColor]
  /// to [middleColor] and then transition from there to this color in one
  /// smooth animation. When the container is closed, it will transition back to
  /// [closedColor] from this color via [middleColor].
  ///
  /// Defaults to [Colors.white].
  ///
  final Color? openColor;

  /// The color to use for the background color during the transition
  /// with [ContainerTransitionType.fadeThrough].
  ///
  /// Defaults to [Theme]'s [ThemeData.canvasColor].
  ///
  final Color? middleColor;

  /// The color to use for the scrim during the transition.
  ///
  /// Defaults to [Colors.black12].
  ///
  final Color scrimColor;

  /// Elevation of the container while it is closed.
  ///
  /// When the container is opened, it will transition from this elevation to
  /// [openElevation]. When the container is closed, it will transition back
  /// from [openElevation] to this elevation.
  ///
  /// Defaults to 1.0.
  ///
  /// See [PDecors.elevation] for more information.
  ///
  final double closedElevation;

  /// Elevation of the container while it is open.
  ///
  /// When the container is opened, it will transition to this elevation from
  /// [closedElevation]. When the container is closed, it will transition back
  /// from this elevation to [closedElevation].
  ///
  /// Defaults to 4.0.
  ///
  /// See [PDecors.elevation] for more information.
  ///
  final double openElevation;

  /// Shape of the container while it is closed.
  ///
  /// When the container is opened it will transition from this shape to
  /// [openShape]. When the container is closed, it will transition back to this
  /// shape.
  ///
  /// Defaults to a [PContinuousRectangleBorder] with a corner radius of 16.0.
  ///
  final ShapeBorder closedShape;

  /// Shape of the container while it is open.
  ///
  /// When the container is opened it will transition from [closedShape] to
  /// this shape. When the container is closed, it will transition from this
  /// shape back to [closedShape].
  ///
  /// Defaults to a [PContinuousRectangleBorder] with a corner radius of 16.0.
  ///
  final ShapeBorder openShape;

  /// Size of the open container.
  ///
  /// If non-null, the container will open to this size. If null, the container
  /// will open to fill the surrounding [Navigator].
  ///
  /// Defaults to null.
  ///
  final Size? openSize;

  /// Padding of the open container.
  ///
  /// This padding is applied within the bounds of the enclosing [Navigator] or
  /// the [openSize] if it is non-null.
  ///
  /// Defaults to [EdgeInsets.zero].
  ///
  final EdgeInsets openPadding;

  /// Called when the container was popped and has returned to the closed state.
  ///
  /// The return value from the popped screen is passed to this function as an
  /// argument.
  ///
  /// If no value is returned via [Navigator.pop] or [DialogButton.openBuilder.action],
  /// `null` will be returned by default.
  ///
  final ClosedCallback<T?>? onClosed;

  /// Called to obtain the child for the container in the closed state.
  ///
  /// The [Widget] returned by this builder is faded out when the container
  /// opens and at the same time the widget returned by [openBuilder] is faded
  /// in while the container grows to fill the surrounding [Navigator].
  ///
  /// The `action` callback provided to the builder can be called to open the
  /// container.
  ///
  final CloseContainerBuilder closedBuilder;

  /// Called to obtain the child for the container in the open state.
  ///
  /// The [Widget] returned by this builder is faded in when the container
  /// opens and at the same time the widget returned by [closedBuilder] is
  /// faded out while the container grows to fill the surrounding [Navigator].
  ///
  /// The `action` callback provided to the builder can be called to close the
  /// container.
  ///
  final OpenContainerBuilder<T> openBuilder;

  /// The alignment of the open container within the bounds of the enclosing
  /// [Navigator]. Only relevant if [openSize] is non-null.
  ///
  /// Defaults to [Alignment.center].
  ///
  final Alignment openAlignment;

  /// The options to configure the dismiss drag behavior of the open child.
  ///
  /// If non-null, then the open child will be wrapped in a [DismissiblePage]
  /// and the provided options will be applied to it.
  ///
  /// If null, then the open child will not be wrapped in a [DismissiblePage].
  ///
  /// Defaults to null.
  ///
  final DismissDragOptions? openChildDismissDragOptions;

  /// The time it will take to animate the container from its closed to its
  /// open state and vice versa.
  ///
  /// Defaults to 300ms.
  ///
  final Duration transitionDuration;

  /// The type of fade transition that the container will use for its
  /// incoming and outgoing widgets.
  ///
  /// Defaults to [ContainerTransitionType.fade].
  ///
  final ContainerTransitionType transitionType;

  /// Curve used to animate the container from its closed to its open state.
  ///
  /// If left null, defaults to [Sprung.overDamped].
  ///
  final Curve? transitionToOpenCurve;

  /// Curve used to animate the container from its open to its closed state.
  ///
  /// If left null, defaults to [Sprung.overDamped].
  ///
  final Curve? transitionToClosedCurve;

  /// The [useRootNavigator] argument is used to determine whether to push the
  /// route for [openBuilder] to the Navigator furthest from or nearest to
  /// the given context.
  ///
  /// By default, [useRootNavigator] is false and the route created will push
  /// to the nearest navigator.
  ///
  final bool useRootNavigator;

  /// Provides additional data to the [openBuilder] route pushed by the Navigator.
  ///
  final RouteSettings? routeSettings;

  /// The [closedBuilder] will be clipped (or not) according to this option.
  ///
  /// Defaults to [Clip.antiAlias], and must not be null.
  ///
  final Clip clipBehavior;

  @override
  State<DialogButton<T?>> createState() => _DialogButtonState<T>();
}

class _DialogButtonState<T> extends State<DialogButton<T?>> {
  // Key used in [_OpenContainerRoute] to hide the widget returned by
  // [OpenContainer.openBuilder] in the source route while the container is
  // opening/open. A copy of that widget is included in the
  // [_OpenContainerRoute] where it fades out. To avoid issues with double
  // shadows and transparency, we hide it in the source route.
  final GlobalKey<_HideableState> _hideableKey = GlobalKey<_HideableState>();

  // Key used to steal the state of the widget returned by
  // [OpenContainer.openBuilder] from the source route and attach it to the
  // same widget included in the [_OpenContainerRoute] where it fades out.
  final GlobalKey _closedBuilderKey = GlobalKey();

  Future<void> openContainer() async {
    final theme = Theme.of(context);
    final closedColor = widget.closedColor ?? theme.colorScheme.surface;
    final middleColor = widget.middleColor ?? theme.colorScheme.surface;
    final openColor = widget.openColor ?? theme.colorScheme.surface;
    final T? data = await Navigator.of(
      context,
      rootNavigator: widget.useRootNavigator,
    ).push(
      _OpenContainerRoute<T>(
        closedColor: closedColor,
        openColor: openColor,
        middleColor: middleColor,
        scrimColor: widget.scrimColor,
        closedElevation: widget.closedElevation,
        openElevation: widget.openElevation,
        closedShape: widget.closedShape,
        openShape: widget.openShape,
        closedBuilder: widget.closedBuilder,
        openBuilder: widget.openBuilder,
        hideableKey: _hideableKey,
        closedBuilderKey: _closedBuilderKey,
        transitionDuration: widget.transitionDuration,
        transitionType: widget.transitionType,
        useRootNavigator: widget.useRootNavigator,
        routeSettings: widget.routeSettings,
        openChildDismissDragOptions: widget.openChildDismissDragOptions,
        openSize: widget.openSize,
        openPadding: widget.openPadding,
        openAlignment: widget.openAlignment,
        transitionToOpenCurve:
            widget.transitionToOpenCurve ?? Sprung.overDamped,
        transitionToClosedCurve:
            widget.transitionToClosedCurve ?? Sprung.overDamped,
      ),
    );
    widget.onClosed?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    return _Hideable(
      key: _hideableKey,
      child: Container(
        key: _closedBuilderKey,
        clipBehavior: widget.clipBehavior,
        decoration: ShapeDecoration(
          shape: widget.closedShape,
          color: widget.closedColor,
          shadows: PDecors.elevation(
            widget.closedElevation,
            isOuter:
                widget.closedColor != null && widget.closedColor!.opacity < 1.0,
          ),
        ),
        child: widget.closedBuilder(context, openContainer),
      ),
    );
  }
}

/// Controls the visibility of its child.
///
/// The child can be in one of three states:
///
///  * It is included in the tree and fully visible. (The `placeholderSize` is
///    null and `isVisible` is true.)
///  * It is included in the tree, but not visible; its size is maintained.
///    (The `placeholderSize` is null and `isVisible` is false.)
///  * It is not included in the tree. Instead a [SizedBox] of dimensions
///    specified by `placeholderSize` is included in the tree. (The value of
///    `isVisible` is ignored).
class _Hideable extends StatefulWidget {
  const _Hideable({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<_Hideable> createState() => _HideableState();
}

class _HideableState extends State<_Hideable> {
  /// When non-null the child is replaced by a [SizedBox] of the set size.
  Size? get placeholderSize => _placeholderSize;
  Size? _placeholderSize;
  set placeholderSize(Size? value) {
    if (_placeholderSize == value) {
      return;
    }
    setState(() {
      _placeholderSize = value;
    });
  }

  /// When true the child is not visible, but will maintain its size.
  ///
  /// The value of this property is ignored when [placeholderSize] is non-null
  /// (i.e. [isInTree] returns false).
  bool get isVisible => _visible;
  bool _visible = true;
  set isVisible(bool value) {
    if (_visible == value) {
      return;
    }
    setState(() {
      _visible = value;
    });
  }

  /// Whether the child is currently included in the tree.
  ///
  /// When it is included, it may be visible or not according to [isVisible].
  bool get isInTree => _placeholderSize == null;

  @override
  Widget build(BuildContext context) {
    if (_placeholderSize != null) {
      return SizedBox.fromSize(size: _placeholderSize);
    }
    return Visibility.maintain(
      visible: _visible,
      child: widget.child,
    );
  }
}

class _OpenContainerRoute<T> extends ModalRoute<T> {
  _OpenContainerRoute({
    required this.closedColor,
    required this.openColor,
    required this.middleColor,
    required this.scrimColor,
    required double closedElevation,
    required this.openElevation,
    required ShapeBorder closedShape,
    required this.openShape,
    required this.closedBuilder,
    required this.openBuilder,
    required this.hideableKey,
    required this.closedBuilderKey,
    required this.transitionDuration,
    required this.transitionType,
    required this.useRootNavigator,
    required RouteSettings? routeSettings,
    required this.openChildDismissDragOptions,
    required this.openSize,
    required this.openPadding,
    required this.openAlignment,
    required this.transitionToOpenCurve,
    required this.transitionToClosedCurve,
  })  : _elevationTween = Tween<double>(
          begin: closedElevation,
          end: openElevation,
        ),
        _shapeTween = ShapeBorderTween(
          begin: closedShape,
          end: openShape,
        ),
        _colorTween = _getColorTween(
          transitionType: transitionType,
          closedColor: closedColor,
          openColor: openColor,
          middleColor: middleColor,
        ),
        _closedOpacityTween = _getClosedOpacityTween(transitionType),
        _openOpacityTween = _getOpenOpacityTween(transitionType),
        super(settings: routeSettings);

  static _FlippableTweenSequence<Color?> _getColorTween({
    required ContainerTransitionType transitionType,
    required Color closedColor,
    required Color openColor,
    required Color middleColor,
  }) {
    switch (transitionType) {
      case ContainerTransitionType.fade:
        return _FlippableTweenSequence<Color?>(
          <TweenSequenceItem<Color?>>[
            TweenSequenceItem<Color>(
              tween: ConstantTween<Color>(closedColor),
              weight: 1 / 5,
            ),
            TweenSequenceItem<Color?>(
              tween: ColorTween(begin: closedColor, end: openColor),
              weight: 1 / 5,
            ),
            TweenSequenceItem<Color>(
              tween: ConstantTween<Color>(openColor),
              weight: 3 / 5,
            ),
          ],
        );
      case ContainerTransitionType.fadeThrough:
        return _FlippableTweenSequence<Color?>(
          <TweenSequenceItem<Color?>>[
            TweenSequenceItem<Color?>(
              tween: ColorTween(begin: closedColor, end: middleColor),
              weight: 1 / 5,
            ),
            TweenSequenceItem<Color?>(
              tween: ColorTween(begin: middleColor, end: openColor),
              weight: 4 / 5,
            ),
          ],
        );
    }
  }

  static _FlippableTweenSequence<double> _getClosedOpacityTween(
    ContainerTransitionType transitionType,
  ) {
    switch (transitionType) {
      case ContainerTransitionType.fade:
        return _FlippableTweenSequence<double>(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(1.0),
              weight: 1,
            ),
          ],
        );
      case ContainerTransitionType.fadeThrough:
        return _FlippableTweenSequence<double>(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween<double>(begin: 1.0, end: 0.0),
              weight: 1 / 5,
            ),
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(0.0),
              weight: 4 / 5,
            ),
          ],
        );
    }
  }

  static _FlippableTweenSequence<double> _getOpenOpacityTween(
    ContainerTransitionType transitionType,
  ) {
    switch (transitionType) {
      case ContainerTransitionType.fade:
        return _FlippableTweenSequence<double>(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(0.0),
              weight: 1 / 5,
            ),
            TweenSequenceItem<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              weight: 1 / 5,
            ),
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(1.0),
              weight: 3 / 5,
            ),
          ],
        );
      case ContainerTransitionType.fadeThrough:
        return _FlippableTweenSequence<double>(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(0.0),
              weight: 1 / 5,
            ),
            TweenSequenceItem<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              weight: 4 / 5,
            ),
          ],
        );
    }
  }

  final Color closedColor;
  final Color openColor;
  final Color middleColor;
  final Color scrimColor;
  final double openElevation;
  final ShapeBorder openShape;
  final CloseContainerBuilder closedBuilder;
  final OpenContainerBuilder<T> openBuilder;
  final Size? openSize;
  final EdgeInsets openPadding;
  final Alignment openAlignment;
  final Curve transitionToOpenCurve, transitionToClosedCurve;

  // See [_OpenContainerState._hideableKey].
  final GlobalKey<_HideableState> hideableKey;

  // See [_OpenContainerState._closedBuilderKey].
  final GlobalKey closedBuilderKey;

  // Drag options of open child.
  final DismissDragOptions? openChildDismissDragOptions;

  @override
  final Duration transitionDuration;
  final ContainerTransitionType transitionType;

  final bool useRootNavigator;

  final Tween<double> _elevationTween;
  final ShapeBorderTween _shapeTween;
  final _FlippableTweenSequence<double> _closedOpacityTween;
  final _FlippableTweenSequence<double> _openOpacityTween;
  final _FlippableTweenSequence<Color?> _colorTween;

  late final TweenSequence<Color?> _scrimFadeInTween = TweenSequence<Color?>(
    <TweenSequenceItem<Color?>>[
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: Colors.transparent, end: scrimColor),
        weight: 1 / 5,
      ),
      TweenSequenceItem<Color>(
        tween: ConstantTween<Color>(scrimColor),
        weight: 4 / 5,
      ),
    ],
  );
  late final Tween<Color?> _scrimFadeOutTween = ColorTween(
    begin: Colors.transparent,
    end: scrimColor,
  );

  // Key used for the widget returned by [OpenContainer.openBuilder] to keep
  // its state when the shape of the widget tree is changed at the end of the
  // animation to remove all the craft that was necessary to make the animation
  // work.
  final GlobalKey _openBuilderKey = GlobalKey();

  // Defines the position and the size of the (opening) [OpenContainer] within
  // the bounds of the enclosing [Navigator] or the openSize if it is non-null.
  final RectTween _rectTween = RectTween();

  // Left padding
  final Tween<double> _leftPadTween = Tween<double>();

  // Top padding
  final Tween<double> _topPadTween = Tween<double>();

  AnimationStatus? _lastAnimationStatus;
  AnimationStatus? _currentAnimationStatus;

  @override
  TickerFuture didPush() {
    _takeMeasurements(navigatorContext: hideableKey.currentContext!);

    animation!.addStatusListener((AnimationStatus status) {
      _lastAnimationStatus = _currentAnimationStatus;
      _currentAnimationStatus = status;
      switch (status) {
        case AnimationStatus.dismissed:
          _toggleHideable(hide: false);
        case AnimationStatus.completed:
          _toggleHideable(hide: true);
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    });

    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    _takeMeasurements(
      navigatorContext: subtreeContext!,
      delayForSourceRoute: true,
    );
    return super.didPop(result);
  }

  @override
  void dispose() {
    if (hideableKey.currentState?.isVisible == false) {
      // This route may be disposed without dismissing its animation if it is
      // removed by the navigator.
      SchedulerBinding.instance
          .addPostFrameCallback((Duration d) => _toggleHideable(hide: false));
    }
    super.dispose();
  }

  void _toggleHideable({required bool hide}) {
    if (hideableKey.currentState != null) {
      hideableKey.currentState!
        ..placeholderSize = null
        ..isVisible = !hide;
    }
  }

  void _takeMeasurements({
    required BuildContext navigatorContext,
    bool delayForSourceRoute = false,
  }) {
    final RenderBox navigator = Navigator.of(
      navigatorContext,
      rootNavigator: useRootNavigator,
    ).context.findRenderObject()! as RenderBox;
    final navSize = _getSize(navigator);
    final Size desiredSize = openSize ?? navSize;
    _rectTween.end = Offset.zero & desiredSize;
    _leftPadTween.end = max(
      0.0,
      (navSize.width - desiredSize.width) / 2 * (1 + openAlignment.x),
    );
    _topPadTween.end = max(
      0.0,
      (navSize.height - desiredSize.height) / 2 * (1 + openAlignment.y),
    );

    void takeMeasurementsInSourceRoute([Duration? _]) {
      if (!navigator.attached || hideableKey.currentContext == null) {
        return;
      }
      _rectTween.begin = _getRect(hideableKey, navigator);
      _leftPadTween.begin = _rectTween.begin!.left;
      _topPadTween.begin = _rectTween.begin!.top;
      hideableKey.currentState!.placeholderSize = _rectTween.begin!.size;
    }

    if (delayForSourceRoute) {
      SchedulerBinding.instance
          .addPostFrameCallback(takeMeasurementsInSourceRoute);
    } else {
      takeMeasurementsInSourceRoute();
    }
  }

  Size _getSize(RenderBox render) {
    assert(render.hasSize);
    return render.size;
  }

  // Returns the bounds of the [RenderObject] identified by `key` in the
  // coordinate system of `ancestor`.
  Rect _getRect(GlobalKey key, RenderBox ancestor) {
    assert(key.currentContext != null);
    assert(ancestor.hasSize);
    final RenderBox render =
        key.currentContext!.findRenderObject()! as RenderBox;
    assert(render.hasSize);
    return MatrixUtils.transformRect(
      render.getTransformTo(ancestor),
      Offset.zero & render.size,
    );
  }

  bool get _transitionWasInterrupted {
    bool wasInProgress = false;
    bool isInProgress = false;

    switch (_currentAnimationStatus) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        isInProgress = false;
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        isInProgress = true;
      case null:
        break;
    }
    switch (_lastAnimationStatus) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        wasInProgress = false;
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        wasInProgress = true;
      case null:
        break;
    }
    return wasInProgress && isInProgress;
  }

  void closeContainer({T? returnValue}) {
    Navigator.of(subtreeContext!).pop(returnValue);
  }

  Widget wrappedOpenBuilder(BuildContext context) {
    return _WrappedDraggableOpenChild(
      closeContainer: closeContainer,
      dragOptions: openChildDismissDragOptions,
      child: openBuilder(context, closeContainer),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          if (animation.isCompleted) {
            return SizedBox.expand(
              child: ColoredBox(
                color: scrimColor,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: closeContainer,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Align(
                      alignment: openAlignment,
                      child: SizedBox(
                        width: openSize?.width,
                        height: openSize?.height,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: ShapeDecoration(
                              color: openColor,
                              shape: openShape,
                              shadows: PDecors.elevation(
                                openElevation,
                                isOuter: openColor.opacity < 1.0,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: openPadding,
                            child: Builder(
                              key: _openBuilderKey,
                              builder: wrappedOpenBuilder,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          final curve = animation.status == AnimationStatus.forward
              ? transitionToOpenCurve
              : transitionToClosedCurve;
          final Animation<double> curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
            reverseCurve: _transitionWasInterrupted ? null : curve.flipped,
          );
          TweenSequence<Color?>? colorTween;
          TweenSequence<double>? closedOpacityTween, openOpacityTween;
          Animatable<Color?>? scrimTween;
          switch (animation.status) {
            case AnimationStatus.dismissed:
            case AnimationStatus.forward:
              closedOpacityTween = _closedOpacityTween;
              openOpacityTween = _openOpacityTween;
              colorTween = _colorTween;
              scrimTween = _scrimFadeInTween;
            case AnimationStatus.reverse:
              if (_transitionWasInterrupted) {
                closedOpacityTween = _closedOpacityTween;
                openOpacityTween = _openOpacityTween;
                colorTween = _colorTween;
                scrimTween = _scrimFadeInTween;
                break;
              }
              closedOpacityTween = _closedOpacityTween.flipped;
              openOpacityTween = _openOpacityTween.flipped;
              colorTween = _colorTween.flipped;
              scrimTween = _scrimFadeOutTween;
            case AnimationStatus.completed:
              assert(false); // Unreachable.
          }

          assert(colorTween != null);
          assert(closedOpacityTween != null);
          assert(openOpacityTween != null);
          assert(scrimTween != null);

          final Rect rect = _rectTween.evaluate(curvedAnimation)!;
          final double leftPad = _leftPadTween.evaluate(curvedAnimation);
          final double topPad = _topPadTween.evaluate(curvedAnimation);
          final color = colorTween!.evaluate(curvedAnimation);

          return SizedBox.expand(
            child: Container(
              color: scrimTween!.evaluate(curvedAnimation),
              child: Align(
                alignment: Alignment.topLeft,
                child: Transform.translate(
                  // offset: Offset(rect.left, rect.top),
                  offset: Offset(leftPad, topPad),
                  child: SizedBox(
                    width: rect.width,
                    height: rect.height,
                    child: Material(
                      animationDuration: Duration.zero,
                      color: Colors.transparent,
                      child: Container(
                        decoration: ShapeDecoration(
                          color: color,
                          shape: _shapeTween.evaluate(curvedAnimation)!,
                          shadows: PDecors.elevation(
                            _elevationTween.evaluate(curvedAnimation),
                            isOuter: color != null && color.opacity < 1.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        margin: openPadding,
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: <Widget>[
                            // Closed child fading out.
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: _rectTween.begin!.width,
                                height: _rectTween.begin!.height,
                                child: (hideableKey.currentState?.isInTree ??
                                        false)
                                    ? null
                                    : FadeTransition(
                                        opacity: closedOpacityTween!
                                            .animate(animation),
                                        child: Builder(
                                          key: closedBuilderKey,
                                          builder: (BuildContext context) {
                                            // Use dummy "open container" callback
                                            // since we are in the process of opening.
                                            return closedBuilder(
                                              context,
                                              () {},
                                            );
                                          },
                                        ),
                                      ),
                              ),
                            ),

                            // Open child fading in.
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              // alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: _rectTween.end!.width,
                                height: _rectTween.end!.height,
                                child: FadeTransition(
                                  opacity: openOpacityTween!.animate(animation),
                                  child: Builder(
                                    key: _openBuilderKey,
                                    builder: wrappedOpenBuilder,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => scrimColor;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';
}

class _FlippableTweenSequence<T> extends TweenSequence<T> {
  _FlippableTweenSequence(this._items) : super(_items);

  final List<TweenSequenceItem<T>> _items;
  _FlippableTweenSequence<T>? _flipped;

  _FlippableTweenSequence<T>? get flipped {
    if (_flipped == null) {
      final List<TweenSequenceItem<T>> newItems = <TweenSequenceItem<T>>[];
      for (int i = 0; i < _items.length; i++) {
        newItems.add(
          TweenSequenceItem<T>(
            tween: _items[i].tween,
            weight: _items[_items.length - 1 - i].weight,
          ),
        );
      }
      _flipped = _FlippableTweenSequence<T>(newItems);
    }
    return _flipped;
  }
}

class _WrappedDraggableOpenChild extends StatefulWidget {
  const _WrappedDraggableOpenChild({
    required this.closeContainer,
    required this.dragOptions,
    required this.child,
  });

  final VoidCallback closeContainer;
  final DismissDragOptions? dragOptions;
  final Widget child;

  @override
  State<_WrappedDraggableOpenChild> createState() =>
      __WrappedDraggableOpenChildState();
}

class __WrappedDraggableOpenChildState
    extends State<_WrappedDraggableOpenChild> {
  bool _ignorePointer = false;

  @override
  Widget build(BuildContext context) {
    final dragOptions = widget.dragOptions;
    if (dragOptions == null) {
      return widget.child;
    }

    final child = DismissiblePage(
      isFullScreen: false,
      // startingOpacity: 0.7,
      backgroundColor: Colors.transparent,
      onDragStart: () {
        dragOptions.onDragStart?.call();
      },
      onDragEnd: () {
        dragOptions.onDragEnd?.call();
      },
      onDragUpdate: (details) {
        // debugPrint('drag update: ${details.overallDragValue}');
        final dragVal = details.overallDragValue;
        if (dragVal < 0.01 && _ignorePointer) {
          // debugPrint('ignore pointer: $_ignorePointer');
          setState(() => _ignorePointer = false);
        } else if (dragVal >= 0.01 && !_ignorePointer) {
          // debugPrint('ignore pointer: $_ignorePointer');
          setState(() => _ignorePointer = true);
        }
        dragOptions.onDragUpdate?.call(details);
      },
      direction: dragOptions.direction,
      onDismissed: () {
        widget.closeContainer();
        dragOptions.onDismissed?.call();
      },
      child: IgnorePointer(
        ignoring: _ignorePointer,
        child: widget.child,
      ),
    );

    return child;
  }
}

const _kDismissPageThreshold = 0.15;
const _transitionDuration = Duration(milliseconds: 250);

/// A page dismissible in any direction, revealing the page below and optionally
/// transforming into/back to the child widget.
///
/// See more:
/// - [TransparentRoute]
/// - [_OpenContainerRoute]
///
class DismissiblePage extends StatefulWidget {
  const DismissiblePage({
    required this.child,
    required this.onDismissed,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.isFullScreen = true,
    this.disabled = false,
    this.backgroundColor,
    this.direction = DismissiblePageDismissDirection.down,
    this.dismissThresholds = const <DismissiblePageDismissDirection, double>{},
    this.dragStartBehavior = DragStartBehavior.down,
    this.dragSensitivity = 0.7,
    this.minRadius = 7,
    this.minScale = .85,
    this.maxRadius = 30,
    this.maxTransformValue = .4,
    this.startingOpacity = 1,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.reverseDuration = const Duration(milliseconds: 200),
    super.key,
  });

  /// Called when the widget has been dismissed.
  final VoidCallback onDismissed;

  /// Called when the user starts dragging the widget.
  final VoidCallback? onDragStart;

  /// Called when the user ends dragging the widget.
  final VoidCallback? onDragEnd;

  /// Called when the widget has been dragged. (0.0 - 1.0)
  final ValueChanged<DismissiblePageDragUpdateDetails>? onDragUpdate;

  /// If true widget will ignore device padding
  /// [MediaQuery.of(context).padding]
  final bool isFullScreen;

  /// The minimum amount of scale widget can have while dragging
  /// Note that scale decreases as user drags
  final double minScale;

  /// The minimum amount fo border radius widget can have
  final double minRadius;

  /// The maximum amount of border radius widget can have while dragging
  /// Note that radius increases as user drags
  final double maxRadius;

  /// The amount of distance widget is able to drag. value (0.0 - 1.0)
  final double maxTransformValue;

  /// If true the widget will ignore gestures
  final bool disabled;

  /// Widget that should be dismissed
  final Widget child;

  /// Background color of [DismissiblePage].
  ///
  /// Defaults to [ThemeData.scaffoldBackgroundColor].
  ///
  final Color? backgroundColor;

  /// The amount of opacity [backgroundColor] will have when start dragging the widget.
  final double startingOpacity;

  /// The direction in which the widget can be dismissed.
  final DismissiblePageDismissDirection direction;

  /// The offset threshold the item has to be dragged in order to be considered
  /// dismissed. default is [_kDismissPageThreshold], value (0.0 - 1.0)
  final Map<DismissiblePageDismissDirection, double> dismissThresholds;

  /// Represents how much responsive dragging the widget will be
  /// Doesn't work on [DismissiblePageDismissDirection.multi]
  final double dragSensitivity;

  /// Determines the way that drag start behavior is handled.
  final DragStartBehavior dragStartBehavior;

  /// The amount of time the widget will spend returning to initial position if widget is not dismissed after drag
  final Duration reverseDuration;

  /// How to behave during hit tests.
  ///
  /// This defaults to [HitTestBehavior.opaque].
  final HitTestBehavior hitTestBehavior;

  @override
  State<DismissiblePage> createState() => _DismissiblePageState();
}

class _DismissiblePageState extends State<DismissiblePage> {
  bool _isAboutToDismiss = false;

  void _onDragUpdate(DismissiblePageDragUpdateDetails details) {
    final dragVal = details.overallDragValue;
    if (dragVal >= _kDismissPageThreshold && !_isAboutToDismiss) {
      HapticFeedback.lightImpact();
      _isAboutToDismiss = true;
    } else if (dragVal < _kDismissPageThreshold && _isAboutToDismiss) {
      HapticFeedback.lightImpact();
      _isAboutToDismiss = false;
    }
    widget.onDragUpdate?.call(details);
  }

  @override
  Widget build(BuildContext context) {
    final contentPadding =
        widget.isFullScreen ? EdgeInsets.zero : MediaQuery.of(context).padding;

    if (widget.disabled) {
      return DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Padding(
          padding: contentPadding,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.minRadius),
            child: widget.child,
          ),
        ),
      );
    }

    final effectiveBackgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    if (widget.direction == DismissiblePageDismissDirection.multi) {
      return ScrollConfiguration(
        behavior: const _DismissiblePageScrollBehavior(),
        child: MultiAxisDismissiblePage(
          onDismissed: widget.onDismissed,
          isFullScreen: widget.isFullScreen,
          backgroundColor: effectiveBackgroundColor,
          direction: widget.direction,
          dismissThresholds: widget.dismissThresholds,
          dragStartBehavior: widget.dragStartBehavior,
          dragSensitivity: widget.dragSensitivity,
          minRadius: widget.minRadius,
          minScale: widget.minScale,
          maxRadius: widget.maxRadius,
          maxTransformValue: widget.maxTransformValue,
          startingOpacity: widget.startingOpacity,
          onDragStart: widget.onDragStart,
          onDragEnd: widget.onDragEnd,
          onDragUpdate: _onDragUpdate,
          reverseDuration: widget.reverseDuration,
          hitTestBehavior: widget.hitTestBehavior,
          contentPadding: contentPadding,
          child: widget.child,
        ),
      );
    }
    return ScrollConfiguration(
      behavior: const _DismissiblePageScrollBehavior(),
      child: SingleAxisDismissiblePage(
        onDismissed: widget.onDismissed,
        isFullScreen: widget.isFullScreen,
        backgroundColor: effectiveBackgroundColor,
        direction: widget.direction,
        dismissThresholds: widget.dismissThresholds,
        dragStartBehavior: widget.dragStartBehavior,
        dragSensitivity: widget.dragSensitivity,
        minRadius: widget.minRadius,
        minScale: widget.minScale,
        maxRadius: widget.maxRadius,
        maxTransformValue: widget.maxTransformValue,
        startingOpacity: widget.startingOpacity,
        onDragStart: widget.onDragStart,
        onDragEnd: widget.onDragEnd,
        onDragUpdate: _onDragUpdate,
        reverseDuration: widget.reverseDuration,
        hitTestBehavior: widget.hitTestBehavior,
        contentPadding: contentPadding,
        child: widget.child,
      ),
    );
  }
}

class TransparentRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  TransparentRoute({
    required this.builder,
    required this.backgroundColor,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    this.title,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog = true,
    this.animateYOffset = true,
  });

  final WidgetBuilder builder;

  @override
  final String? title;

  /// Builds the primary contents of the route.
  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  final Color backgroundColor;

  final bool animateYOffset;

  @override
  Color get barrierColor => backgroundColor;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  @override
  bool get barrierDismissible => true;

  @override
  bool get opaque => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!animateYOffset) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// BuildContext Helper methods
extension DismissibleContextExt on BuildContext {
  /// Navigates to desired page with transparent transition background
  Future<T?> pushTransparentRoute<T>(
    WidgetBuilder builder, {
    Color backgroundColor = Colors.transparent,
    Duration transitionDuration = _transitionDuration,
    Duration reverseTransitionDuration = _transitionDuration,
    bool rootNavigator = false,
    bool animateYOffset = true,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator).push<T>(
      TransparentRoute(
        builder: builder,
        backgroundColor: backgroundColor,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        animateYOffset: animateYOffset,
      ),
    );
  }
}

/// GlobalKey Helper methods
extension GlobalKeyExtension on GlobalKey {
  ///
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

///
enum DismissiblePageDismissDirection {
  /// Can be dismissed by dragging either up or down.
  vertical,

  /// Can be dismissed by dragging either left or right.
  horizontal,

  /// Can be dismissed by dragging in the reverse of the
  /// reading direction (e.g., from right to left in left-to-right languages).
  endToStart,

  /// Can be dismissed by dragging in the reading direction
  /// (e.g., from left to right in left-to-right languages).
  startToEnd,

  /// Can be dismissed by dragging up only.
  up,

  /// Can be dismissed by dragging down only.
  down,

  /// Can be dismissed by dragging any direction.
  multi,

  /// Cannot be dismissed by dragging.
  none
}

/// Details outputted by [DismissiblePage.onDragUpdate] method
@immutable
class DismissiblePageDragUpdateDetails {
  ///
  const DismissiblePageDragUpdateDetails({
    required this.radius,
    required this.opacity,
    this.offset = Offset.zero,
    this.overallDragValue = 0.0,
    this.scale = 1.0,
  });

  final double overallDragValue;
  final double radius;
  final double opacity;
  final double scale;
  final Offset offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DismissiblePageDragUpdateDetails &&
          runtimeType == other.runtimeType &&
          offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'overallDragValue': overallDragValue,
        'radius': radius,
        'opacity': opacity,
        'scale': scale,
        'offset': offset,
      };

  @override
  String toString() => toMap().toString();
}

class _DismissiblePageScrollBehavior extends ScrollBehavior {
  const _DismissiblePageScrollBehavior();

  @override
  Widget buildOverscrollIndicator(_, Widget child, __) => child;
}

mixin _DismissiblePageMixin {
  late final AnimationController _moveController;
  int _activePointerCount = 0;

  // ignore: prefer_final_fields
  bool _dragUnderway = false;

  bool get _isActive => _dragUnderway || _moveController.isAnimating;
}

class _DismissiblePageListener extends StatelessWidget {
  const _DismissiblePageListener({
    required this.parentState,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.direction,
    required this.child,
    this.onPointerDown,
    super.key,
  });

  final _DismissiblePageMixin parentState;
  final ValueChanged<Offset> onStart;
  final ValueChanged<DragEndDetails> onEnd;
  final ValueChanged<DragUpdateDetails> onUpdate;
  final ValueChanged<PointerDownEvent>? onPointerDown;
  final DismissiblePageDismissDirection direction;
  final Widget child;

  bool get _dragUnderway => parentState._dragUnderway;

  void _startOrUpdateDrag(DragUpdateDetails? details) {
    if (details == null) {
      return;
    }
    if (_dragUnderway) {
      onUpdate(details);
    } else {
      onStart(details.globalPosition);
    }
  }

  void _updateDrag(DragUpdateDetails? details) {
    if (details != null && details.primaryDelta != null) {
      if (_dragUnderway) {
        onUpdate(details);
      }
    }
  }

  bool _isSameDirections(ScrollMetrics metrics) {
    final Axis axis = metrics.axis;
    switch (direction) {
      case DismissiblePageDismissDirection.vertical:
        return axis == Axis.vertical;
      case DismissiblePageDismissDirection.up:
        return axis == Axis.vertical && metrics.extentAfter == 0;
      case DismissiblePageDismissDirection.down:
        return axis == Axis.vertical && metrics.extentBefore == 0;
      case DismissiblePageDismissDirection.horizontal:
        return axis == Axis.horizontal;
      case DismissiblePageDismissDirection.endToStart:
        return axis == Axis.horizontal && metrics.extentAfter == 0;
      case DismissiblePageDismissDirection.startToEnd:
        return axis == Axis.horizontal && metrics.extentBefore == 0;
      case DismissiblePageDismissDirection.none:
        return false;
      case DismissiblePageDismissDirection.multi:
        return true;
    }
  }

  bool _onScrollNotification(ScrollNotification scrollInfo) {
    if (_isSameDirections(scrollInfo.metrics)) {
      if (scrollInfo is OverscrollNotification) {
        _startOrUpdateDrag(scrollInfo.dragDetails);
        return false;
      }

      if (scrollInfo is ScrollUpdateNotification) {
        if (scrollInfo.metrics.outOfRange) {
          _startOrUpdateDrag(scrollInfo.dragDetails);
        } else {
          _updateDrag(scrollInfo.dragDetails);
        }
        return false;
      }
    }

    return false;
  }

  void _onPointerDown(PointerDownEvent event) {
    parentState._activePointerCount++;
    onPointerDown?.call(event);
  }

  void _onPointerUp(_) {
    parentState._activePointerCount--;
    if (_dragUnderway && parentState._activePointerCount == 0) {
      onEnd(DragEndDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerCancel: _onPointerUp,
      onPointerUp: _onPointerUp,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: child,
      ),
    );
  }
}

@visibleForTesting
class MultiAxisDismissiblePage extends StatefulWidget {
  const MultiAxisDismissiblePage({
    required this.child,
    required this.onDismissed,
    required this.isFullScreen,
    required this.backgroundColor,
    required this.direction,
    required this.dismissThresholds,
    required this.dragStartBehavior,
    required this.dragSensitivity,
    required this.minRadius,
    required this.minScale,
    required this.maxRadius,
    required this.maxTransformValue,
    required this.startingOpacity,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onDragUpdate,
    required this.reverseDuration,
    required this.hitTestBehavior,
    required this.contentPadding,
    super.key,
  });

  final double startingOpacity;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final VoidCallback onDismissed;
  final ValueChanged<DismissiblePageDragUpdateDetails>? onDragUpdate;
  final bool isFullScreen;
  final double minScale;
  final double minRadius;
  final double maxRadius;
  final double maxTransformValue;
  final Widget child;
  final Color backgroundColor;
  final DismissiblePageDismissDirection direction;
  final Map<DismissiblePageDismissDirection, double> dismissThresholds;
  final double dragSensitivity;
  final DragStartBehavior dragStartBehavior;
  final Duration reverseDuration;
  final HitTestBehavior hitTestBehavior;
  final EdgeInsetsGeometry contentPadding;

  @protected
  MultiDragGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    return ImmediateMultiDragGestureRecognizer()..onStart = onStart;
  }

  @override
  State<MultiAxisDismissiblePage> createState() =>
      _MultiAxisDismissiblePageState();
}

class _MultiAxisDismissiblePageState extends State<MultiAxisDismissiblePage>
    with SingleTickerProviderStateMixin, _DismissiblePageMixin
    implements Drag {
  late final GestureRecognizer _recognizer;
  late final ValueNotifier<DismissiblePageDragUpdateDetails> _dragNotifier;
  Offset _startOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    final initialDetails = DismissiblePageDragUpdateDetails(
      radius: widget.minRadius,
      opacity: widget.startingOpacity,
    );
    _dragNotifier = ValueNotifier(initialDetails);
    _moveController =
        AnimationController(duration: widget.reverseDuration, vsync: this);
    _moveController
      ..addStatusListener(statusListener)
      ..addListener(animationListener);
    _recognizer = widget.createRecognizer(_startDrag);
    _dragNotifier.addListener(_dragListener);
  }

  void animationListener() {
    final offset = Offset.lerp(
      _dragNotifier.value.offset,
      Offset.zero,
      Curves.easeInOut.transform(_moveController.value),
    )!;
    _updateOffset(offset);
  }

  void _updateOffset(Offset offset) {
    final k = overallDrag(offset);
    _dragNotifier.value = DismissiblePageDragUpdateDetails(
      offset: offset,
      overallDragValue: k,
      radius: lerpDouble(widget.minRadius, widget.maxRadius, k)!,
      opacity: (widget.startingOpacity - k).clamp(.0, 1.0),
      scale: lerpDouble(1, widget.minScale, k)!,
    );
  }

  void _dragListener() {
    widget.onDragUpdate?.call(_dragNotifier.value);
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _moveController.value = 0;
    }
  }

  double overallDrag([Offset? nullableOffset]) {
    final offset = nullableOffset ?? _dragNotifier.value.offset;
    final size = MediaQuery.of(context).size;
    final distanceOffset = offset - Offset.zero;
    final w = distanceOffset.dx.abs() / size.width;
    final h = distanceOffset.dy.abs() / size.height;
    return max(w, h);
  }

  Drag? _startDrag(Offset position) {
    if (_activePointerCount > 1) {
      return null;
    }
    _dragUnderway = true;
    final renderObject = context.findRenderObject()! as RenderBox;
    _startOffset = renderObject.globalToLocal(position);
    return this;
  }

  void _routePointer(PointerDownEvent event) {
    if (_activePointerCount > 1) {
      return;
    }
    _recognizer.addPointer(event);
  }

  @override
  void update(DragUpdateDetails details) {
    if (_activePointerCount > 1) {
      return;
    }
    _updateOffset(
      (details.globalPosition - _startOffset) * widget.dragSensitivity,
    );
  }

  @override
  void cancel() => _dragUnderway = false;

  @override
  void end(DragEndDetails _) {
    if (!_dragUnderway) {
      return;
    }
    _dragUnderway = false;
    final shouldDismiss = overallDrag() >
        (widget.dismissThresholds[DismissiblePageDismissDirection.multi] ??
            _kDismissPageThreshold);
    if (shouldDismiss) {
      widget.onDismissed();
    } else {
      _moveController.animateTo(1);
    }
  }

  void _disposeRecognizerIfInactive() {
    if (_activePointerCount > 0) {
      return;
    }
    _recognizer.dispose();
  }

  @override
  void dispose() {
    _disposeRecognizerIfInactive();
    _moveController.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DismissiblePageListener(
      parentState: this,
      onStart: _startDrag,
      onUpdate: update,
      onEnd: end,
      onPointerDown: _routePointer,
      direction: widget.direction,
      child: ValueListenableBuilder<DismissiblePageDragUpdateDetails>(
        valueListenable: _dragNotifier,
        child: widget.child,
        builder: (_, details, Widget? child) {
          final backgroundColor = widget.backgroundColor == Colors.transparent
              ? Colors.transparent
              : widget.backgroundColor.withOpacity(details.opacity);

          return Container(
            padding: widget.contentPadding,
            color: backgroundColor,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(details.offset.dx, details.offset.dy)
                ..scale(details.scale, details.scale),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(details.radius),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

@visibleForTesting
class SingleAxisDismissiblePage extends StatefulWidget {
  const SingleAxisDismissiblePage({
    required this.child,
    required this.onDismissed,
    required this.isFullScreen,
    required this.backgroundColor,
    required this.direction,
    required this.dismissThresholds,
    required this.dragStartBehavior,
    required this.dragSensitivity,
    required this.minRadius,
    required this.minScale,
    required this.maxRadius,
    required this.maxTransformValue,
    required this.startingOpacity,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onDragUpdate,
    required this.reverseDuration,
    required this.hitTestBehavior,
    required this.contentPadding,
    super.key,
  });

  final double startingOpacity;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final VoidCallback onDismissed;
  final ValueChanged<DismissiblePageDragUpdateDetails>? onDragUpdate;
  final bool isFullScreen;
  final double minScale;
  final double minRadius;
  final double maxRadius;
  final double maxTransformValue;
  final Widget child;
  final Color backgroundColor;
  final DismissiblePageDismissDirection direction;
  final Map<DismissiblePageDismissDirection, double> dismissThresholds;
  final double dragSensitivity;
  final DragStartBehavior dragStartBehavior;
  final Duration reverseDuration;
  final HitTestBehavior hitTestBehavior;
  final EdgeInsetsGeometry contentPadding;

  @override
  State<SingleAxisDismissiblePage> createState() =>
      _SingleAxisDismissiblePageState();
}

class _SingleAxisDismissiblePageState extends State<SingleAxisDismissiblePage>
    with TickerProviderStateMixin, _DismissiblePageMixin {
  late Animation<Offset> _moveAnimation;
  double _dragExtent = 0;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      duration: Duration.zero,
      vsync: this,
    );
    _moveController
      ..addStatusListener(_handleDismissStatusChanged)
      ..addListener(_moveAnimationListener);
    _updateMoveAnimation();
  }

  void _moveAnimationListener() {
    if (widget.onDragUpdate != null) {
      widget.onDragUpdate!.call(
        DismissiblePageDragUpdateDetails(
          overallDragValue:
              min(_dragExtent / context.size!.height, widget.maxTransformValue),
          radius: _radius,
          opacity: _opacity,
          offset: _offset,
          scale: _scale ?? 0.0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _moveController
      ..removeStatusListener(_handleDismissStatusChanged)
      ..removeListener(_moveAnimationListener)
      ..dispose();
    super.dispose();
  }

  bool get _directionIsXAxis {
    return widget.direction == DismissiblePageDismissDirection.horizontal ||
        widget.direction == DismissiblePageDismissDirection.endToStart ||
        widget.direction == DismissiblePageDismissDirection.startToEnd;
  }

  DismissiblePageDismissDirection? _extentToDirection(double extent) {
    if (extent == 0.0) {
      return null;
    }
    if (_directionIsXAxis) {
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          return extent < 0
              ? DismissiblePageDismissDirection.startToEnd
              : DismissiblePageDismissDirection.endToStart;
        case TextDirection.ltr:
          return extent > 0
              ? DismissiblePageDismissDirection.startToEnd
              : DismissiblePageDismissDirection.endToStart;
      }
    }
    return extent > 0
        ? DismissiblePageDismissDirection.down
        : DismissiblePageDismissDirection.up;
  }

  DismissiblePageDismissDirection? get _dismissDirection =>
      _extentToDirection(_dragExtent);

  double get _overallDragAxisExtent {
    final size = context.size;
    return _directionIsXAxis ? size!.width : size!.height;
  }

  void _handleDragStart([DragStartDetails? _]) {
    widget.onDragStart?.call();
    _dragUnderway = true;
    if (_moveController.isAnimating) {
      _dragExtent =
          _moveController.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController.stop();
    } else {
      _dragExtent = 0.0;
      _moveController.value = 0.0;
    }
    setState(_updateMoveAnimation);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController.isAnimating) {
      return;
    }

    final delta = details.primaryDelta;
    final oldDragExtent = _dragExtent;
    bool _(DismissiblePageDismissDirection d) => widget.direction == d;

    if (_(DismissiblePageDismissDirection.horizontal) ||
        _(DismissiblePageDismissDirection.vertical)) {
      _dragExtent += delta!;
    } else if (_(DismissiblePageDismissDirection.up)) {
      if (_dragExtent + delta! < 0) {
        _dragExtent += delta;
      }
    } else if (_(DismissiblePageDismissDirection.down)) {
      if (_dragExtent + delta! > 0) {
        _dragExtent += delta;
      }
    } else if (_(DismissiblePageDismissDirection.endToStart)) {
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          if (_dragExtent + delta! > 0) {
            _dragExtent += delta;
          }
        case TextDirection.ltr:
          if (_dragExtent + delta! < 0) {
            _dragExtent += delta;
          }
      }
    } else if (_(DismissiblePageDismissDirection.startToEnd)) {
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          if (_dragExtent + delta! < 0) {
            _dragExtent += delta;
          }
        case TextDirection.ltr:
          if (_dragExtent + delta! > 0) {
            _dragExtent += delta;
          }
      }
    }

    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(_updateMoveAnimation);
    }

    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  void _updateMoveAnimation() {
    final end = _dragExtent.sign * widget.dragSensitivity;
    _moveAnimation = _moveController.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: _directionIsXAxis ? Offset(end, 0) : Offset(0, end),
      ),
    );
  }

  double get _dismissThreshold =>
      widget.dismissThresholds[_dismissDirection] ?? _kDismissPageThreshold;

  void _handleDragEnd([DragEndDetails? _]) {
    if (!_isActive || _moveController.isAnimating) {
      return;
    }
    _dragUnderway = false;
    if (!_moveController.isDismissed) {
      if (_moveController.value > _dismissThreshold) {
        widget.onDismissed.call();
      } else {
        _moveController
          ..reverseDuration =
              widget.reverseDuration * (1 / _moveController.value)
          ..reverse();
        widget.onDragEnd?.call();
      }
    }
  }

  void _handleDismissStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      widget.onDismissed();
    }
  }

  double get _dragValue => _directionIsXAxis
      ? _moveAnimation.value.dx.abs()
      : _moveAnimation.value.dy.abs();

  double get _getDx {
    if (_directionIsXAxis) {
      if (_moveAnimation.value.dx.isNegative) {
        return max(_moveAnimation.value.dx, -widget.maxTransformValue);
      } else {
        return min(_moveAnimation.value.dx, widget.maxTransformValue);
      }
    }
    return _moveAnimation.value.dx;
  }

  double get _getDy {
    if (!_directionIsXAxis) {
      if (_moveAnimation.value.dy.isNegative) {
        return max(_moveAnimation.value.dy, -widget.maxTransformValue);
      } else {
        return min(_moveAnimation.value.dy, widget.maxTransformValue);
      }
    }
    return _moveAnimation.value.dy;
  }

  Offset get _offset => Offset(_getDx, _getDy);

  double? get _scale => lerpDouble(1, widget.minScale, _dragValue);

  double get _radius =>
      lerpDouble(widget.minRadius, widget.maxRadius, _dragValue)!;

  double get _opacity => (widget.startingOpacity - _dragValue).clamp(.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _directionIsXAxis ? _handleDragStart : null,
      onHorizontalDragUpdate: _directionIsXAxis ? _handleDragUpdate : null,
      onHorizontalDragEnd: _directionIsXAxis ? _handleDragEnd : null,
      onVerticalDragStart: _directionIsXAxis ? null : _handleDragStart,
      onVerticalDragUpdate: _directionIsXAxis ? null : _handleDragUpdate,
      onVerticalDragEnd: _directionIsXAxis ? null : _handleDragEnd,
      behavior: widget.hitTestBehavior,
      dragStartBehavior: widget.dragStartBehavior,
      child: _DismissiblePageListener(
        onStart: (_) => _handleDragStart(),
        onUpdate: _handleDragUpdate,
        onEnd: _handleDragEnd,
        parentState: this,
        direction: widget.direction,
        child: AnimatedBuilder(
          animation: _moveAnimation,
          builder: (BuildContext context, Widget? child) {
            final backgroundColor = widget.backgroundColor == Colors.transparent
                ? Colors.transparent
                : widget.backgroundColor.withOpacity(_opacity);

            return Container(
              padding: widget.contentPadding,
              color: backgroundColor,
              child: FractionalTranslation(
                translation: _offset,
                child: Transform.scale(
                  scale: _scale ?? 0.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_radius),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
