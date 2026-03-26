import 'package:core_ui/core_ui.dart';
import 'package:feature_collection/feature_collection.dart' deferred as collection;
import 'package:feature_learning/feature_learning.dart' as learning;
import 'package:feature_library/feature_library.dart' deferred as library_module;
import 'package:feature_test/feature_test.dart' as test;
import 'package:feature_user/feature_user.dart';
import 'package:feature_statistics/feature_statistics.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.sortingTest,
      redirect: (context, state) => test.TestRoutePaths.sortingTest,
    ),
    GoRoute(
      path: AppRoutes.multipleChoiceTest,
      redirect: (context, state) => test.TestRoutePaths.multipleChoiceTest,
    ),
    GoRoute(
      path: AppRoutes.typingTest,
      redirect: (context, state) => test.TestRoutePaths.typingTest,
    ),
    GoRoute(
      path: AppRoutes.cardMatchingTest,
      redirect: (context, state) => test.TestRoutePaths.cardMatchingTest,
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
    GoRoute(
      path: '/library',
      name: 'library-home',
      redirect: (context, state) {
        if (state.uri.path == '/library' || state.uri.path == '/library/') {
          return '/library/category/library';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: 'category/:source',
          name: 'library-category',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: library_module.loadLibrary,
            builder: () => library_module.CategoryClassificationScreen(
              source: state.pathParameters['source'] ?? 'practice',
            ),
          ),
        ),
        GoRoute(
          path: 'category_words/:categoryId',
          name: 'library-category-words',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: library_module.loadLibrary,
            builder: () => library_module.CategoryWordsScreen(
              categoryId: state.pathParameters['categoryId']!,
              title: state.uri.queryParameters['title'] ?? '',
            ),
          ),
        ),
        GoRoute(
          path: 'grammarList',
          name: 'library-grammar-list',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: library_module.loadLibrary,
            builder: () => library_module.GrammarListScreen(),
          ),
        ),
        GoRoute(
          path: 'wordList',
          name: 'library-word-list',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: library_module.loadLibrary,
            builder: () => library_module.WordListScreen(),
          ),
        ),
        GoRoute(
          path: 'word/:wordId',
          name: 'library-word-detail',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: library_module.loadLibrary,
            builder: () => library_module.WordDetailScreen(
              wordId: state.pathParameters['wordId']!,
            ),
          ),
        ),
        GoRoute(
          path: 'grammar/:grammarId',
          name: 'library-grammar-detail',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: library_module.loadLibrary,
            builder: () => library_module.GrammarDetailScreen(
              id: int.tryParse(state.pathParameters['grammarId'] ?? '') ?? 0,
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/collection',
      name: 'collection',
      builder: (context, state) => _buildDeferredScreen(
        loadLibrary: collection.loadLibrary,
        builder: () => collection.CollectionRoutes.buildFavoritesScreen(),
      ),
      routes: [
        GoRoute(
          path: 'favorites',
          name: 'collection_favorites',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: collection.loadLibrary,
            builder: () => collection.CollectionRoutes.buildFavoritesScreen(),
          ),
        ),
        GoRoute(
          path: 'mistakes',
          name: 'collection_mistakes',
          builder: (context, state) => _buildDeferredScreen(
            loadLibrary: collection.loadLibrary,
            builder: () => collection.CollectionRoutes.buildMistakesScreen(),
          ),
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

Widget _buildDeferredScreen({
  required Future<void> Function() loadLibrary,
  required Widget Function() builder,
}) {
  return FutureBuilder<void>(
    future: loadLibrary(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return builder();
      }
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text(
              '加载失败，请重试',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}
