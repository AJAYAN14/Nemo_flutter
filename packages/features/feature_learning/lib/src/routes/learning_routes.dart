import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:feature_library/feature_library.dart'; // import library module
import '../home/home_screen.dart';
import '../kana/kana_chart_screen.dart';
import '../learning/learning_screen.dart';
// import '../learning/category_card_learning_screen.dart'; // Old version
import '../review/review_screen.dart';
import '../session/session_prep_screen.dart';

abstract final class LearningRoutePaths {
  static const String home = '/home';
  static const String kana = 'kana';
  static const String sessionPrep = 'session-prep';
  static const String learning = 'learning';
  static const String review = 'review';
  static const String categoryLearning = 'learning/category/:categoryId';
}

abstract final class LearningRouteNames {
  static const String home = 'learning-home';
  static const String kana = 'learning-kana';
  static const String sessionPrep = 'learning-session-prep';
  static const String learning = 'learning-flow';
  static const String review = 'learning-review';
}

abstract final class LearningRoutes {
  static Widget buildHomeScreen() => const HomeScreen();

  static Widget buildKanaChartScreen() => const KanaChartScreen();

  static Widget buildSessionPrepScreen() => const SessionPrepScreen();

  static Widget buildLearningScreen() => const LearningScreen();

  static Widget buildReviewScreen() => const ReviewScreen();

  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: '/home/kana',
        name: LearningRouteNames.kana,
        builder: (context, state) => const KanaChartScreen(),
      ),
      GoRoute(
        path: '/home/session-prep',
        name: LearningRouteNames.sessionPrep,
        builder: (context, state) => const SessionPrepScreen(),
      ),
      GoRoute(
        path: '/home/learning',
        name: LearningRouteNames.learning,
        builder: (context, state) => const LearningScreen(),
      ),
      GoRoute(
        path: '/home/review',
        name: LearningRouteNames.review,
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: '/learning/category/:categoryId',
        name: 'learning-category',
        builder: (context, state) => CategoryWordsScreen(
          categoryId: state.pathParameters['categoryId']!,
          title: state.uri.queryParameters['title'] ?? '',
          initialMode: CategoryViewMode.card,
        ),
      ),
    ];
  }

  static List<StatefulShellBranch> shellBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: LearningRoutePaths.home,
            name: LearningRouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
    ];
  }

  // Standalone routes removal since we now have rootRoutes
}
