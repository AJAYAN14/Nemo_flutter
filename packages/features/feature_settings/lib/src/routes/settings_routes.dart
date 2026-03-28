import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/settings_screen.dart';
import '../presentation/tts_settings_screen.dart';
import '../presentation/srs_settings_screen.dart';

abstract final class SettingsRoutePaths {
  static const String root = '/settings';
  static const String tts = 'tts';
  static const String srs = 'srs';
}

abstract final class SettingsRouteNames {
  static const String root = 'settings';
  static const String tts = 'settings_tts';
  static const String srs = 'settings_srs';
}

abstract final class SettingsRoutes {
  static Widget buildSettingsScreen() => const SettingsScreen();
  static Widget buildTtsSettingsScreen() => const TtsSettingsScreen();
  static Widget buildSrsSettingsScreen() => const SrsSettingsScreen();

  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: '/settings/tts',
        name: SettingsRouteNames.tts,
        builder: (context, state) => buildTtsSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/srs',
        name: SettingsRouteNames.srs,
        builder: (context, state) => buildSrsSettingsScreen(),
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
