import 'dart:async';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../routes/test_routes.dart';

class TestDashboardScreen extends HookConsumerWidget {
  const TestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 8.0;
    final bottomPadding = mediaQuery.padding.bottom + 104.0;

    // Mock UI State
    final uiState = _MockTestUiState(
      todayTestCount: 15,
      consecutiveTestDays: 12,
      todayAccuracy: 0.88,
      totalTestCount: 1420,
      maxTestStreak: 30,
      overallAccuracy: 0.92,
      wrongWordsCount: 24,
      favoriteWordsCount: 56,
    );

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, topPadding, 16, bottomPadding),
        children: [
            // Immersive Header
            const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 8),
              child: Text(
                '测试',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),

            // Stats Pager
            _TestStatsCarousel(uiState: uiState),

            const SizedBox(height: 24),

            // Review & Recap Section
            const SectionTitle('复习与回顾'),
            Row(
              children: [
                Expanded(
                  child: _DashboardTile(
                    title: '我的错题',
                    subtitle: '${uiState.wrongWordsCount} 个',
                    icon: Icons.cancel_rounded,
                    color: const Color(0xFFEF4444), // NemoDanger
                    onClick: () => context.pushNamed('statistics_leech'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DashboardTile(
                    title: '我的收藏',
                    subtitle: '${uiState.favoriteWordsCount} 个',
                    icon: Icons.star_rounded,
                    color: const Color(0xFFF97316), // NemoOrange
                    onClick: () => context.pushNamed('library-word-list'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Basic Practice Section
            const SectionTitle('基础练习'),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DashboardTile(
                        title: '选择题',
                        subtitle: '快速认知',
                        icon: Icons.assignment_rounded,
                        color: const Color(0xFF0E68FF), // NemoSecondary/Primary
                        onClick: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'multiple_choice'}),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DashboardTile(
                        title: '手打题',
                        subtitle: '拼写强化',
                        icon: Icons.text_fields_rounded,
                        color: const Color(0xFF6366F1), // NemoIndigo
                        onClick: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'typing'}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DashboardTile(
                        title: '卡片题',
                        subtitle: '翻牌记忆',
                        icon: Icons.view_module_rounded,
                        color: const Color(0xFF14B8A6), // NemoTeal
                        onClick: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'card_matching'}),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DashboardTile(
                        title: '排序题',
                        subtitle: '逻辑构建',
                        icon: Icons.extension_rounded,
                        color: const Color(0xFF8B5CF6), // NemoPurple
                        onClick: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'sorting'}),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Challenge Section
            const SectionTitle('挑战自我'),
            _DashboardBanner(
              title: '综合测试',
              subtitle: '随机组合所有题型进行全面检测',
              icon: Icons.all_inclusive_rounded,
              color: NemoColors.brandBlue,
              onClick: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'comprehensive'}),
            ),

          ],
        ),
    );
  }
}

class _TestStatsCarousel extends StatefulWidget {
  const _TestStatsCarousel({required this.uiState});
  final _MockTestUiState uiState;

  @override
  State<_TestStatsCarousel> createState() => _TestStatsCarouselState();
}

class _TestStatsCarouselState extends State<_TestStatsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % 2;
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
    final pages = [
      _CompactStatsPage(
        title: '今日测试',
        icon: Icons.bolt_rounded,
        accent: NemoColors.brandBlue,
        primaryValue: widget.uiState.todayTestCount.toString(),
        primaryLabel: '已测题目',
        secondaryValue: widget.uiState.consecutiveTestDays.toString(),
        secondaryUnit: '天',
        secondaryLabel: '连续学习',
        ringValue: (widget.uiState.todayAccuracy * 100).round(),
        ringLabel: '今日正确率',
      ),
      _CompactStatsPage(
        title: '总体统计',
        icon: Icons.emoji_events_rounded,
        accent: const Color(0xFFEF4444),
        primaryValue: widget.uiState.totalTestCount.toString(),
        primaryLabel: '累计测试',
        secondaryValue: widget.uiState.maxTestStreak.toString(),
        secondaryUnit: '天',
        secondaryLabel: '最高连签',
        ringValue: (widget.uiState.overallAccuracy * 100).round(),
        ringLabel: '累计正确率',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 185, // Adjust height here to avoid overflow
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: pages,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(pages.length, (index) {
              final active = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? pages[_currentPage].accent
                      : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
            const SizedBox(width: 8),
            Text(
              '${_currentPage + 1}/${pages.length}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CompactStatsPage extends StatelessWidget {
  const _CompactStatsPage({
    required this.title,
    required this.icon,
    required this.accent,
    required this.primaryValue,
    required this.primaryLabel,
    required this.secondaryValue,
    required this.secondaryUnit,
    required this.secondaryLabel,
    required this.ringValue,
    required this.ringLabel,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String primaryValue;
  final String primaryLabel;
  final String secondaryValue;
  final String secondaryUnit;
  final String secondaryLabel;
  final int ringValue;
  final String ringLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PremiumCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Reduced from 12
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _CompactStatItem(
                          value: primaryValue,
                          label: primaryLabel,
                          accentColor: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _CompactStatItem(
                          value: secondaryValue,
                          unit: secondaryUnit,
                          label: secondaryLabel,
                          accentColor: accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 72, // Reduced from 80
                          height: 72,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 8, // Reduced from 9
                            color: isDark
                                ? Theme.of(context).colorScheme.surfaceContainerHighest
                                : const Color(0xFFEFF3F8),
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(
                            value: ringValue / 100,
                            strokeWidth: 8,
                            strokeCap: StrokeCap.round,
                            color: _getRingColor(ringValue),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min, // Added
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              ringValue.toString(),
                              style: const TextStyle(
                                fontSize: 20, // Reduced from 24
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                            const Text(
                              '%',
                              style: TextStyle(
                                fontSize: 8, // Reduced from 10
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ringLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
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

  Color _getRingColor(int accuracy) {
    if (accuracy < 60) return const Color(0xFFEF4444);
    if (accuracy < 85) return const Color(0xFFF97316);
    return const Color(0xFF10B981);
  }
}

class _CompactStatItem extends StatelessWidget {
  const _CompactStatItem({
    required this.value,
    this.unit = '',
    required this.label,
    required this.accentColor,
  });

  final String value;
  final String unit;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surfaceContainerHigh : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20, // Reduced from 22
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  fontFamily: 'monospace',
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                ),
              ],
            ],
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onClick,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onClick: onClick,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBanner extends StatelessWidget {
  const _DashboardBanner({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onClick,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onClick: onClick,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 100,
              color: color.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockTestUiState {
  final int todayTestCount;
  final int consecutiveTestDays;
  final double todayAccuracy;
  final int totalTestCount;
  final int maxTestStreak;
  final double overallAccuracy;
  final int wrongWordsCount;
  final int favoriteWordsCount;

  _MockTestUiState({
    required this.todayTestCount,
    required this.consecutiveTestDays,
    required this.todayAccuracy,
    required this.totalTestCount,
    required this.maxTestStreak,
    required this.overallAccuracy,
    required this.wrongWordsCount,
    required this.favoriteWordsCount,
  });
}
