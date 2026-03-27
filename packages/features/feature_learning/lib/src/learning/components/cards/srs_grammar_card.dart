import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_ui/core_ui.dart';
import '../../../domain/card_badge.dart';

class SRSGrammarCard extends StatefulWidget {
  const SRSGrammarCard({
    super.key,
    required this.grammar,
    required this.isAnswerShown,
    this.badge,
    this.onSpeakExample,
    this.playingAudioId,
  });

  final Grammar grammar;
  final bool isAnswerShown;
  final CardBadge? badge;
  final Function(String japanese, String chinese, String id)? onSpeakExample;
  final String? playingAudioId;

  @override
  State<SRSGrammarCard> createState() => _SRSGrammarCardState();
}

class _SRSGrammarCardState extends State<SRSGrammarCard> {
  // To track expanded/collapsed state for multiple usages
  final Map<int, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    // Default the first usage to expanded
    _expandedStates[0] = true;
  }

  @override
  void didUpdateWidget(SRSGrammarCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.grammar.id != oldWidget.grammar.id) {
      _expandedStates.clear();
      _expandedStates[0] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBackground = isDark ? NemoColors.surfaceCardDark : NemoColors.surfaceCard;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : NemoColors.gray100;
    
    final primaryTextColor = isDark ? NemoColors.darkTextPrimary : NemoColors.gray900;
    final secondaryTextColor = isDark ? NemoColors.gray400 : NemoColors.gray500;

    // Indigo theme (Modified to use NemoColors if available, or keep as is if specific to grammar)
    final indigoBg = isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF);
    final indigoBorder = isDark ? const Color(0xFF3730A3) : const Color(0xFFE0E7FF);
    final indigoText = isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5);

    // Yellow theme
    final yellowBg = isDark ? const Color(0xFF451A03) : const Color(0xFFFEFCE8); // More brown in dark
    final yellowBorder = isDark ? const Color(0xFF713F12) : const Color(0xFFFEF3C7);
    final yellowIcon = isDark ? const Color(0xFFFDE047) : const Color(0xFFCA8A04);
    final yellowText = isDark ? const Color(0xFFFEF08A) : const Color(0xFF92400E);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120, left: 16, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // ========== Question Card ==========
          _QuestionBox(
            grammar: widget.grammar,
            isAnswerShown: widget.isAnswerShown,
            badge: widget.badge,
            backgroundColor: cardBackground,
            borderColor: borderColor,
            primaryTextColor: primaryTextColor,
            secondaryTextColor: secondaryTextColor,
            isDark: isDark,
            indigoBg: indigoBg,
            indigoBorder: indigoBorder,
            indigoText: indigoText,
          ),

          const SizedBox(height: 16),

          // --- Sticker or Answer Area ---
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: widget.isAnswerShown
                ? Column(
                    key: const ValueKey('answer'),
                    children: widget.grammar.usages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final usage = entry.value;
                      final isExpanded = _expandedStates[index] ?? (index == 0);

                      return _UsageSection(
                        usage: usage,
                        index: index,
                        isExpanded: isExpanded,
                        showExpandToggle: widget.grammar.usages.length > 1,
                        onToggle: () {
                          setState(() {
                            _expandedStates[index] = !isExpanded;
                          });
                        },
                        cardBackground: cardBackground,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        indigoBg: indigoBg,
                        indigoText: indigoText,
                        yellowBg: yellowBg,
                        yellowBorder: yellowBorder,
                        yellowIcon: yellowIcon,
                        yellowText: yellowText,
                        onSpeakExample: widget.onSpeakExample,
                        playingAudioId: widget.playingAudioId,
                        grammarId: widget.grammar.id,
                      );
                    }).toList(),
                  )
                : _StickerBox(grammarId: widget.grammar.id),
          ),
        ],
      ),
    );
  }
}

class _QuestionBox extends StatelessWidget {
  const _QuestionBox({
    required this.grammar,
    required this.isAnswerShown,
    this.badge,
    required this.backgroundColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.isDark,
    required this.indigoBg,
    required this.indigoBorder,
    required this.indigoText,
  });

  final Grammar grammar;
  final bool isAnswerShown;
  final CardBadge? badge;
  final Color backgroundColor, borderColor, primaryTextColor, secondaryTextColor;
  final bool isDark;
  final Color indigoBg, indigoBorder, indigoText;

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
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Level Tag
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: indigoBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: indigoBorder, width: 0.5),
                    ),
                    child: Text(
                      grammar.grammarLevel,
                      style: TextStyle(
                        color: indigoText,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Grammar Entry
                Text(
                  grammar.grammar,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800, // ExtraBold
                    color: primaryTextColor,
                    height: 1.3,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isAnswerShown) ...[
                  const SizedBox(height: 16),
                  Text(
                    "思考这个语法的用法...",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -8,
              right: -8,
              child: _Badge(badge: badge!, isDark: isDark),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badge, required this.isDark});
  final CardBadge badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: badge.getBgColor(isDark),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badge.text,
        style: TextStyle(
          color: badge.getTextColor(isDark),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StickerBox extends StatelessWidget {
  const _StickerBox({required this.grammarId});
  final String grammarId;

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
            Text('STICKER_G_${grammarId.hashCode % 25}', style: const TextStyle(fontWeight: FontWeight.w900, color: NemoColors.textMain)),
          ],
        ),
      ),
    );
  }
}

