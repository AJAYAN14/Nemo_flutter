import 'package:go_router/go_router.dart';
import '../category/category_classification_screen.dart';
import '../category/category_words_screen.dart';
import '../detail/grammar_detail_screen.dart';
import '../detail/word_detail_screen.dart';
import '../list/grammar_list_screen.dart';
import '../list/word_list_screen.dart';

abstract final class LibraryRoutePaths {
  static const String root = '/library';
  static const String category = 'category/:source';
  static const String categoryWords = 'category_words/:categoryId';
  static const String grammarList = 'grammarList';
  static const String wordList = 'wordList';
  static const String wordDetail = 'word/:wordId';
  static const String grammarDetail = 'grammar/:grammarId';
}

abstract final class LibraryRouteNames {
  static const String home = 'library-home';
  static const String category = 'library-category';
  static const String categoryWords = 'library-category-words';
  static const String grammarList = 'library-grammar-list';
  static const String wordList = 'library-word-list';
  static const String wordDetail = 'library-word-detail';
  static const String grammarDetail = 'library-grammar-detail';
}

abstract final class LibraryRoutes {
  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: LibraryRoutePaths.root,
        name: LibraryRouteNames.home,
        redirect: (context, state) {
          if (state.uri.path == '/library' || state.uri.path == '/library/') {
            return '/library/category/library';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: LibraryRoutePaths.category,
            name: LibraryRouteNames.category,
            builder: (context, state) => CategoryClassificationScreen(
              source: state.pathParameters['source'] ?? 'practice',
            ),
          ),
          GoRoute(
            path: LibraryRoutePaths.categoryWords,
            name: LibraryRouteNames.categoryWords,
            builder: (context, state) => CategoryWordsScreen(
              categoryId: state.pathParameters['categoryId']!,
              title: state.uri.queryParameters['title'] ?? '',
            ),
          ),
          GoRoute(
            path: LibraryRoutePaths.grammarList,
            name: LibraryRouteNames.grammarList,
            builder: (context, state) => const GrammarListScreen(),
          ),
          GoRoute(
            path: LibraryRoutePaths.wordList,
            name: LibraryRouteNames.wordList,
            builder: (context, state) => const WordListScreen(),
          ),
          GoRoute(
            path: LibraryRoutePaths.wordDetail,
            name: LibraryRouteNames.wordDetail,
            builder: (context, state) =>
                WordDetailScreen(wordId: state.pathParameters['wordId']!),
          ),
          GoRoute(
            path: LibraryRoutePaths.grammarDetail,
            name: LibraryRouteNames.grammarDetail,
            builder: (context, state) {
              final id = state.pathParameters['grammarId'];
              return GrammarDetailScreen(
                id: id != null ? int.parse(id) : 0,
              );
            },
          ),
        ],
      ),
    ];
  }

  // Keep this clean so the module can be loaded lazily in the main app_router
  static List<StatefulShellBranch> shellBranches() => [];
}
