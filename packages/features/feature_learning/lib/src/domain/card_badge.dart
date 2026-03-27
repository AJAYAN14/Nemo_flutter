import 'package:flutter/material.dart';

enum CardBadge {
  fresh,
  review,
  relearn;

  String get text {
    switch (this) {
      case CardBadge.fresh: return '新学';
      case CardBadge.review: return '复习';
      case CardBadge.relearn: return '重学';
    }
  }

  Color getBgColor(bool isDark) {
    if (isDark) {
      return switch (this) {
        CardBadge.fresh => const Color(0xFF1E3A8A),
        CardBadge.review => const Color(0xFF14532D),
        CardBadge.relearn => const Color(0xFF7C2D12),
      };
    }
    return switch (this) {
      CardBadge.fresh => const Color(0xFFE0EDFF),
      CardBadge.review => const Color(0xFFDCFCE7),
      CardBadge.relearn => const Color(0xFFFFEDD5),
    };
  }

  Color getTextColor(bool isDark) {
    if (isDark) {
      return switch (this) {
        CardBadge.fresh => const Color(0xFFBFDBFE),
        CardBadge.review => const Color(0xFFBBF7D0),
        CardBadge.relearn => const Color(0xFFFED7AA),
      };
    }
    return switch (this) {
      CardBadge.fresh => const Color(0xFF1D4ED8),
      CardBadge.review => const Color(0xFF166534),
      CardBadge.relearn => const Color(0xFF9A3412),
    };
  }
}
