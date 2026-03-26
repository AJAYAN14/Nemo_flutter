import 'package:flutter/material.dart';

import 'nemo_colors.dart';

abstract final class NemoTheme {
  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: NemoColors.wordsPrimary).copyWith(
        background: NemoColors.bgBase,
        surface: NemoColors.surface,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: NemoColors.bgBase,
      navigationBarTheme: base.navigationBarTheme.copyWith(
        indicatorColor: NemoColors.wordsPrimary.withOpacity(0.14),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NemoColors.wordsPrimary,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: NemoColors.textMain,
      navigationBarTheme: base.navigationBarTheme.copyWith(
        indicatorColor: NemoColors.wordsPrimary.withOpacity(0.24),
      ),
    );
  }
}
