import 'package:flutter/material.dart';
import 'package:mindly/feature/activity/presentation/pages/achievement_details_screen.dart';
import 'package:mindly/feature/activity/presentation/pages/notifications_screen.dart';
import 'package:mindly/feature/explore/presentation/pages/category_screen.dart';
import 'package:mindly/feature/explore/presentation/pages/search_screen.dart';
import 'package:mindly/feature/navigation/app_shell.dart';
import 'package:mindly/feature/profile/presentation/pages/edit_profile_screen.dart';
import 'package:mindly/feature/profile/presentation/pages/settings_screen.dart';
import 'package:mindly/feature/quiz/presentation/pages/quiz_details_screen.dart';
import 'package:mindly/feature/quiz/presentation/pages/quiz_play_screen.dart';
import 'package:mindly/feature/quiz/presentation/pages/quiz_result_screen.dart';
import 'package:mindly/route/route_analytics_oberver.dart';

abstract class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final analyticsObserver = RouteAnalyticsObserver();
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();
  static const main = '/main';
  static const quizDetails = '/quiz_details';
  static const quizPlay = '/quiz_play';
  static const quizResult = '/quiz_result';
  static const category = '/category';
  static const search = '/search';
  static const settings = '/settings';
  static const editProfile = '/edit_profile';
  static const notifications = '/notifications';
  static const achievementDetails = '/achievement';

  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case main:
        return _fade(routeSettings, const AppShell());

      case quizDetails:
        return _slide(routeSettings, QuizDetailsScreen(quizId: args as String? ?? ''));

      case quizPlay:
        return _slide(routeSettings, QuizPlayScreen(quizId: args as String? ?? ''));

      case quizResult:
        return _fade(routeSettings, const QuizResultScreen());

      case category:
        return _slide(routeSettings, CategoryScreen(categoryId: args as String? ?? ''));

      case search:
        return _slide(routeSettings, const SearchScreen());

      case settings:
        return _slide(routeSettings, const SettingsScreen());

      case editProfile:
        return _slide(routeSettings, const EditProfileScreen());

      case notifications:
        return _slide(routeSettings, const NotificationsScreen());

      case achievementDetails:
        return _slide(routeSettings, AchievementDetailsScreen(achievementId: args as String? ?? ''));

      default:
        return _noAnim(routeSettings, const AppShell());
    }
  }

  static Route<dynamic> _noAnim(RouteSettings routeSettings, Widget page) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  /// Fade
  static Route<dynamic> _fade(RouteSettings routeSettings, Widget page) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    );
  }

  /// Slide
  static Route<dynamic> _slide(RouteSettings routeSettings, Widget page) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
          child: child,
        );
      },
    );
  }
}
