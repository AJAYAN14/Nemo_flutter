import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'learning_calendar_providers.dart';

class LearningCalendarScreen extends ConsumerWidget {
  const LearningCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learningCalendarNotifierProvider);
    final notifier = ref.read(learningCalendarNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('学习日历', style: TextStyle(fontWeight: FontWeight.w900)),
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
          // 1. 今日概览
          const _SectionTitle('今日概览'),
          _TodaySummaryCard(stats: state.todayStats),
          
          const SizedBox(height: 24),

          // 2. 本周进度 (Week View)
          const _SectionTitle('本周进度'),
          _WeekViewCard(
            selectedDate: state.selectedDate,
            weekForecast: state.weekForecast,
            onDateSelected: (date) => notifier.onDateSelected(date),
          ),

          const SizedBox(height: 24),

          // 3. 详细记录 (Day Detail)
          const _SectionTitle('详细记录'),
          _DayDetailPanel(
            selectedDate: state.selectedDate,
            todayEpochDay: state.todayEpochDay,
            todayStats: state.todayStats,
            selectedDateRecord: state.selectedDateRecord,
            weekForecast: state.weekForecast,
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

class _TodaySummaryCard extends StatelessWidget {
  const _TodaySummaryCard({this.stats});
  final LearningStats? stats;

  @override
  Widget build(BuildContext context) {
    final learnedWords = stats?.todayLearnedWords ?? 0;
    final learnedGrammars = stats?.todayLearnedGrammars ?? 0;
    final dueCount = stats?.totalDue ?? 0;
    final completedCount = stats?.todayTotalReviewed ?? 0;

    return PremiumCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: '$learnedWords',
                  label: '新学单词',
                  color: NemoColors.brandBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatItem(
                  value: '$learnedGrammars',
                  label: '新学语法',
                  color: NemoColors.accentPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: '$dueCount',
                  label: '待复习',
                  color: NemoColors.accentOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatItem(
                  value: '$completedCount',
                  label: '今日已复',
                  color: const Color(0xFF6366F1), // Indigo
                ),
              ),
            ],
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
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
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
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekViewCard extends StatelessWidget {
  const _WeekViewCard({
    required this.selectedDate,
    required this.weekForecast,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final List<ReviewForecast> weekForecast;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    // 1:1 Parity check: Use current time to generate the 7-day window
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Generate 7 days starting from today (Fixed to today in Kotlin)
    final days = List.generate(7, (i) => today.add(Duration(days: i)));
    final weekDayLabels = ['一', '二', '三', '四', '五', '六', '日'];

    return PremiumCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((date) {
              final isToday = date.day == today.day && date.month == today.month;
              final isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
              
              // Find forecast for this date
              final epochDay = DateTimeUtils.dateToEpochDay(date);
              final forecast = weekForecast.where((f) => f.date == epochDay).firstOrNull;
              final hasActivity = (forecast?.count ?? 0) > 0;

              // Get day of week (Monday=1, Sunday=7)
              final label = weekDayLabels[date.weekday - 1];

              return _WeekDayItem(
                label: label,
                dayNumber: '${date.day}',
                isToday: isToday,
                isSelected: isSelected,
                hasActivity: hasActivity,
                onTap: () => onDateSelected(date),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Selected date indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${selectedDate.month}月${selectedDate.day}日',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekDayItem extends StatelessWidget {
  const _WeekDayItem({
    required this.label,
    required this.dayNumber,
    required this.isToday,
    required this.isSelected,
    required this.hasActivity,
    required this.onTap,
  });

  final String label;
  final String dayNumber;
  final bool isToday;
  final bool isSelected;
  final bool hasActivity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected 
        ? Colors.white 
        : (isToday ? NemoColors.brandBlue : Theme.of(context).colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? NemoColors.brandBlue : (isToday ? NemoColors.brandBlue.withValues(alpha: 0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: color.withValues(alpha: isSelected ? 0.8 : 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNumber,
              style: TextStyle(
                fontSize: 15,
                fontWeight: (isSelected || isToday) ? FontWeight.w900 : FontWeight.w600,
                color: color,
              ),
            ),
            if (hasActivity && !isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isToday ? NemoColors.brandBlue : NemoColors.accentOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DayDetailPanel extends StatelessWidget {
  const _DayDetailPanel({
    required this.selectedDate,
    required this.todayEpochDay,
    this.todayStats,
    this.selectedDateRecord,
    required this.weekForecast,
  });

  final DateTime selectedDate;
  final int todayEpochDay;
  final LearningStats? todayStats;
  final StudyRecord? selectedDateRecord;
  final List<ReviewForecast> weekForecast;

  @override
  Widget build(BuildContext context) {
    // 1:1 Restoration: Determine date state
    final selectedEpochDay = DateTimeUtils.dateToEpochDay(selectedDate);
    
    if (selectedEpochDay < todayEpochDay) {
      // Past Date: Show History
      final record = selectedDateRecord;
      if (record == null || record.totalActivity == 0) {
        return _EmptyState(text: '该日无学习记录');
      }
      return PremiumCard(
        child: Column(
          children: [
            _DetailSquircleItem(
              icon: Icons.history_rounded,
              color: NemoColors.accentIndigo,
              label: '历史复习',
              value: '${record.totalReviewed} 项',
            ),
            _DetailSquircleItem(
              icon: Icons.book_rounded,
              color: NemoColors.brandBlue,
              label: '新学单词',
              value: '${record.learnedWords} 个',
            ),
            _DetailSquircleItem(
              icon: Icons.edit_note_rounded,
              color: NemoColors.accentPurple,
              label: '新学语法',
              value: '${record.learnedGrammars} 条',
              showDivider: false,
            ),
          ],
        ),
      );
    } else if (selectedEpochDay == todayEpochDay) {
      // Today: Show Today Stats
      if (todayStats == null || todayStats!.todayTotalLearned + todayStats!.todayTotalReviewed == 0) {
        return _EmptyState(text: '今日尚未开始学习');
      }
      return PremiumCard(
        child: Column(
          children: [
            _DetailSquircleItem(
              icon: Icons.play_arrow_rounded,
              color: NemoColors.accentOrange,
              label: '今日已复',
              value: '${todayStats!.todayTotalReviewed} 项',
            ),
            _DetailSquircleItem(
              icon: Icons.book_rounded,
              color: NemoColors.brandBlue,
              label: '新学单词',
              value: '${todayStats!.todayLearnedWords} 个',
            ),
            _DetailSquircleItem(
              icon: Icons.edit_note_rounded,
              color: NemoColors.accentPurple,
              label: '新学语法',
              value: '${todayStats!.todayLearnedGrammars} 条',
              showDivider: false,
            ),
          ],
        ),
      );
    } else {
      // Future: Show Forecast
      final forecast = weekForecast.where((f) => f.date == selectedEpochDay).firstOrNull;
      if (forecast == null || forecast.count == 0) {
        return _EmptyState(text: '该日暂无复习计划');
      }
      return PremiumCard(
        child: Column(
          children: [
            _DetailSquircleItem(
              icon: Icons.event_available_rounded,
              color: NemoColors.accentOrange,
              label: '预计复习',
              value: '${forecast.count} 项',
              showDivider: false,
            ),
          ],
        ),
      );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.event_note_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                text,
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
}

class _DetailSquircleItem extends StatelessWidget {
  const _DetailSquircleItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 58),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
      ],
    );
  }
}
