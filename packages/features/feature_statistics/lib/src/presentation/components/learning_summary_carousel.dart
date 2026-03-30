import 'dart:async';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class LearningSummaryCarousel extends StatefulWidget {
  const LearningSummaryCarousel({
    super.key,
    required this.progress,
    required this.masteredCount,
    required this.totalWords,
    required this.todayLearned,
    required this.dailyGoal,
    required this.unmasteredCount,
    required this.studyStreak,
    required this.dueCount,
    required this.totalStudyDays,
    required this.weekStudyDays,
  });

  final double progress;
  final int masteredCount;
  final int totalWords;
  final int todayLearned;
  final int dailyGoal;
  final int unmasteredCount;
  final int studyStreak;
  final int dueCount;
  final int totalStudyDays;
  final int weekStudyDays;

  @override
  State<LearningSummaryCarousel> createState() => _LearningSummaryCarouselState();
}

class _LearningSummaryCarouselState extends State<LearningSummaryCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayProgress = (widget.dailyGoal <= 0)
        ? 0
        : (widget.todayLearned >= widget.dailyGoal)
            ? 100
            : ((widget.todayLearned / widget.dailyGoal) * 100).toInt();

    final pages = [
      BentoStatsGrid(
        title: '日间概览',
        icon: Icons.calendar_today_rounded,
        accentColor: NemoColors.brandBlue,
        mainLabel: '今日已学',
        mainValue: widget.todayLearned.toString(),
        mainUnit: '个',
        topRightLabel: '待复习',
        topRightValue: widget.dueCount.toString(),
        topRightUnit: '词',
        bottomRightLabel: '目标完成度',
        bottomRightValue: todayProgress.toString(),
        bottomRightUnit: '%',
        visualType: BentoVisualType.progress,
        progress: todayProgress,
      ),
      BentoStatsGrid(
        title: '学习轨迹',
        icon: Icons.timeline_rounded,
        accentColor: const Color(0xFF10B981), // Green
        mainLabel: '连续学习',
        mainValue: widget.studyStreak.toString(),
        mainUnit: '天',
        topRightLabel: '累计掌握',
        topRightValue: widget.masteredCount.toString(),
        topRightUnit: '词',
        bottomRightLabel: '待学习',
        bottomRightValue: widget.unmasteredCount.toString(),
        bottomRightUnit: '词',
        visualType: BentoVisualType.dots,
      ),
      BentoStatsGrid(
        title: '成长总览',
        icon: Icons.trending_up_rounded,
        accentColor: const Color(0xFFF4B73F), // Orange/Gold
        mainLabel: '总进度',
        mainValue: (widget.progress * 100).toInt().toString(),
        mainUnit: '%',
        topRightLabel: '累计学习',
        topRightValue: widget.totalStudyDays.toString(),
        topRightUnit: '天',
        bottomRightLabel: '本周学习',
        bottomRightValue: widget.weekStudyDays.toString(),
        bottomRightUnit: '天',
        visualType: BentoVisualType.bars,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 168, // BENTO_GRID_HEIGHT
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: pages,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final active = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active
                    ? pages[_currentPage].accentColor
                    : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

enum BentoVisualType { progress, dots, bars }

class BentoStatsGrid extends StatelessWidget {
  const BentoStatsGrid({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.mainLabel,
    required this.mainValue,
    required this.mainUnit,
    required this.topRightLabel,
    required this.topRightValue,
    required this.topRightUnit,
    required this.bottomRightLabel,
    required this.bottomRightValue,
    required this.bottomRightUnit,
    required this.visualType,
    this.progress = 0,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final String mainLabel;
  final String mainValue;
  final String mainUnit;
  final String topRightLabel;
  final String topRightValue;
  final String topRightUnit;
  final String bottomRightLabel;
  final String bottomRightValue;
  final String bottomRightUnit;
  final BentoVisualType visualType;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 145, // 1.45 weight
          child: _BentoMainTile(
            label: mainLabel,
            value: mainValue,
            unit: mainUnit,
            accentColor: accentColor,
            icon: icon,
            visualType: visualType,
            progress: progress,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 100, // 1 weight
          child: Column(
            children: [
              Expanded(
                child: _BentoSubTile(
                  label: topRightLabel,
                  value: topRightValue,
                  unit: topRightUnit,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _BentoSubTile(
                  label: bottomRightLabel,
                  value: bottomRightValue,
                  unit: bottomRightUnit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BentoMainTile extends StatelessWidget {
  const _BentoMainTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.accentColor,
    required this.icon,
    required this.visualType,
    this.progress = 0,
  });

  final String label;
  final String value;
  final String unit;
  final Color accentColor;
  final IconData icon;
  final BentoVisualType visualType;
  final int progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? accentColor.withValues(alpha: 0.88) : accentColor;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -6,
            right: -8,
            child: Icon(
              icon,
              size: 72,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _BentoVisualHint(visualType, progress: progress),
                const SizedBox(height: 8),
                Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontFeatures: [FontFeature.tabularFigures()],
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.56),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoSubTile extends StatelessWidget {
  const _BentoSubTile({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerHigh : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
                ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BentoVisualHint extends StatelessWidget {
  const _BentoVisualHint(this.type, {this.progress = 0});
  final BentoVisualType type;
  final int progress; // Percentage 0-100

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BentoVisualType.progress:
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (progress / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      case BentoVisualType.dots:
        return Column(
          children: [
            Row(
              children: List.generate(7, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index < 5 ? Colors.white.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
          ],
        );
      case BentoVisualType.bars:
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [8.0, 12.0, 16.0, 10.0].map((h) {
                final index = [8.0, 12.0, 16.0, 10.0].indexOf(h);
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 4,
                  height: h,
                  decoration: BoxDecoration(
                    color: index == 2
                        ? Colors.white
                        : index == 1
                            ? Colors.white.withValues(alpha: 0.45)
                            : index == 3
                                ? Colors.white.withValues(alpha: 0.62)
                                : Colors.white.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        );
    }
  }
}
