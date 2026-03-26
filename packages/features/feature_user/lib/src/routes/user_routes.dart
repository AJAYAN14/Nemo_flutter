import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../profile/profile_screen.dart';
import '../profile/account_management_screen.dart';

abstract final class UserRoutePaths {
  static const String profile = '/profile';
  static const String account = 'account';
}

abstract final class UserRouteNames {
  static const String profile = 'user_profile';
  static const String account = 'user_account';
}

abstract final class UserRoutes {
  static Widget buildProfileScreen() => const ProfileScreen();
  static Widget buildAccountScreen() => const AccountManagementScreen();

  static List<RouteBase> rootRoutes() {
    return [
      GoRoute(
        path: UserRoutePaths.profile,
        name: UserRouteNames.profile,
        builder: (context, state) => buildProfileScreen(),
        routes: [
          GoRoute(
            path: UserRoutePaths.account,
            name: UserRouteNames.account,
            builder: (context, state) => buildAccountScreen(),
          ),
        ],
      ),
    ];
  }

  static List<StatefulShellBranch> shellBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: UserRoutePaths.profile,
            name: UserRouteNames.profile,
            builder: (context, state) => buildProfileScreen(),
            routes: [
              GoRoute(
                path: UserRoutePaths.account,
                name: UserRouteNames.account,
                builder: (context, state) => buildAccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
