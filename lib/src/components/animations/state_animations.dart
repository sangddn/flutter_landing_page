import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

typedef TransitionWidgetBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

class AnimatedFutureBuilder<T> extends StatelessWidget {
  const AnimatedFutureBuilder({
    this.duration = PEffects.shortDuration,
    this.axis = Axis.vertical,
    this.alignment = -1.0,
    this.initialData,
    required this.future,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final Axis axis;
  final double alignment;
  final T? initialData;
  final Future<T>? future;
  final Widget Function(BuildContext context, AsyncSnapshot<T>) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) => SizeFadeSwitcher(
        duration: duration,
        axis: axis,
        axisAlignment: alignment,
        child: builder(context, snapshot),
      ),
    );
  }
}

class AnimatedFutureBuilder2<T, R> extends StatelessWidget {
  const AnimatedFutureBuilder2({
    this.duration = PEffects.shortDuration,
    this.axis = Axis.vertical,
    this.alignment = -1.0,
    this.initialData1,
    this.initialData2,
    required this.future1,
    required this.future2,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final Axis axis;
  final double alignment;
  final T? initialData1;
  final R? initialData2;
  final Future<T>? future1;
  final Future<R>? future2;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot1,
    AsyncSnapshot<R> snapshot2,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder2(
      initialData1: initialData1,
      initialData2: initialData2,
      future1: future1,
      future2: future2,
      builder: (context, snapshot1, snapshot2) => SizeFadeSwitcher(
        duration: duration,
        axis: axis,
        axisAlignment: alignment,
        child: builder(context, snapshot1, snapshot2),
      ),
    );
  }
}

class FadeFutureBuilder<T> extends StatelessWidget {
  const FadeFutureBuilder({
    this.duration = PEffects.shortDuration,
    this.initialData,
    required this.future,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final T? initialData;
  final Future<T>? future;
  final Widget Function(BuildContext context, AsyncSnapshot<T>) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) => FadeSwitcher(
        duration: duration,
        child: builder(context, snapshot),
      ),
    );
  }
}

class AnimatedStreamBuilder<T> extends StatelessWidget {
  const AnimatedStreamBuilder({
    this.duration = PEffects.shortDuration,
    this.axis = Axis.vertical,
    this.alignment = -1.0,
    this.initialData,
    required this.stream,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final Axis axis;
  final double alignment;
  final T? initialData;
  final Stream<T>? stream;
  final Widget Function(BuildContext context, AsyncSnapshot<T>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) => SizeFadeSwitcher(
        duration: duration,
        axis: axis,
        axisAlignment: alignment,
        child: builder(context, snapshot),
      ),
    );
  }
}

class FadeStreamBuilder<T> extends StatelessWidget {
  const FadeStreamBuilder({
    this.duration = PEffects.shortDuration,
    this.initialData,
    required this.stream,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final T? initialData;
  final Stream<T>? stream;
  final Widget Function(BuildContext context, AsyncSnapshot<T>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) => FadeSwitcher(
        duration: duration,
        child: builder(context, snapshot),
      ),
    );
  }
}

/// An animated version of Flutter's [State].
///
/// The default animation is a [SizeFadeSwitcher]. Override [buildAnimation] to
/// customize the animation.
///
abstract class AnimatedState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) =>
      buildAnimation(context, buildChild(context));

  Widget buildChild(BuildContext context);
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(child);
}

/// An animated version of Flutter's [StatelessWidget].
///
/// The default animation is a [SizeFadeSwitcher]. Override [buildAnimation] to
/// customize the animation.
///
abstract class AnimatedStatelessWidget extends StatelessWidget {
  const AnimatedStatelessWidget({super.key});

  Widget buildChild(BuildContext context);
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(child);

  @override
  Widget build(BuildContext context) =>
      buildAnimation(context, buildChild(context));
}

