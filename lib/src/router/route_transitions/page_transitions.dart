import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../core/core.dart';

Page<T> adaptiveTransitionPage<T>(
  BuildContext context,
  GoRouterState state, {
  String? pageName,
  Map<String, dynamic>? arguments,
  required Widget child,
}) {
  if (Target.isWeb || Target.isNativeMacOS) {
    return NoTransitionPage<T>(
      key: state.pageKey,
      name: pageName ?? state.name,
      child: child,
    );
  }

  if (Target.isNativeApple) {
    return CupertinoPage<T>(
      key: state.pageKey,
      name: pageName ?? state.name,
      child: PStackedTransition(child: child),
    );
  }

  return MaterialPage<T>(
    key: state.pageKey,
    name: pageName ?? state.name,
    child: child,
  );
}

CustomTransitionPage<T> fadeTransitionPage<T>(
  GoRouterState state, {
  Duration transitionDuration = PEffects.shortDuration,
  Duration reverseTransitionDuration = PEffects.shortDuration,
  Curve curve = Curves.ease,
  bool opaque = true,
  Color barrierColor = Colors.black,
  String? name,
  Object? arguments,
  required Widget child,
}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      opaque: opaque,
      barrierColor: barrierColor,
      name: state.name ?? name,
      arguments: arguments,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: curve),
        child: PStackedTransition(child: child),
      ),
    );

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    this.curve = Curves.ease,
    this.opaque = true,
    this.transitionDuration = PEffects.shortDuration,
    this.barrierColor = Colors.black,
    this.settings = const RouteSettings(),
    required this.builder,
  }) : _fadeThrough = false;

  FadePageRoute.fadeThrough({
    this.curve = Curves.ease,
    this.opaque = true,
    this.transitionDuration = PEffects.shortDuration,
    this.barrierColor = Colors.black,
    this.settings = const RouteSettings(),
    required this.builder,
  }) : _fadeThrough = true;

  @override
  final Color barrierColor;

  @override
  final Duration transitionDuration;

  final Curve curve;

  final WidgetBuilder builder;

  @override
  final bool opaque;

  final bool _fadeThrough;

  @override
  final RouteSettings settings;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget child = builder(context);
    child = PStackedTransition(child: child);
    if (_fadeThrough) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    }
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  bool get maintainState => true;
}

class PStackedTransition extends StatelessWidget {
  const PStackedTransition({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Target.isNativeMobile) {
      return CupertinoStackedTransition(
        cornerRadius: Tween(begin: 48.0, end: 16.0),
        child: child,
      );
    }
    return child;
  }
}
