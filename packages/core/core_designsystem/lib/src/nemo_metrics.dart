import 'package:flutter/material.dart';

abstract final class NemoMetrics {
  // Radii
  static const Radius radius16 = Radius.circular(16);
  static const Radius radius22 = Radius.circular(22);
  static const Radius radius26 = Radius.circular(26);

  static const BorderRadius topRadius16 = BorderRadius.only(
    topLeft: radius16,
    topRight: radius16,
  );

  static const BorderRadius topRadius26 = BorderRadius.only(
    topLeft: radius26,
    topRight: radius26,
  );

  static BorderRadius radius(double value) => BorderRadius.circular(value);

  // Sizes
  static const double navHeight = 80;
  static const double authButtonHeight = 52;

  // Durations
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration fadeDuration = Duration(milliseconds: 1200);
  static const Duration scaleDuration = Duration(milliseconds: 1500);

  // Shadows
  static const List<BoxShadow> cardTopShadow = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 20,
      offset: Offset(0, -2),
    ),
  ];
}