/// An animated, extendable version of Flutter's [FutureBuilder].
///
/// The default animation is a [SizeFadeSwitcher]. Override [buildAnimation] to
/// customize the animation.
///
abstract class AnimatedFutureWidget<T> extends StatefulWidget {
  const AnimatedFutureWidget({
    this.onLoading,
    this.onError,
    this.onSuccess,
    this.onDone,
    this.initialValue,
    required this.future,
    super.key,
  });

  final VoidCallback? onLoading;
  final T? Function(Object? error)? onError;
  final ValueChanged<T>? onSuccess;
  final VoidCallback? onDone;
  final T? initialValue;
  final Future<T> future;

  Widget buildChild(BuildContext context, T? data);
  Widget buildLoading(BuildContext context);
  Widget buildError(BuildContext context, Object error);
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.sizeFade(child);

  @override
  State<AnimatedFutureWidget<T>> createState() =>
      _AnimatedFutureWidgetState<T>();
}

class _AnimatedFutureWidgetState<T> extends State<AnimatedFutureWidget<T>> {
  late var _future = _getFuture();

  Future<T?> _getFuture() => widget.future.then((value) {
        widget.onSuccess?.call(value);
        return value;
      }).catchError((Object? error) {
        final handledError = widget.onError?.call(error);
        if (handledError != null) {
          return handledError;
        }
        throw FlutterError(
          error?.toString() ?? '_AnimatedFutureWidgetState: Unknown error',
        );
      }).whenComplete(() => widget.onDone?.call());

  @override
  void didUpdateWidget(AnimatedFutureWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.future != oldWidget.future) {
      _future = _getFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: widget.initialValue,
      future: _future,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = widget.buildLoading(context);
        } else if (snapshot.hasError) {
          child = widget.buildError(context, snapshot.error!);
        } else {
          child = widget.buildChild(context, snapshot.data);
        }
        return widget.buildAnimation(context, child);
      },
    );
  }
}

/// Pre-built high-quality animations to be used with StateAnimations.
///
class StateAnimations {
  /// Animates a widget with a fade and "re-size" effect.
  ///
  /// When the child changes, the new child will fade in and grow from the
  /// [alignment] along the [axis]. The old child will fade out and shrink.
  ///
  /// Note that the size effect always takes place, even if the layout size
  /// of the child does not change. For such cases, consider using
  /// [fadeWithAnimatedSize] instead.
  ///
  static Widget sizeFade(
    Widget child, {
    Duration duration = PEffects.shortDuration,
    Duration? reverseDuration,
    Axis axis = Axis.vertical,
    double alignment = -1.0,
    Curve switchInCurve = Curves.easeOut,
    Curve switchOutCurve = Curves.easeIn,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    bool enableBlur = false,
    bool enableScale = false,
  }) =>
      SizeFadeSwitcher(
        duration: duration,
        reverseDuration: reverseDuration,
        axis: axis,
        axisAlignment: alignment,
        switchInCurve: switchInCurve,
        switchOutCurve: switchOutCurve,
        layoutBuilder: layoutBuilder,
        enableBlur: enableBlur,
        enableScale: enableScale,
        child: child,
      );

  /// Animates a widget with a fade effect and, if the layout changes, an animated
  /// size effect.
  ///
  /// When the child changes, the new child will fade in and if its layout
  /// size also changes, it will animate to the new size.
  ///
  static Widget fadeWithAnimatedSize(
    Widget child, {
    Alignment alignment = Alignment.center,
    Duration duration = PEffects.shortDuration,
    Duration? reverseDuration,
    Curve curve = Curves.easeOutCirc,
  }) =>
      AnimatedSize(
        duration: duration ~/ 2,
        reverseDuration: reverseDuration?.let((d) => d ~/ 2),
        curve: curve,
        alignment: alignment,
        child: FadeSwitcher(
          duration: duration ~/ 2,
          reverseDuration: reverseDuration?.let((d) => d ~/ 2),
          switchInCurve: curve,
          switchOutCurve: curve,
          layoutBuilder: alignedLayoutBuilder(alignment),
          child: child,
        ),
      );
}
