part of '../router.dart';

final fHomeNavigatorKey = GlobalKey<NavigatorState>();
final fProjectsNavigatorKey = GlobalKey<NavigatorState>();
final fContactNavigatorKey = GlobalKey<NavigatorState>();

enum MainPath {
  home,
  projects,
  contact,
  ;

  GlobalKey<NavigatorState> get key => switch (this) {
        MainPath.home => fHomeNavigatorKey,
        MainPath.projects => fProjectsNavigatorKey,
        MainPath.contact => fContactNavigatorKey,
      };
}

@TypedShellRoute<MainPagesShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    HomePageRoute.routeData,
    ProjectsPageRoute.routeData,
    ContactPageRoute.routeData,
  ],
)
class MainPagesShellRouteData extends ShellRouteData {
  const MainPagesShellRouteData();

  static final $navigatorKey = fMainShellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    final index = getNavigationIndexOfMainShell(state.fullPath);
    final path = index?.let((index) => MainPath.values.elementAtOrNull(index));
    UpdateGoRouterState(state).dispatch(context);
    return Provider<MainPath?>.value(
      value: path,
      child: ResponsiveLayoutWithNav(
        key: state.pageKey,
        builder: (context, scrollController) => CupertinoTabView(
          navigatorKey: path?.key,
          builder: (context) => navigator,
        ),
      ),
    );
  }
}

/// Returns the index of the main navigation shell.
///
int? getNavigationIndexOfMainShell(String? fullPath) {
  final path = fullPath ?? '';
  if (path.contains(HomePageRoute.routeLocation)) {
    return 0;
  }
  if (path.contains(ProjectsPageRoute.routeLocation)) {
    return 1;
  }
  if (path.contains(ContactPageRoute.routeLocation)) {
    return 2;
  }
  return null; // Not a main path!
}

class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  static final $parentNavigatorKey = fMainShellNavigatorKey;
  static const routeName = 'home';
  static const routeLocation = '/$routeName';
  static const routeData = TypedGoRoute<HomePageRoute>(
    path: HomePageRoute.routeLocation,
    name: HomePageRoute.routeName,
  );

  @override
  Page<HomePage> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return adaptiveTransitionPage(
      context,
      state,
      child: const HomePage(),
    );
  }
}

class ProjectsPageRoute extends GoRouteData {
  const ProjectsPageRoute();

  static final $parentNavigatorKey = fMainShellNavigatorKey;
  static const routeName = 'projects';
  static const routeLocation = '/$routeName';
  static const routeData = TypedGoRoute<ProjectsPageRoute>(
    path: ProjectsPageRoute.routeLocation,
    name: ProjectsPageRoute.routeName,
  );

  @override
  Page<ProjectsPage> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return adaptiveTransitionPage(
      context,
      state,
      child: const ProjectsPage(),
    );
  }
}

class ContactPageRoute extends GoRouteData {
  const ContactPageRoute();

  static final $parentNavigatorKey = fMainShellNavigatorKey;
  static const routeName = 'contact';
  static const routeLocation = '/$routeName';
  static const routeData = TypedGoRoute<ContactPageRoute>(
    path: ContactPageRoute.routeLocation,
    name: ContactPageRoute.routeName,
  );

  @override
  Page<ContactPage> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return adaptiveTransitionPage(
      context,
      state,
      child: const ContactPage(),
    );
  }
}

/// A notification to update GoRouterState.
///
class UpdateGoRouterState extends Notification {
  const UpdateGoRouterState(this.state);

  final GoRouterState state;
}
