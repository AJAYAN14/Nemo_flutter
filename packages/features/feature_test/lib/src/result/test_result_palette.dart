import 'package:flutter/material.dart';

abstract final class TestResultPalette {
  static const Color correctGreen = Color(0xFF10B981);
  static const Color wrongRed = Color(0xFFEF4444);
  static const Color timeBlue = Color(0xFF3B82F6);
  static const Color amberWarning = Color(0xFFFBBF24);
  
  static Color getAccuracyColor(int accuracy) {
    if (accuracy >= 90) return const Color(0xFF10B981); // Emerald 500
    if (accuracy >= 80) return const Color(0xFF34D399); // Emerald 400
    if (accuracy >= 60) return const Color(0xFFFBBF24); // Amber 400
    return const Color(0xFFEF4444); // Red 500
  }

  static Color getCorrectCardBg(bool isDark) => isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
  static Color getWrongCardBg(bool isDark) => isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
  static Color getTimeCardBg(bool isDark) => isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
  
  static const Color wordAccent = Color(0xFFF97316);
  static const Color grammarAccent = Color(0xFF059669);
  static const Color distributionTitle = Color(0xFF64748B);
}
