import 'package:flutter/material.dart';

abstract final class NemoColors {
  // P0 brand tokens
  static const Color brandBlue = Color(0xFF0E68FF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color surfaceSoft = Color(0xFFF1F5F9);
  
  // Semantic Bento Tokens
  static const Color bgBase = Color(0xFFF4F6F9);
  static const Color bgBaseDark = Color(0xFF1C1B1F);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceCardDark = Color(0xFF2B2930);
  static const Color divider = Color(0xFFE2E8F0);

  // MD3 / Neutral Tokens (Premium Grays)
  static const Color gray900 = Color(0xFF111827);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray100 = Color(0xFFF3F4F6);

  static const Color darkTextPrimary = Color(0xFFE6E1E5);
  static const Color darkTextSecondary = Color(0xFFCAC4D0);

  static const Color blue600 = Color(0xFF2563EB);
  
  // Header / Navigation
  static const Color navGroupBgLight = Color(0xFFFFFFFF);
  static const Color navGroupBgDark = Color(0x26FFFFFF); // White with 0.15 opacity

  // Mode Specific
  static const Color wordsPrimary = Color(0xFFF97316);
  static const Color wordsLight = Color(0xFFFFEDD5);
  static const Color grammarPrimary = Color(0xFF059669);
  static const Color grammarLight = Color(0xFFD1FAE5);

  static const Color textMain = Color(0xFF0F172A);
  static const Color textSub = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Icon Backgrounds
  static const Color iconBgOrange = Color(0xFFFFF7ED);
  static const Color iconBgGreen = Color(0xFFECFDF5);
  static const Color iconBgBlue = Color(0xFFEFF6FF);
  static const Color iconBgPurple = Color(0xFFF5F3FF);

  // Accents
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color success = Color(0xFF10B981);

  // SRS Premium Palette (1:1 with RatingGuideBadge tokens)
  static const Color srsRoseText = Color(0xFFE11D48);
  static const Color srsRoseBg = Color(0xFFFFE4E6);
  static const Color srsRoseTextDark = Color(0xFFFDA4AF);
  static const Color srsRoseBgDark = Color(0xFF4C0519);

  static const Color srsOrangeText = Color(0xFFEA580C);
  static const Color srsOrangeBg = Color(0xFFFFEDD5);
  static const Color srsOrangeTextDark = Color(0xFFFDBA74);
  static const Color srsOrangeBgDark = Color(0xFF7C2D12);

  static const Color srsBlueText = Color(0xFF2563EB);
  static const Color srsBlueBg = Color(0xFFDBEAFE);
  static const Color srsBlueTextDark = Color(0xFF93C5FD);
  static const Color srsBlueBgDark = Color(0xFF1E3A8A);

  static const Color srsEmeraldText = Color(0xFF059669);
  static const Color srsEmeraldBg = Color(0xFFD1FAE5);
  static const Color srsEmeraldTextDark = Color(0xFF6EE7B7);
  static const Color srsEmeraldBgDark = Color(0xFF064E3B);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFFF2D55);
  static const Color accentCyan = Color(0xFF00C7BE);
  static const Color accentIndigo = Color(0xFF6366F1);

  // JLPT Level Colors (1:1 with old project)
  static const Color n5 = success;
  static const Color n4 = accentCyan;
  static const Color n3 = brandBlue;
  static const Color n2 = accentOrange;
  static const Color n1 = accentPink;
}

/// 词性分类色彩 (Category Colors)
abstract final class NemoCategoryColors {
  // 浅色模式 (Premium Pastel System)
  static const Color cardVerbBgLight = Color(0xFFF0F7FF);
  static const Color cardVerbTextLight = Color(0xFF007AFF);
  static const Color cardAdjIBgLight = Color(0xFFF2FBF2);
  static const Color cardAdjITextLight = Color(0xFF34C759);
  static const Color cardAdjNaBgLight = Color(0xFFFFF7EB);
  static const Color cardAdjNaTextLight = Color(0xFFFF9500);
  static const Color cardNounBgLight = Color(0xFFF9F5FF);
  static const Color cardNounTextLight = Color(0xFF5856D6);
  static const Color cardAdvBgLight = Color(0xFFF0FAF9);
  static const Color cardAdvTextLight = Color(0xFF00C7BE);
  static const Color cardRentaiBgLight = Color(0xFFF0F9FF);
  static const Color cardRentaiTextLight = Color(0xFF0EA5E9);
  static const Color cardConjBgLight = Color(0xFFFEFBE8);
  static const Color cardConjTextLight = Color(0xFFEAB308);
  static const Color cardFixBgLight = Color(0xFFEEF2FF);
  static const Color cardFixTextLight = Color(0xFF6366F1);
  static const Color cardKataBgLight = Color(0xFFFFF5F7);
  static const Color cardKataTextLight = Color(0xFFFF2D55);
  static const Color cardIdiomBgLight = Color(0xFFFFF2F2);
  static const Color cardIdiomTextLight = Color(0xFFFF3B30);
  static const Color cardKeigoBgLight = Color(0xFFFEF7E6);
  static const Color cardKeigoTextLight = Color(0xFFD97706);
  static const Color cardSoundBgLight = Color(0xFFFBFCF0);
  static const Color cardSoundTextLight = Color(0xFF65A30D);

  // 深色模式 (Subtle Glow System)
  static const Color cardVerbBgDark = Color(0xFF071A2E);
  static const Color cardVerbTextDark = Color(0xFF64B5F6);
  static const Color cardAdjIBgDark = Color(0xFF091E0F);
  static const Color cardAdjITextDark = Color(0xFF81C784);
  static const Color cardAdjNaBgDark = Color(0xFF2E1A05);
  static const Color cardAdjNaTextDark = Color(0xFFFFB74D);
  static const Color cardNounBgDark = Color(0xFF1A0B2E);
  static const Color cardNounTextDark = Color(0xFFBA68C8);
  static const Color cardAdvBgDark = Color(0xFF051B18);
  static const Color cardAdvTextDark = Color(0xFF4DB6AC);
  static const Color cardRentaiBgDark = Color(0xFF082F49);
  static const Color cardRentaiTextDark = Color(0xFF38BDF8);
  static const Color cardConjBgDark = Color(0xFF1E1605);
  static const Color cardConjTextDark = Color(0xFFFFD54F);
  static const Color cardFixBgDark = Color(0xFF1E1B4B);
  static const Color cardFixTextDark = Color(0xFF818CF8);
  static const Color cardKataBgDark = Color(0xFF1E070F);
  static const Color cardKataTextDark = Color(0xFFF48FB1);
  static const Color cardIdiomBgDark = Color(0xFF240606);
  static const Color cardIdiomTextDark = Color(0xFFE57373);
  static const Color cardKeigoBgDark = Color(0xFF1E1405);
  static const Color cardKeigoTextDark = Color(0xFFFFB74D);
  static const Color cardSoundBgDark = Color(0xFF1A1E05);
  static const Color cardSoundTextDark = Color(0xFFDCE775);
}
