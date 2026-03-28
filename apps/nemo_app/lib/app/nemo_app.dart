import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_storage/core_storage.dart';

import 'router/app_router.dart';

class NemoApp extends ConsumerWidget {
  const NemoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger importer at app startup. The importer is idempotent and will
    // skip work if DB already populated. This ensures first-run data becomes
    // available without requiring the user to open library screens.
    ref.watch(assetDataImporterProvider);

    return MaterialApp.router(
      title: 'Nemo',
      theme: NemoTheme.light,
      darkTheme: NemoTheme.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
