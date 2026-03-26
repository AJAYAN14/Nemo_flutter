import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class LearningCalendarScreen extends StatefulWidget {
  const LearningCalendarScreen({super.key});

  @override
  State<LearningCalendarScreen> createState() => _LearningCalendarScreenState();
}

class _LearningCalendarScreenState extends State<LearningCalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Mock data
    const todayLearnedWords = 12;
    const todayLearnedGrammars = 2;
    const dueCount = 84;
    const completedCount = 38;

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
          _TodaySummaryCard(
            learnedWords: todayLearnedWords,
            learnedGrammars: todayLearnedGrammars,
            dueCount: dueCount,
            completedCount: completedCount,
          ),
          
          const SizedBox(height: 24),

          // 2. 本周进度 (Week View)
          const _SectionTitle('本周进度'),
          _WeekViewCard(
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),

          const SizedBox(height: 24),

          // 3. 详细记录 (Day Detail)
          const _SectionTitle('详细记录'),
          _DayDetailPanel(selectedDate: _selectedDate),
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
  const _TodaySummaryCard({
    required this.learnedWords,
    required this.learnedGrammars,
    required this.dueCount,
    required this.completedCount,
  });

  final int learnedWords;
  final int learnedGrammars;
  final int dueCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
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
                  label: '已完成',
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
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Generate 7 days starting from today
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
              
              // Get day of week (Monday=1, Sunday=7)
              final label = weekDayLabels[date.weekday - 1];

              return _WeekDayItem(
                label: label,
                dayNumber: '${date.day}',
                isToday: isToday,
                isSelected: isSelected,
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
    required this.onTap,
  });

  final String label;
  final String dayNumber;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected 
        ? Colors.white 
        : (isToday ? NemoColors.brandBlue : Theme.of(context).colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? NemoColors.brandBlue : (isToday ? NemoColors.brandBlue.withValues(alpha: 0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(18),
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
          ],
        ),
      ),
    );
  }
}

class _DayDetailPanel extends StatelessWidget {
  const _DayDetailPanel({required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    // Mock check for data
    final hasData = selectedDate.day % 2 == 0;

    return PremiumCard(
      child: hasData 
        ? Column(
            children: [
              _DetailSquircleItem(
                icon: Icons.play_arrow_rounded,
                color: NemoColors.accentOrange,
                label: '待复习',
                value: '84 项',
              ),
              _DetailSquircleItem(
                icon: Icons.book_rounded,
                color: NemoColors.brandBlue,
                label: '新学单词',
                value: '12 个',
              ),
              _DetailSquircleItem(
                icon: Icons.edit_note_rounded,
                color: NemoColors.accentPurple,
                label: '新学语法',
                value: '2 条',
                showDivider: false,
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '该日无学习记录',
                    style: TextStyle(
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
