import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FadeThroughTransitionPageWrapper<T> extends Page<T> {
  const FadeThroughTransitionPageWrapper({
    required this.page,
    required this.transitionKey,
  }) : super(key: transitionKey);

  final Widget page;
  // ignore: strict_raw_type
  final ValueKey transitionKey;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    );
  }
}

class SharedAxisTransitionPageWrapper<T> extends Page<T> {
  const SharedAxisTransitionPageWrapper({
    required this.screen,
    required this.transitionKey,
  }) : super(key: transitionKey);

  final Widget screen;
  // ignore: strict_raw_type
  final ValueKey transitionKey;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          fillColor: Theme.of(context).cardColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return screen;
      },
    );
  }
}
