import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/home_screen.dart';
import '../kana/kana_chart_screen.dart';
import '../srs_study/srs_study_screen.dart' deferred as study;
import '../srs_review/srs_review_screen.dart' deferred as review;
import '../session/session_prep_screen.dart';
import '../material_browser/category_material_browser_screen.dart';
import '../util/deferred_widget.dart';

abstract final class LearningRoutePaths {
  static const String home = '/home';
  static const String kana = 'kana';
  static const String sessionPrep = 'session-prep';
  static const String srsStudy = 'study/:mode';
  static const String srsReview = 'review/:mode';
  static const String materialBrowser = 'material/category/:categoryId';
}

abstract final class LearningRouteNames {
  static const String home = 'learning-home';
  static const String kana = 'learning-kana';
  static const String sessionPrep = 'learning-session-prep';
  static const String srsStudy = 'srs-study';
  static const String srsReview = 'srs-review';
  static const String materialBrowser = 'material-browser';
}

abstract final class LearningRoutes {
  static Widget buildHomeScreen() => const HomeScreen();

  static Widget buildKanaChartScreen() => const KanaChartScreen();

  static Widget buildSessionPrepScreen() => const SessionPrepScreen();

  static Widget buildSrsStudyScreen(String mode) => DeferredWidget(
        loader: study.loadLibrary,
        builder: () => study.SrsStudyScreen(mode: mode),
      );

  static Widget buildSrsReviewScreen(String mode) => DeferredWidget(
        loader: review.loadLibrary,
        builder: () => review.SrsReviewScreen(mode: mode),
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
        path: '/home/study/:mode',
        name: LearningRouteNames.srsStudy,
        builder: (context, state) => buildSrsStudyScreen(
          state.pathParameters['mode'] ?? 'word',
        ),
      ),
      GoRoute(
        path: '/home/review/:mode',
        name: LearningRouteNames.srsReview,
        builder: (context, state) => buildSrsReviewScreen(
          state.pathParameters['mode'] ?? 'word',
        ),
      ),
      GoRoute(
        path: '/material/category/:categoryId',
        name: LearningRouteNames.materialBrowser,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          final title = state.uri.queryParameters['title'] ?? '专项训练';
          return CategoryMaterialBrowserScreen(
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
