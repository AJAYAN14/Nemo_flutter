import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/statistics_screen.dart';
import '../presentation/today_statistics_screen.dart';
import '../presentation/activity_heatmap_screen.dart';
import '../presentation/historical_statistics_screen.dart';
import '../presentation/learning_calendar_screen.dart';
import '../presentation/leech_management_screen.dart';

abstract final class StatisticsRoutePaths {
  static const String root = '/statistics';
  static const String heatmap = 'heatmap';
  static const String history = 'history';
  static const String calendar = 'calendar';
  static const String leech = 'leech';
  static const String today = 'today';
}

abstract final class StatisticsRouteNames {
  static const String root = 'statistics';
  static const String heatmap = 'statistics_heatmap';
  static const String history = 'statistics_history';
  static const String calendar = 'statistics_calendar';
  static const String leech = 'statistics_leech';
  static const String today = 'statistics_today';
}

abstract final class StatisticsRoutes {
  static Widget buildStatisticsScreen() => const StatisticsScreen();
  static Widget buildHeatmapScreen() => const ActivityHeatmapScreen();
  static Widget buildHistoryScreen() => const HistoricalStatisticsScreen();
  static Widget buildCalendarScreen() => const LearningCalendarScreen();
  static Widget buildLeechScreen() => const LeechManagementScreen();
  static Widget buildTodayStatisticsScreen() => const TodayStatisticsScreen();
 
  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: '/statistics/heatmap',
        name: StatisticsRouteNames.heatmap,
        builder: (context, state) => buildHeatmapScreen(),
      ),
      GoRoute(
        path: '/statistics/history',
        name: StatisticsRouteNames.history,
        builder: (context, state) => buildHistoryScreen(),
      ),
      GoRoute(
        path: '/statistics/calendar',
        name: StatisticsRouteNames.calendar,
        builder: (context, state) => buildCalendarScreen(),
      ),
      GoRoute(
        path: '/statistics/leech',
        name: StatisticsRouteNames.leech,
        builder: (context, state) => buildLeechScreen(),
      ),
      GoRoute(
        path: '/statistics/today',
        name: StatisticsRouteNames.today,
        builder: (context, state) => buildTodayStatisticsScreen(),
      ),
    ];
  }
 
  static List<StatefulShellBranch> shellBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: StatisticsRoutePaths.root,
            name: StatisticsRouteNames.root,
            builder: (context, state) => buildStatisticsScreen(),
          ),
        ],
      ),
    ];
  }
}
