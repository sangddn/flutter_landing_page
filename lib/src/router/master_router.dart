part of 'router.dart';

/// The master router for the app.
///
///
///
final router = GoRouter(
  navigatorKey: fRootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  observers: [],
  errorPageBuilder: (context, state) {
    debugPrint('Error routing: ${state.error}');
    return NoTransitionPage(
      key: state.pageKey,
      child: const NotFoundPage(),
    );
  },
  routes: $appRoutes,
);

@TypedGoRoute<RootRouteData>(
  path: '/',
)
class RootRouteData extends GoRouteData {
  const RootRouteData();

  @override
  String redirect(BuildContext context, GoRouterState state) =>
      HomePageRoute.routeLocation;
}
