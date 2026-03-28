import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';

class RatingGuideSheet extends StatelessWidget {
  const RatingGuideSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RatingGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final backgroundColor = isDark ? NemoColors.bgBaseDark : NemoColors.bgBase;
    final surfaceColor = isDark ? NemoColors.surfaceCardDark : NemoColors.surfaceCard;
    final textMain = isDark ? NemoColors.darkTextPrimary : NemoColors.textMain;
    final textSub = isDark ? NemoColors.darkTextSecondary : NemoColors.textSub;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '评分说明',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: textMain,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   _Card(
                    color: surfaceColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '核心原则',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: textMain,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '按回忆难度打分，不按是否看过答案打分。',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSub,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _RatingSection(
                    title: '新学（第一次接触）',
                    items: [
                      _RatingItem(label: '重来', text: '完全想不起来，或需要重新看讲解。', textColor: NemoColors.srsRoseText, bgColor: NemoColors.srsRoseBg),
                      _RatingItem(label: '困难', text: '能回忆一点，但很吃力、很慢，容易错。', textColor: NemoColors.srsOrangeText, bgColor: NemoColors.srsOrangeBg),
                      _RatingItem(label: '良好', text: '能正常回忆，速度一般。', textColor: NemoColors.srsBlueText, bgColor: NemoColors.srsBlueBg),
                      _RatingItem(label: '容易', text: '几乎秒回，且很有把握。', textColor: NemoColors.srsEmeraldText, bgColor: NemoColors.srsEmeraldBg),
                    ],
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _RatingSection(
                    title: '复习（学过的卡片）',
                    items: [
                      _RatingItem(label: '重来', text: '这次没想起来，或答错。', textColor: NemoColors.srsRoseText, bgColor: NemoColors.srsRoseBg),
                      _RatingItem(label: '困难', text: '想起来了，但明显比预期更费劲。', textColor: NemoColors.srsOrangeText, bgColor: NemoColors.srsOrangeBg),
                      _RatingItem(label: '良好', text: '正常想起，符合日常复习状态。', textColor: NemoColors.srsBlueText, bgColor: NemoColors.srsBlueBg),
                      _RatingItem(label: '容易', text: '非常轻松，建议拉长下次间隔。', textColor: NemoColors.srsEmeraldText, bgColor: NemoColors.srsEmeraldBg),
                    ],
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: NemoColors.brandBlue.withOpacity(isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NemoColors.brandBlue.withOpacity(0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.tips_and_updates_rounded, color: NemoColors.brandBlue, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '实用建议：拿不准时优先选“良好”；只有明显吃力再选“困难”，别把“重来”当保守选项常点。',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? NemoColors.darkTextPrimary : NemoColors.srsBlueText,
                              fontWeight: FontWeight.w600,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NemoColors.brandBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      '我知道了',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final Color color;

  const _Card({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: child,
    );
  }
}

class _RatingSection extends StatelessWidget {
  final String title;
  final List<_RatingItem> items;
  final bool isDark;

  const _RatingSection({required this.title, required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textMain = isDark ? NemoColors.darkTextPrimary : NemoColors.textMain;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? NemoColors.surfaceCardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: textMain,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? item.textColor.withOpacity(0.2) : item.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isDark ? item.textColor : item.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? NemoColors.darkTextSecondary : NemoColors.textSub,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _RatingItem {
  final String label;
  final String text;
  final Color textColor;
  final Color bgColor;

  _RatingItem({required this.label, required this.text, required this.textColor, required this.bgColor});
}
