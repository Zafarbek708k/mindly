import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindly/core/const/static_values.dart';
import 'package:mindly/feature/activity/presentation/pages/activity_screen.dart';
import 'package:mindly/feature/common/animateed_button.dart';
import 'package:mindly/feature/explore/presentation/pages/explore_screen.dart';
import 'package:mindly/feature/home/presentation/pages/home_screen.dart';
import 'package:mindly/feature/leaderboard/presentation/pages/leaderboard_screen.dart';
import 'package:mindly/feature/profile/presentation/pages/profile_screen.dart';
import 'package:mindly/route/app_router.dart';
import 'package:mindly/route/route_analytics_oberver.dart';

enum MindlyTab {
  home('/home_screen', 'Home', Icons.home_outlined, Icons.home_rounded),
  explore('/explore_screen', 'Explore', Icons.explore_outlined, Icons.explore_rounded),
  leaderboard('/leaderboard_screen', 'Leaderboard', Icons.leaderboard_outlined, Icons.leaderboard_rounded),
  activity('/activity_screen', 'Activity', Icons.notifications_none_rounded, Icons.notifications_rounded),
  profile('/profile_screen', 'Profile', Icons.person_outline_rounded, Icons.person_rounded);

  final String path;
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const MindlyTab(this.path, this.title, this.icon, this.activeIcon);
}

class AppShellScope extends InheritedWidget {
  const AppShellScope({super.key, required this.goToTab, required super.child});

  final void Function(int index) goToTab;

  static AppShellScope? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppShellScope>();

  @override
  bool updateShouldNotify(AppShellScope oldWidget) => false;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final Map<MindlyTab, GlobalKey<NavigatorState>> _navigatorKeys = {
    for (final t in MindlyTab.values) t: GlobalKey<NavigatorState>(),
  };

  final Map<MindlyTab, RouteAnalyticsObserver> _tabObservers = {
    for (final t in MindlyTab.values) t: RouteAnalyticsObserver(),
  };

  @override
  void initState() {
    super.initState();
    RouteAnalyticsObserver.logScreen(MindlyTab.values[_index].path);
  }

  Future<bool> _onWillPop() async {
    final currentNav = _navigatorKeys[MindlyTab.values[_index]]!.currentState!;
    if (currentNav.canPop()) {
      currentNav.pop();
      return false;
    }
    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }
    return true;
  }

  void _onTabTap(int i) {
    HapticFeedback.lightImpact();
    if (_index == i) {
      _navigatorKeys[MindlyTab.values[i]]!.currentState!.popUntil((r) => r.isFirst);
      return;
    }
    setState(() => _index = i);
    RouteAnalyticsObserver.logScreen(MindlyTab.values[i].path);
  }

  void _goToTab(int i) {
    if (_index == i) return;
    setState(() => _index = i);
    RouteAnalyticsObserver.logScreen(MindlyTab.values[i].path);
  }

  @override
  Widget build(BuildContext context) {
    return AppShellScope(
      goToTab: _goToTab,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final allow = await _onWillPop();
          if (allow && mounted) SystemNavigator.pop();
        },
        child: Scaffold(
          body: Stack(
            children: List.generate(
              MindlyTab.values.length,
              (i) => Offstage(
                offstage: _index != i,
                child: _TabNavigator(
                  tab: MindlyTab.values[i],
                  navigatorKey: _navigatorKeys[MindlyTab.values[i]]!,
                  observer: _tabObservers[MindlyTab.values[i]]!,
                ),
              ),
            ),
          ),
          bottomNavigationBar: _BottomNavBar(currentIndex: _index, onTap: _onTabTap),
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.tab, required this.navigatorKey, required this.observer});

  final MindlyTab tab;
  final GlobalKey<NavigatorState> navigatorKey;
  final RouteAnalyticsObserver observer;

  Widget _root() => switch (tab) {
    MindlyTab.home => const HomeScreen(),
    MindlyTab.explore => const ExploreScreen(),
    MindlyTab.leaderboard => const LeaderboardScreen(),
    MindlyTab.activity => const ActivityScreen(),
    MindlyTab.profile => const ProfileScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [observer],
      onGenerateRoute: (settings) {
        if (settings.name == null || settings.name == Navigator.defaultRouteName) {
          return MaterialPageRoute(settings: const RouteSettings(), builder: (_) => _root());
        }
        return AppRoutes.generateRoutes(settings);
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(color: scheme.shadow.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.only(top: 8, bottom: Platform.isIOS ? bottomPad : bottomPad + 8, left: 8, right: 8),
      child: Row(
        children: List.generate(MindlyTab.values.length, (i) {
          final tab = MindlyTab.values[i];
          final active = i == currentIndex;
          final color = active ? scheme.primary : scheme.onSurfaceVariant;
          return Expanded(
            child: AnimatedButton(
              onTap: () => onTap(i),
              scaleValue: 0.94,
              child: SizedBox(
                height: 54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: AppDurations.short,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: active ? scheme.primary.withValues(alpha: 0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(active ? tab.activeIcon : tab.icon, color: color, size: 22),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tab.title,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