class _UsageSection extends StatelessWidget {
  const _UsageSection({
    required this.usage,
    required this.index,
    required this.isExpanded,
    required this.showExpandToggle,
    required this.onToggle,
    required this.cardBackground,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.indigoBg,
    required this.indigoText,
    required this.yellowBg,
    required this.yellowBorder,
    required this.yellowIcon,
    required this.yellowText,
    this.onSpeakExample,
    this.playingAudioId,
    required this.grammarId,
  });

  final GrammarUsage usage;
  final int index;
  final bool isExpanded;
  final bool showExpandToggle;
  final VoidCallback onToggle;
  final Color cardBackground, borderColor, primaryTextColor, secondaryTextColor;
  final Color indigoBg, indigoText;
  final Color yellowBg, yellowBorder, yellowIcon, yellowText;
  final Function(String, String, String)? onSpeakExample;
  final String? playingAudioId;
  final String grammarId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          if (showExpandToggle)
            GestureDetector(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isExpanded ? Colors.transparent : cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: isExpanded ? null : Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isExpanded ? indigoBg : indigoBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "用法${_toChineseNumber(index + 1)}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isExpanded ? indigoText : indigoText.withValues(alpha: 0.7),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    if (usage.subtype != null) ...[
                      const SizedBox(width: 12),
                      Text(
                        usage.subtype!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isExpanded ? primaryTextColor : secondaryTextColor,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: secondaryTextColor.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

          if (isExpanded || !showExpandToggle)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  // Connection Card
                  if (usage.connection.isNotEmpty)
                    _LayeredCard(
                      icon: Icons.link_rounded,
                      label: '接续',
                      content: usage.connection,
                      cardBackground: cardBackground,
                      borderColor: borderColor,
                      labelColor: secondaryTextColor,
                      contentStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryTextColor, height: 1.7),
                    ),

                  const SizedBox(height: 12),

                  // Explanation Card
                  _LayeredCard(
                    icon: Icons.lightbulb_outline_rounded,
                    label: '说明',
                    labelColor: indigoText,
                    content: usage.explanation,
                    cardBackground: cardBackground,
                    borderColor: borderColor,
                    contentStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: primaryTextColor, height: 1.7),
                  ),

                  const SizedBox(height: 12),

                  // Examples Card
                  if (usage.examples.isNotEmpty)
                    _ExamplesCard(
                      examples: usage.examples,
                      cardBackground: cardBackground,
                      borderColor: borderColor,
                      secondaryTextColor: secondaryTextColor,
                      primaryTextColor: primaryTextColor,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      onSpeak: onSpeakExample,
                      playingAudioId: playingAudioId,
                      grammarId: grammarId,
                      usageIndex: index,
                    ),

                  const SizedBox(height: 12),

                  // Tips
                  if (usage.notes != null && usage.notes!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: yellowBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: yellowBorder, width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: yellowIcon, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "TIPS: ${usage.notes}",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: yellowText, height: 1.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _toChineseNumber(int n) {
    const list = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    return (n > 0 && n <= 10) ? list[n - 1] : n.toString();
  }
}

class _LayeredCard extends StatelessWidget {
  const _LayeredCard({
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.content,
    required this.cardBackground,
    required this.borderColor,
    required this.contentStyle,
  });

  final IconData icon;
  final String label;
  final Color labelColor;
  final String content;
  final Color cardBackground, borderColor;
  final TextStyle contentStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: labelColor, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: labelColor, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(content, style: contentStyle),
        ],
      ),
    );
  }
}

class _ExamplesCard extends StatelessWidget {
  const _ExamplesCard({
    required this.examples,
    required this.cardBackground,
    required this.borderColor,
    required this.secondaryTextColor,
    required this.primaryTextColor,
    required this.isDark,
    this.onSpeak,
    this.playingAudioId,
    required this.grammarId,
    required this.usageIndex,
  });

  final List<GrammarExample> examples;
  final Color cardBackground, borderColor, secondaryTextColor, primaryTextColor;
  final bool isDark;
  final Function(String, String, String)? onSpeak;
  final String? playingAudioId;
  final String grammarId;
  final int usageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book_rounded, color: secondaryTextColor, size: 20),
              const SizedBox(width: 10),
              Text(
                '例句',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondaryTextColor, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: examples.asMap().entries.map((entry) {
                final exIndex = entry.key;
                final example = entry.value;
                final id = "grammar_${grammarId}_u${usageIndex}_e$exIndex";

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NemoFuriganaText(
                                  text: example.sentence,
                                  baseTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryTextColor, height: 1.6),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  example.translation,
                                  style: TextStyle(fontSize: 14, color: secondaryTextColor.withValues(alpha: 0.8), height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          if (onSpeak != null)
                            IconButton(
                              onPressed: () => onSpeak!(example.sentence, example.translation, id),
                              icon: Icon(
                                playingAudioId == id ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                color: secondaryTextColor,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (exIndex < examples.length - 1)
                      Divider(height: 1, color: borderColor.withValues(alpha: 0.5)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
