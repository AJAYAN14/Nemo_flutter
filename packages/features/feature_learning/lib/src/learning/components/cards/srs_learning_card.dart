import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';

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

  Color get bgColor {
    switch (this) {
      case CardBadge.fresh: return const Color(0xFFE0EDFF);
      case CardBadge.review: return const Color(0xFFDCFCE7);
      case CardBadge.relearn: return const Color(0xFFFFEDD5);
    }
  }

  Color get textColor {
    switch (this) {
      case CardBadge.fresh: return const Color(0xFF1D4ED8);
      case CardBadge.review: return const Color(0xFF166534);
      case CardBadge.relearn: return const Color(0xFF9A3412);
    }
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Stack(
        children: [
          Column(
            children: [
              // Japanese
              Text(
                word.japanese,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800, // ExtraBold
                  letterSpacing: -1,
                  height: 1.1,
                  color: NemoColors.textMain,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Hiragana (Blurred if hidden)
              _BlurredText(
                text: word.hiragana,
                isBlurred: !isAnswerShown,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: isAnswerShown ? NemoColors.accentBlue : (isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB)),
                ),
              ),
            ],
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: badge!.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!.text,
                  style: TextStyle(
                    color: badge!.textColor,
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
            Text('STICKER_${wordId.hashCode % 25}', style: const TextStyle(fontWeight: FontWeight.w900)),
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
                _PosPill(text: word.pos!),

              // Meaning Section
              _Label('含义'),
              const SizedBox(height: 4),
              Text(
                word.chinese,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NemoColors.textMain,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: NemoColors.divider),
              const SizedBox(height: 16),

              // Example Section
              _Label('例句'),
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
                    color: practiceColor, // Or use specific blue from original
                    backgroundColor: practiceBgColor,
                  ),
                const SizedBox(width: 8),
                if (onPracticeClick != null)
                  _PracticeButton(
                    onPressed: onPracticeClick!,
                    color: const Color(0xFF5856D6), // iOS Indigo
                    backgroundColor: const Color(0xFF5856D6).withValues(alpha: 0.1),
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
  const _PosPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFFCAC4D0) : const Color(0xFF6B7280),
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500, // Refined to Medium
        color: NemoColors.textSub,
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
  });

  final String japanese;
  final String? chinese;
  final String id;
  final Function(String, String, String)? onSpeak;
  final bool isPlaying;

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
                // Simplified Furigana representation (Kanji above Hiragana logic is complex)
                // For now, achieving the clean spacing look
                Text(
                  japanese,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: NemoColors.textMain,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                if (chinese != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    chinese!,
                    style: const TextStyle(fontSize: 12, color: NemoColors.textSub),
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
                color: NemoColors.textSub.withValues(alpha: 0.6),
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
      width: 44, // Refined to 44dp
      height: 44,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded, color: color, size: 24),
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(Icons.translate_rounded, color: color, size: 24),
      ),
    );
  }
}
