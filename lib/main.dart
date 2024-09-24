import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' deferred as animate
    show Animate;
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'src/core/core.dart';
import 'src/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable debugPrint if not in debug mode
  debugPrint = (String? message, {int? wrapWidth}) {
    if (kDebugMode) {
      debugPrintThrottled(message, wrapWidth: wrapWidth);
    }
  };

  // DEBUG OPTIONS
  if (kDebugMode) {
    await animate.loadLibrary();
    animate.Animate.restartOnHotReload = true;
  }

  // Set URL strategy to path (instead of hash)
  usePathUrlStrategy();

  // Enable GoRouter to reflect imperative APIs.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Loca',
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      routerConfig: router,
    );
  }
}
