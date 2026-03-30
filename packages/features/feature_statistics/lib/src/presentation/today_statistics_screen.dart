import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'learning_calendar_providers.dart';

class TodayStatisticsScreen extends ConsumerWidget {
  const TodayStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayItemsAsync = ref.watch(todayItemsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          '今日统计',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: todayItemsAsync.when(
        data: (items) {
          final words = items
              .where((i) => i.item is WordItem)
              .map((i) => _StatItem.fromDomain(i.item as WordItem, i.isNew))
              .toList();
          final grammars = items
              .where((i) => i.item is GrammarItem)
              .map((i) => _StatItem.fromDomain(i.item as GrammarItem, i.isNew))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle('单词 (${words.length})'),
              if (words.isNotEmpty)
                _StatisticsListCard(items: words, isWord: true)
              else
                const _EmptyState(message: '该日期没有学习任何单词'),
              const SizedBox(height: 24),
              _SectionTitle('语法 (${grammars.length})'),
              if (grammars.isNotEmpty)
                _StatisticsListCard(items: grammars, isWord: false)
              else
                const _EmptyState(message: '该日期没有学习任何语法'),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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

class _StatisticsListCard extends StatefulWidget {
  const _StatisticsListCard({required this.items, required this.isWord});
  final List<_StatItem> items;
  final bool isWord;

  @override
  State<_StatisticsListCard> createState() => _StatisticsListCardState();
}

class _StatisticsListCardState extends State<_StatisticsListCard> {
  bool _isExpanded = false;
  static const int _threshold = 5;

  @override
  Widget build(BuildContext context) {
    final shouldCollapse = widget.items.length > _threshold + 1;
    final showItems = (_isExpanded || !shouldCollapse)
        ? widget.items
        : widget.items.take(_threshold).toList();
    final remainingCount = widget.items.length - _threshold;

    return PremiumCard(
      child: Column(
        children: [
          ...showItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _StatisticsItemRow(
              item: item,
              index: index,
              showDivider: index < showItems.length - 1,
            );
          }),
          if (shouldCollapse) ...[
            const SizedBox(height: 8),
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? '收起' : '展开查看剩余 $remainingCount 项',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
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
    required this.index,
    required this.showDivider,
  });

  final _StatItem item;
  final int index;
  final bool showDivider;

  static final _avatarColors = [
    NemoColors.brandBlue,
    Color(0xFFF97316), // Orange
    Color(0xFF059669), // Green
    Color(0xFF6366F1), // Indigo
    Color(0xFF14B8A6), // Teal
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final avatarChar = item.japanese.isNotEmpty ? item.japanese[0] : '?';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Dynamic Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.1),
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
                        // New/Review Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item.isLearned
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  )
                                : const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.isLearned ? '新学' : '复习',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: item.isLearned
                                  ? theme.colorScheme.primary
                                  : const Color(0xFF10B981),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.japanese,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.level.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.level,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.hiragana}${item.hiragana.isNotEmpty ? ' · ' : ''}${item.chinese}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.8,
                        ),
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
              height: 0.5,
              thickness: 0.5,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem {
  final String id;
  final String japanese;
  final String hiragana;
  final String chinese;
  final String level;
  final bool isLearned;

  _StatItem({
    required this.id,
    required this.japanese,
    required this.hiragana,
    required this.chinese,
    required this.level,
    required this.isLearned,
  });

  factory _StatItem.fromDomain(LearningItem item, bool isNew) {
    if (item is WordItem) {
      return _StatItem(
        id: item.word.id,
        japanese: item.word.japanese,
        hiragana: item.word.hiragana,
        chinese: item.word.chinese,
        level: item.word.level.toUpperCase(),
        isLearned: isNew,
      );
    } else if (item is GrammarItem) {
      return _StatItem(
        id: item.grammar.id,
        japanese: item.grammar.grammar,
        hiragana: item.grammar.usages.firstOrNull?.connection ?? '',
        chinese: item.grammar.usages.firstOrNull?.explanation ?? '',
        level: item.grammar.grammarLevel.toUpperCase(),
        isLearned: isNew,
      );
    }
    throw UnimplementedError();
  }
}
