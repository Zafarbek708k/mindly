import 'dart:developer' as dev;

import 'package:flutter/material.dart';

class RouteAnalyticsObserver extends NavigatorObserver {
  static void logScreen(String name) => _log('screen', name);

  static void _log(String action, String? name) {
    if (name == null || name.isEmpty) return;
    dev.log('[Analytics] $action → $name', name: 'analytics');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('push', route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('pop', route.settings.name);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log('replace', newRoute?.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('remove', route.settings.name);
    super.didRemove(route, previousRoute);
  }
}
