import 'package:core_ui/core_ui.dart';
import 'package:feature_learning/feature_learning.dart' as learning;
import 'package:feature_test/feature_test.dart' as test;
// import 'package:feature_test/src/unified/unified_test_screen.dart'; // Temporarily handled by test module export if needed
import 'package:feature_user/feature_user.dart';
import 'package:feature_statistics/feature_statistics.dart';
import 'package:feature_collection/feature_collection.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:feature_library/feature_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../features/sorting_test/sorting_screen.dart';
import '../../features/multiple_choice/multiple_choice_screen.dart';
import '../../features/typing/typing_screen.dart';
import '../../features/card_matching/card_matching_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
        // 新增：三种题型UI独立预览路由
        GoRoute(
          path: AppRoutes.sortingTest,
          builder: (context, state) => const SortingScreen(),
        ),
        GoRoute(
          path: AppRoutes.multipleChoiceTest,
          builder: (context, state) => const MultipleChoiceScreen(),
        ),
        GoRoute(
          path: AppRoutes.typingTest,
          builder: (context, state) => const TypingScreen(),
        ),
        GoRoute(
          path: AppRoutes.cardMatchingTest,
          builder: (context, state) => const CardMatchingScreen(),
        ),
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => NemoSplashScreen(
        onTimeout: () => context.go(AppRoutes.login),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => NemoLoginScreen(
        onAuthSuccess: () => context.go(learning.LearningRoutePaths.home),
      ),
    ),
    ...learning.LearningRoutes.rootRoutes(),
    ...StatisticsRoutes.rootRoutes(),
    ...test.TestRoutes.rootRoutes(),
    ...SettingsRoutes.rootRoutes(),
    ...UserRoutes.rootRoutes(),
    ...LibraryRoutes.rootRoutes(),
    GoRoute(
      path: CollectionRoutePaths.root,
      name: CollectionRouteNames.root,
      builder: (context, state) => CollectionRoutes.buildFavoritesScreen(),
      routes: [
        GoRoute(
          path: CollectionRoutePaths.favorites,
          name: CollectionRouteNames.favorites,
          builder: (context, state) => CollectionRoutes.buildFavoritesScreen(),
        ),
        GoRoute(
          path: CollectionRoutePaths.mistakes,
          name: CollectionRouteNames.mistakes,
          builder: (context, state) => CollectionRoutes.buildMistakesScreen(),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NemoMainShell(
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          child: navigationShell,
        );
      },
      branches: [
        ...learning.LearningRoutes.shellBranches(),
        ...StatisticsRoutes.shellBranches(),
        ...test.TestRoutes.shellBranches(),
        ...SettingsRoutes.shellBranches(),
      ],
    ),
  ],
);

