import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_ui/core_ui.dart';

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

class SRSLearningCard extends StatelessWidget {
  const SRSLearningCard({
    super.key,
    required this.word,
    required this.isAnswerShown,
    this.badge,
    this.onSpeakWord,
    this.onSpeakExample,
    this.onPracticeClick,
    this.playingAudioId,
  });

  final Word word;
  final bool isAnswerShown;
  final CardBadge? badge;
  final VoidCallback? onSpeakWord;
  final Function(String japanese, String chinese, String id)? onSpeakExample;
  final VoidCallback? onPracticeClick;
  final String? playingAudioId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackground = isDark ? NemoColors.surfaceCardDark : NemoColors.surfaceCard;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.03);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120, left: 16, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // --- Question Area ---
          _QuestionBox(
            word: word,
            isAnswerShown: isAnswerShown,
            badge: badge,
            isDark: isDark,
            backgroundColor: cardBackground,
            borderColor: borderColor,
            shadowColor: shadowColor,
          ),

          const SizedBox(height: 16),

          // --- Sticker or Answer Area ---
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: isAnswerShown
                ? _AnswerBox(
                    key: const ValueKey('answer'),
                    word: word,
                    isDark: isDark,
                    backgroundColor: cardBackground,
                    borderColor: borderColor,
                    shadowColor: shadowColor,
                    onSpeakWord: onSpeakWord,
                    onSpeakExample: onSpeakExample,
                    onPracticeClick: onPracticeClick,
                    playingAudioId: playingAudioId,
                  )
                : _StickerBox(
                    key: const ValueKey('sticker'),
                    wordId: word.id,
                  ),
          ),
        ],
      ),
    );
  }
}

class _QuestionBox extends StatelessWidget {
  const _QuestionBox({
    required this.word,
    required this.isAnswerShown,
    this.badge,
    required this.isDark,
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
  });

  final Word word;
  final bool isAnswerShown;
  final CardBadge? badge;
  final bool isDark;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark ? NemoColors.darkTextPrimary : NemoColors.gray900;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Japanese
                NemoFuriganaText(
                  text: word.japanese,
                  textAlign: TextAlign.center,
                  baseTextStyle: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800, // ExtraBold
                    letterSpacing: -1,
                    height: 1.1,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Hiragana (Blurred if hidden)
                _BlurredText(
                  text: word.hiragana,
                  isBlurred: !isAnswerShown,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: isAnswerShown ? NemoColors.blue600 : (isDark ? Colors.white.withValues(alpha: 0.2) : NemoColors.gray300),
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -8,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: badge!.getBgColor(isDark),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!.text,
                  style: TextStyle(
                    color: badge!.getTextColor(isDark),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlurredText extends StatelessWidget {
  const _BlurredText({
    required this.text,
    required this.isBlurred,
    required this.style,
  });

  final String text;
  final bool isBlurred;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (!isBlurred) {
      return Text(text, style: style);
    }
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Text(text, style: style),
    );
  }
}

class _StickerBox extends StatelessWidget {
  const _StickerBox({super.key, required this.wordId});
  final String wordId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Opacity(
        opacity: 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 80, color: NemoColors.textMain),
            const SizedBox(height: 16),
            Text('STICKER_${wordId.hashCode % 25}', style: const TextStyle(fontWeight: FontWeight.w900, color: NemoColors.textMain)),
          ],
        ),
      ),
    );
  }
}

class _AnswerBox extends StatelessWidget {
  const _AnswerBox({
    super.key,
    required this.word,
    required this.isDark,
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
    this.onSpeakWord,
    this.onSpeakExample,
    this.onPracticeClick,
    this.playingAudioId,
  });

  final Word word;
  final bool isDark;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final VoidCallback? onSpeakWord;
  final Function(String japanese, String chinese, String id)? onSpeakExample;
  final VoidCallback? onPracticeClick;
  final String? playingAudioId;

  @override
  Widget build(BuildContext context) {
    final practiceColor = _getColorForWord(word.id.hashCode);
    final practiceBgColor = practiceColor.withValues(alpha: isDark ? 0.2 : 0.1);

    final primaryTextColor = isDark ? NemoColors.darkTextPrimary : NemoColors.gray900;
    final secondaryTextColor = isDark ? NemoColors.gray400 : NemoColors.gray400;
    final dividerColor = isDark ? Colors.white.withValues(alpha: 0.1) : NemoColors.gray100;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // POS Tag
              if (word.pos != null)
                _PosPill(text: word.pos!, isDark: isDark),

              // Meaning Section
              _Label('含义', color: secondaryTextColor),
              const SizedBox(height: 4),
              Text(
                word.chinese,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 16),

              // Example Section
              _Label('例句', color: secondaryTextColor),
              const SizedBox(height: 12),
              ...word.examples.asMap().entries.map((entry) {
                final ex = entry.value;
                final id = 'ex${entry.key}_${word.id}';
                return _ExampleRow(
                  japanese: ex.japanese,
                  chinese: ex.chinese,
                  id: id,
                  onSpeak: onSpeakExample,
                  isPlaying: playingAudioId == id,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                );
              }),
            ],
          ),

          // Top Right Buttons
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onSpeakWord != null)
                  _SpeakerButton(
                    onPressed: onSpeakWord!,
                    isPlaying: playingAudioId == 'word',
                    color: practiceColor,
                    backgroundColor: practiceBgColor,
                  ),
                const SizedBox(width: 8),
                if (onPracticeClick != null)
                  _PracticeButton(
                    onPressed: onPracticeClick!,
                    color: practiceColor,
                    backgroundColor: practiceBgColor,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForWord(int id) {
    final colors = [
      const Color(0xFF007AFF), // Blue
      const Color(0xFF34C759), // Green
      const Color(0xFFFF9500), // Orange
      const Color(0xFFFF2D55), // Pink
      const Color(0xFF5856D6), // Indigo
      const Color(0xFFAF52DE), // Purple
      const Color(0xFFFF3B30), // Red
      const Color(0xFF00C7BE), // Mint
    ];
    return colors[id.abs() % colors.length];
  }
}

class _PosPill extends StatelessWidget {
  const _PosPill({required this.text, required this.isDark});
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : NemoColors.gray100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark ? NemoColors.darkTextSecondary : NemoColors.gray500,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, {required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500, // Medium
        color: color,
        letterSpacing: 1,
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({
    required this.japanese,
    this.chinese,
    required this.id,
    this.onSpeak,
    this.isPlaying = false,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  final String japanese;
  final String? chinese;
  final String id;
  final Function(String, String, String)? onSpeak;
  final bool isPlaying;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NemoFuriganaText(
                  text: japanese,
                  baseTextStyle: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: primaryTextColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                if (chinese != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    chinese!,
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                  ),
                ],
              ],
            ),
          ),
          if (onSpeak != null)
            IconButton(
              onPressed: () => onSpeak!(japanese, chinese ?? '', id),
              icon: Icon(
                isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                color: secondaryTextColor.withValues(alpha: 0.6),
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

class _SpeakerButton extends StatelessWidget {
  const _SpeakerButton({
    required this.onPressed,
    required this.isPlaying,
    required this.color,
    required this.backgroundColor,
  });

  final VoidCallback onPressed;
  final bool isPlaying;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded, color: color, size: 26),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _PracticeButton extends StatelessWidget {
  const _PracticeButton({
    required this.onPressed,
    required this.color,
    required this.backgroundColor,
  });

  final VoidCallback onPressed;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(Icons.translate_rounded, color: color, size: 26),
      ),
    );
  }
}
