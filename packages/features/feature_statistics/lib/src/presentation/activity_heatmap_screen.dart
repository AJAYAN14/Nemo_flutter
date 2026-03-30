import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_domain/core_domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'heatmap_providers.dart';

class ActivityHeatmapScreen extends ConsumerStatefulWidget {
  const ActivityHeatmapScreen({super.key});

  @override
  ConsumerState<ActivityHeatmapScreen> createState() => _ActivityHeatmapScreenState();
}

class _ActivityHeatmapScreenState extends ConsumerState<ActivityHeatmapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  DateTime? _selectedDate;
  int _selectedCount = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(heatmapUiStateProvider);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('学习热力图', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: heatmapAsync.when(
        data: (state) => FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              // 1. 年度回顾 (Heatmap Centerpiece)
              const _SectionTitle('年度回顾'),
              _LearningHeatmapCard(
                data: state.heatmapData,
                onDaySelected: (date, count) {
                  setState(() {
                    _selectedDate = date;
                    _selectedCount = count;
                  });
                  HapticFeedback.lightImpact();
                },
              ),

              // Selection Tooltip
              if (_selectedDate != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_selectedDate!.month}/${_selectedDate!.day}: $_selectedCount 次学习',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 2. 数据高光 (Rich Stats Grid)
              const _SectionTitle('数据高光'),
              _RichStatsGrid(state: state),

              const SizedBox(height: 32),

              // 3. Motivational Footer
              Center(
                child: Text(
                  state.currentStreak > 0 ? '已经坚持 ${state.currentStreak} 天了，继续加油！' : '每一天都在进步，保持连胜！',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('加载失败: $err')),
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

class _LearningHeatmapCard extends StatelessWidget {
  const _LearningHeatmapCard({required this.data, required this.onDaySelected});
  final List<HeatmapDay> data;
  final void Function(DateTime date, int count) onDaySelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Fire Style Colors
    final levels = isDark 
        ? [const Color(0xFF161B22), const Color(0xFF3A1C1C), const Color(0xFF682424), const Color(0xFFB52A2A), const Color(0xFFE63E3E)]
        : [const Color(0xFFEBEDF0), const Color(0xFFFFD7D5), const Color(0xFFFFA39E), const Color(0xFFFF4D4F), const Color(0xFFCF1322)];

    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Heatmap Grid
          SizedBox(
            height: 14 * 7 + 4 * 6, // 7 blocks of 14dp + 6 spacings of 4dp
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 52, // 1 year approx
              reverse: true, // Show most recent first (from right to left)
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, weekIndex) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (dayIndex) {
                    // dataIndex 0 is oldest, data.length-1 is today.
                    // weekIndex 0 is rightmost column (since reverse: true).
                    final dataIndex = (data.length - 1) - (weekIndex * 7 + (6 - dayIndex));
                    
                    if (dataIndex < 0 || dataIndex >= data.length) {
                      return const SizedBox(width: 14, height: 14);
                    }
                    
                    final item = data[dataIndex];
                    final level = item.level;

                    return GestureDetector(
                      onTap: () {
                         final date = DateTime.fromMillisecondsSinceEpoch(item.date * 86400000, isUtc: true).toLocal();
                         onDaySelected(date, item.count);
                      },
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: levels[level],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('少', style: TextStyle(fontSize: 10, color: NemoColors.textMuted)),
              const SizedBox(width: 4),
              ...levels.map((c) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(width: 4),
              const Text('多', style: TextStyle(fontSize: 10, color: NemoColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RichStatsGrid extends StatelessWidget {
  const _RichStatsGrid({required this.state});
  final HeatmapUiState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _RichStatItem(
                label: '当前坚持',
                value: '${state.currentStreak} 天',
                subLabel: '最长 ${state.longestStreak} 天',
                icon: Icons.emoji_events_rounded,
                color: NemoColors.accentOrange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RichStatItem(
                label: '累计活跃',
                value: '${state.totalActiveDays} 天',
                subLabel: '持续进步',
                icon: Icons.history_rounded,
                color: NemoColors.brandBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RichStatItem(
                label: '单日最佳',
                value: '${state.bestDayCount} 项',
                subLabel: state.bestDayDate > 0 
                  ? DateTimeUtils.formatEpochDay(state.bestDayDate).substring(5).replaceAll('-', '/') 
                  : '-',
                icon: Icons.edit_note_rounded,
                color: NemoColors.accentPurple,
              ),
            ),
            Expanded(
              child: _RichStatItem(
                label: '日均学习',
                value: '${state.dailyAverage} 词',
                subLabel: '状态极佳',
                icon: Icons.auto_stories_rounded,
                color: const Color(0xFF6366F1), // Indigo
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RichStatItem extends StatelessWidget {
  const _RichStatItem({
    required this.label,
    required this.value,
    required this.subLabel,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String subLabel;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subLabel,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
