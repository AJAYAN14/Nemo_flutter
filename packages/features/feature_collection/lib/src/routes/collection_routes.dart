import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/favorites_screen.dart';
import '../presentation/dummy_screens.dart';

abstract final class CollectionRoutePaths {
  static const String root = '/collection';
  static const String favorites = 'favorites';
  static const String mistakes = 'mistakes';
}

abstract final class CollectionRouteNames {
  static const String root = 'collection';
  static const String favorites = 'collection_favorites';
  static const String mistakes = 'collection_mistakes';
}

abstract final class CollectionRoutes {
  static Widget buildFavoritesScreen() => const FavoritesScreen();
  static Widget buildMistakesScreen() => const MistakesScreen();

  static List<StatefulShellBranch> shellBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: CollectionRoutePaths.root,
            name: CollectionRouteNames.root,
            builder: (context, state) => buildFavoritesScreen(),
            routes: [
              GoRoute(
                path: CollectionRoutePaths.favorites,
                name: CollectionRouteNames.favorites,
                builder: (context, state) => buildFavoritesScreen(),
              ),
              GoRoute(
                path: CollectionRoutePaths.mistakes,
                name: CollectionRouteNames.mistakes,
                builder: (context, state) => buildMistakesScreen(),
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
