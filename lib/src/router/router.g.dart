// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootRouteData,
      $mainPagesShellRouteData,
    ];

RouteBase get $rootRouteData => GoRouteData.$route(
      path: '/',
      factory: $RootRouteDataExtension._fromState,
    );

extension $RootRouteDataExtension on RootRouteData {
  static RootRouteData _fromState(GoRouterState state) => const RootRouteData();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainPagesShellRouteData => ShellRouteData.$route(
      navigatorKey: MainPagesShellRouteData.$navigatorKey,
      factory: $MainPagesShellRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/home',
          name: 'home',
          parentNavigatorKey: HomePageRoute.$parentNavigatorKey,
          factory: $HomePageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/projects',
          name: 'projects',
          parentNavigatorKey: ProjectsPageRoute.$parentNavigatorKey,
          factory: $ProjectsPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/contact',
          name: 'contact',
          parentNavigatorKey: ContactPageRoute.$parentNavigatorKey,
          factory: $ContactPageRouteExtension._fromState,
        ),
      ],
    );

extension $MainPagesShellRouteDataExtension on MainPagesShellRouteData {
  static MainPagesShellRouteData _fromState(GoRouterState state) =>
      const MainPagesShellRouteData();
}

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProjectsPageRouteExtension on ProjectsPageRoute {
  static ProjectsPageRoute _fromState(GoRouterState state) =>
      const ProjectsPageRoute();

  String get location => GoRouteData.$location(
        '/projects',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContactPageRouteExtension on ContactPageRoute {
  static ContactPageRoute _fromState(GoRouterState state) =>
      const ContactPageRoute();

  String get location => GoRouteData.$location(
        '/contact',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
