import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/home_screen.dart';
import '../kana/kana_chart_screen.dart';
import '../learning/learning_screen.dart' deferred as learning;
import '../review/review_screen.dart' deferred as review;
import '../session/session_prep_screen.dart';
import '../learning/category_card_learning_screen.dart';
import '../util/deferred_widget.dart';

abstract final class LearningRoutePaths {
  static const String home = '/home';
  static const String kana = 'kana';
  static const String sessionPrep = 'session-prep';
  static const String learning = 'learning/:mode';
  static const String review = 'review/:mode';
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

  static Widget buildLearningScreen(String mode) => DeferredWidget(
        loader: learning.loadLibrary,
        builder: () => learning.LearningScreen(mode: mode),
      );

  static Widget buildReviewScreen(String mode) => DeferredWidget(
        loader: review.loadLibrary,
        builder: () => review.ReviewScreen(mode: mode),
      );

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
        path: '/home/learning/:mode',
        name: LearningRouteNames.learning,
        builder: (context, state) => buildLearningScreen(
          state.pathParameters['mode'] ?? 'word',
        ),
      ),
      GoRoute(
        path: '/home/review/:mode',
        name: LearningRouteNames.review,
        builder: (context, state) => buildReviewScreen(
          state.pathParameters['mode'] ?? 'word',
        ),
      ),
      GoRoute(
        path: '/learning/category/:categoryId',
        name: 'learning-category',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          final title = state.uri.queryParameters['title'] ?? '专项训练';
          return CategoryCardLearningScreen(
            categoryId: categoryId,
            categoryTitle: title,
          );
        },
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
}
