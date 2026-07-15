import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindly/route/app_router.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);

        debugPrint('══════════════════════════════════════');
        debugPrint('Flutter Error');
        debugPrint(details.exceptionAsString());
        debugPrint(details.stack?.toString());
        debugPrint('══════════════════════════════════════');
      };

      runApp(const MindlyApp());
    },
    (error, stackTrace) {
      debugPrint('══════════════════════════════════════');
      debugPrint('Uncaught Zone Error');
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      debugPrint('══════════════════════════════════════');
    },
  );
}

class MindlyApp extends StatelessWidget {
  const MindlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindly',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
      navigatorKey: AppRoutes.navigatorKey,
      initialRoute: AppRoutes.main,
      onGenerateInitialRoutes: (initialRoute) => [AppRoutes.generateRoutes(RouteSettings(name: initialRoute))],
      onGenerateRoute: AppRoutes.generateRoutes,
      navigatorObservers: [AppRoutes.analyticsObserver, AppRoutes.routeObserver],
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
