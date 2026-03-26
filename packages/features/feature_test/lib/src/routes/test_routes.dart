import 'package:core_domain/core_domain.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dashboard/test_dashboard_screen.dart';
import '../result/test_result_screen.dart';
import '../test/multiple_choice_test_screen.dart';
import '../test/test_settings_screen.dart';
import '../test/typing_test_screen.dart';
import '../test/card_matching_screen.dart';
import '../test/sorting_screen.dart';

abstract final class TestRoutePaths {
  static const String dashboard = '/test';
  static const String settings = 'settings';
  static const String result = 'result';
  static const String multipleChoiceTest = '/test/multiple-choice';
  static const String typingTest = '/test/typing';
  static const String cardMatchingTest = '/test/card-matching';
  static const String sortingTest = '/test/sorting';
}

abstract final class TestRouteNames {
  static const String dashboard = 'test-dashboard';
  static const String settings = 'test-settings';
  static const String result = 'test-result';
  static const String multipleChoiceTest = 'multiple-choice-test';
  static const String typingTest = 'typing-test';
  static const String cardMatchingTest = 'card-matching-test';
  static const String sortingTest = 'sorting-test';
}

abstract final class TestRoutes {
  static Widget buildTestDashboardScreen() => const TestDashboardScreen();
  static Widget buildTestSettingsScreen({String? modeId}) => TestSettingsScreen(testModeId: modeId);
  static Widget buildTestResultScreen({required TestResult result, required VoidCallback onRetake, required VoidCallback onExit}) => 
    TestResultScreen(result: result, onRetakeTest: onRetake, onExit: onExit);

  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: '/test/settings',
        name: TestRouteNames.settings,
        builder: (context, state) {
          final modeId = state.uri.queryParameters['modeId'];
          return TestSettingsScreen(testModeId: modeId);
        },
      ),
      GoRoute(
        path: '/test/result',
        name: TestRouteNames.result,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final result = extra?['result'] as TestResult;
          final onRetake = extra?['onRetake'] as VoidCallback;
          final onExit = extra?['onExit'] as VoidCallback;
          
          return TestResultScreen(
            result: result,
            onRetakeTest: onRetake,
            onExit: onExit,
          );
        },
      ),
      GoRoute(
        path: TestRoutePaths.multipleChoiceTest,
        name: TestRouteNames.multipleChoiceTest,
        builder: (context, state) => const MultipleChoiceTestScreen(),
      ),
      GoRoute(
        path: TestRoutePaths.typingTest,
        name: TestRouteNames.typingTest,
        builder: (context, state) => const TypingTestScreen(),
      ),
      GoRoute(
        path: TestRoutePaths.cardMatchingTest,
        name: TestRouteNames.cardMatchingTest,
        builder: (context, state) => const CardMatchingScreen(),
      ),
      GoRoute(
        path: TestRoutePaths.sortingTest,
        name: TestRouteNames.sortingTest,
        builder: (context, state) => const SortingTestScreen(),
      ),
    ];
  }

  static List<StatefulShellBranch> shellBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: TestRoutePaths.dashboard,
            name: TestRouteNames.dashboard,
            builder: (context, state) => const TestDashboardScreen(),
          ),
        ],
      ),
    ];
  }
}
