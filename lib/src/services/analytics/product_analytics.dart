import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class ProductAnalytics {
  factory ProductAnalytics() {
    return _instance;
  }

  ProductAnalytics._();

  static final _instance = ProductAnalytics._();
  static final _navigatorObserver = PosthogObserver(
    routeFilter: (route) {
      debugPrint('PosthogObserver -- isPageRoute: ${route is PageRoute}');
      return route is PageRoute;
    },
  );

  static NavigatorObserver get navigatorObserver {
    assert(!kDebugMode);
    return _navigatorObserver;
  }

  final Map<String, DateTime> _eventTimers = {};
  final Map<String, int> _eventCounts = {};
  static DateTime get now => DateTime.now();

  /// Track and send an event to Posthog.
  ///
  /// This method allows for tracking of arbitrary events with optional
  /// properties and should only be used for events that are not already
  /// covered by the other methods in this class.
  ///
  void trackEvent(String event, [Map<String, dynamic>? properties]) {
    if (kDebugMode) {
      debugPrint(
        'DEBUG -- Skipping $event.\n'
        'Properties: ${const JsonEncoder().convert(properties)}',
      );
      return;
    }
    Posthog().capture(
      eventName: event,
      properties:
          properties?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// Starts a timer for an event and returns the start time.
  ///
  /// Provide a unique ID for the timer, which can be used to access or stop
  /// the timer later.
  ///
  DateTime startTimer(String timerId) {
    return _eventTimers[timerId] = now;
  }

  /// Returns the start time and duration elapsed for a started timer.
  ///
  /// If the timer was not started, the start time will be the current time and
  /// the duration will be zero.
  ///
  /// Provide the unique ID for the timer, which was used to start the timer.
  ///
  (DateTime startTimeOrNow, Duration timeElapsed) accessTimer(String timerId) {
    final startTime = _eventTimers[timerId];
    if (startTime != null) {
      final duration = now.difference(startTime);
      return (startTime, duration);
    }
    return (now, Duration.zero);
  }

  /// Stops a timer for an event and returns the start time and total duration
  /// elapsed.
  ///
  /// If the timer was not started, the start time will be the current time and
  /// the duration will be zero.
  ///
  /// Provide the unique ID for the timer, which was used to start the timer.
  ///
  (DateTime now, Duration timeElapsed) stopTimer(String timerId) {
    final startTime = _eventTimers.remove(timerId);
    if (startTime != null) {
      final duration = now.difference(startTime);
      return (now, duration);
    }
    return (now, Duration.zero);
  }

  /// Increments a counter for an event and returns the current count (after
  /// incrementing).
  ///
  /// Provide a unique ID for the counter, which can be used to access the count
  /// later or reset it.
  ///
  int incrementCounter(String counterId) {
    return _eventCounts[counterId] = (_eventCounts[counterId] ?? 0) + 1;
  }

  /// Returns the current count for a counter.
  ///
  /// If the counter was not incremented, the count will be zero.
  ///
  int accessCounter(String counterId) {
    return _eventCounts[counterId] ?? 0;
  }

  /// Resets a counter for an event and returns the final count (before
  /// resetting).
  ///
  /// If the counter was not incremented, the count will be zero.
  ///
  /// Provide a unique ID for the counter, which was used to increment the
  /// counter.
  ///
  int resetCounter(String counterId) {
    final count = _eventCounts.remove(counterId) ?? 0;
    return count;
  }
}

extension type Analytics(BuildContext context) {}

class PosthogObserver extends RouteObserver<ModalRoute<dynamic>> {
  PosthogObserver({
    required this.routeFilter,
  });

  final PostHogRouteFilter routeFilter;

  void _sendScreenView(Route<dynamic>? route) {
    if (route == null) {
      return;
    }
    var screenName = route.settings.name;
    if (screenName != null && screenName.trim().isNotEmpty) {
      if (screenName == '/') {
        screenName = "root ('/')";
      }
      final arguments = route.settings.arguments;
      debugPrint(
        'PosthogObserver -- LOGGING SCREEN -- screenName: $screenName && arguments: $arguments',
      );
      Posthog().screen(
        screenName: screenName,
        properties: arguments == null
            ? null
            : arguments is Map<String, Object>
                ? arguments
                : {
                    'arguments': arguments,
                  },
      );
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (!routeFilter(route)) {
      return;
    }
    _sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (!routeFilter(newRoute)) {
      return;
    }
    _sendScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (!routeFilter(previousRoute)) {
      return;
    }
    _sendScreenView(previousRoute);
  }
}

@immutable
class AnalyticsEvent {
  const AnalyticsEvent({
    required this.name,
    this.properties = const {},
  });

  final String name;
  final Map<String, dynamic> properties;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'properties': properties,
    };
  }

  @override
  String toString() {
    return 'AnalyticsEvent{name: $name, properties: $properties}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AnalyticsEvent &&
        other.name == name &&
        mapEquals(other.properties, properties);
  }

  @override
  int get hashCode => name.hashCode ^ properties.hashCode;

  void track() {
    ProductAnalytics().trackEvent(name, properties);
  }
}
