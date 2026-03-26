import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

class NemoApp extends StatelessWidget {
  const NemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nemo',
      theme: NemoTheme.light,
      darkTheme: NemoTheme.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
