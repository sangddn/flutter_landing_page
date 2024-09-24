part of 'router.dart';

const kRootHost = 'https://loca.so';

final fRootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final fMainShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'main-shell');

const debuggingRoute = HomePageRoute.routeLocation;
// const debuggingRoute = HomePageRoute.routeLocation;
// const debuggingRoute = OnboardingPageRoute.routeLocation;
// final debuggingRoute = const VerifyEmailPageRoute.location;
