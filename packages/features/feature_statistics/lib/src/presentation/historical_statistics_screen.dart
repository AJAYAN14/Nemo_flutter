import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class HistoricalStatisticsScreen extends StatelessWidget {
  const HistoricalStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for words and grammar
    final learnedWords = List.generate(
      15,
      (index) => _StatDisplayItem(
        id: index,
        japanese: '単語 $index',
        hiragana: 'たんご',
        chinese: '单词 $index',
        level: 'N2',
        isWord: true,
      ),
    );

    final learnedGrammars = List.generate(
      8,
      (index) => _StatDisplayItem(
        id: index,
        japanese: '文法 $index',
        hiragana: 'ぶんぽう',
        chinese: '语法 $index',
        level: 'N3',
        isWord: false,
      ),
    );

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('历史统计', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // 1. 累计学习汇总
          const _SectionTitle('累计学习'),
          _HistoricalSummaryCard(
            totalWords: learnedWords.length,
            totalGrammars: learnedGrammars.length,
          ),

          const SizedBox(height: 24),

          // 2. 已学单词列表
          _SectionTitle('已学单词 (${learnedWords.length})'),
          _StatisticsListCard(
            items: learnedWords,
            emptyMessage: '暂无单词学习记录',
          ),

          const SizedBox(height: 24),

          // 3. 已学语法列表
          _SectionTitle('已学语法 (${learnedGrammars.length})'),
          _StatisticsListCard(
            items: learnedGrammars,
            emptyMessage: '暂无语法学习记录',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _HistoricalSummaryCard extends StatelessWidget {
  const _HistoricalSummaryCard({
    required this.totalWords,
    required this.totalGrammars,
  });

  final int totalWords;
  final int totalGrammars;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: '$totalWords',
              label: '单词总数',
              color: NemoColors.brandBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatItem(
              value: '$totalGrammars',
              label: '语法总数',
              color: NemoColors.accentPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsListCard extends StatefulWidget {
  const _StatisticsListCard({
    required this.items,
    required this.emptyMessage,
  });

  final List<_StatDisplayItem> items;
  final String emptyMessage;

  @override
  State<_StatisticsListCard> createState() => _StatisticsListCardState();
}

class _StatisticsListCardState extends State<_StatisticsListCard> {
  bool _isExpanded = false;
  static const int _defaultShowCount = 5;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return PremiumCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.emptyMessage,
                  style: const TextStyle(
                    color: NemoColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final shouldCollapse = widget.items.length > _defaultShowCount + 1;
    final showItems = (_isExpanded || !shouldCollapse)
        ? widget.items
        : widget.items.take(_defaultShowCount).toList();
    final remainingCount = widget.items.length - _defaultShowCount;

    final avatarColors = [
      NemoColors.brandBlue,
      NemoColors.accentOrange,
      NemoColors.accentPurple,
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFD946EF), // Fuchsia/Pink
    ];

    return PremiumCard(
      child: Column(
        children: [
          ...showItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final color = avatarColors[index % avatarColors.length];

            return _StatisticsItemRow(
              item: item,
              avatarColor: color,
              showDivider: index < showItems.length - 1,
            );
          }),
          if (shouldCollapse) ...[
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.1),
            ),
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? '收起' : '展开查看剩余 $remainingCount 项',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatisticsItemRow extends StatelessWidget {
  const _StatisticsItemRow({
    required this.item,
    required this.avatarColor,
    required this.showDivider,
  });

  final _StatDisplayItem item;
  final Color avatarColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final avatarChar = item.japanese.isNotEmpty ? item.japanese[0] : '?';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // Dynamic Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: avatarColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  avatarChar,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.japanese,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (item.level.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.level,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.hiragana} · ${item.chinese}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
            ),
          ),
      ],
    );
  }
}

class _StatDisplayItem {
  final int id;
  final String japanese;
  final String hiragana;
  final String chinese;
  final String level;
  final bool isWord;

  _StatDisplayItem({
    required this.id,
    required this.japanese,
    required this.hiragana,
    required this.chinese,
    required this.level,
    required this.isWord,
  });
}
