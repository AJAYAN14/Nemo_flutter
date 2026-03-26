import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/settings_screen.dart';
import '../presentation/tts_settings_screen.dart';

abstract final class SettingsRoutePaths {
  static const String root = '/settings';
  static const String tts = 'tts';
}

abstract final class SettingsRouteNames {
  static const String root = 'settings';
  static const String tts = 'settings_tts';
}

abstract final class SettingsRoutes {
  static Widget buildSettingsScreen() => const SettingsScreen();
  static Widget buildTtsSettingsScreen() => const TtsSettingsScreen();

  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: '/settings/tts',
        name: SettingsRouteNames.tts,
        builder: (context, state) => buildTtsSettingsScreen(),
      ),
    ];
  }

  static List<StatefulShellBranch> shellBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: SettingsRoutePaths.root,
            name: SettingsRouteNames.root,
            builder: (context, state) => buildSettingsScreen(),
          ),
        ],
      ),
    ];
  }
}
