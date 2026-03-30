import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui/core_ui.dart';
import '../routes/statistics_routes.dart';
import 'components/learning_summary_carousel.dart';
import 'statistics_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 8.0;
    final bottomPadding = mediaQuery.padding.bottom + 104.0;

    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: EdgeInsets.fromLTRB(16, topPadding, 16, bottomPadding),
          children: [
            // Immersive Header
            const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 8),
              child: Text(
                '进度',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),

            // Learning Summary Carousel (Bento Grid)
            LearningSummaryCarousel(
              progress: stats.totalWords + stats.totalGrammars > 0
                  ? stats.totalMastered / (stats.totalWords + stats.totalGrammars)
                  : 0.0,
              masteredCount: stats.totalMastered,
              totalWords: stats.totalWords + stats.totalGrammars,
              todayLearned: stats.todayTotalLearned,
              dailyGoal: stats.wordDailyGoal + stats.grammarDailyGoal,
              unmasteredCount: (stats.totalWords + stats.totalGrammars) - stats.totalMastered,
              studyStreak: stats.dailyStreak,
              dueCount: stats.totalDue,
              totalStudyDays: stats.totalStudyDays,
              weekStudyDays: stats.weekStudyDays,
            ),

            const SizedBox(height: 20),

            // Review Section
            const SectionTitle('复习与训练'),
            PremiumCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SquircleListItem(
                    icon: Icons.schedule_rounded,
                    iconColor: NemoColors.brandBlue,
                    title: '今日到期复习',
                    subtitle: '核心复习任务',
                    onClick: () {
                      context.push('/home/session-prep');
                    },
                  ),
                  SquircleListItem(
                    icon: Icons.sports_esports_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: '专项训练',
                    subtitle: '针对性强化练习',
                    onClick: () {
                      context.push('/library/category/practice');
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Data & Resources Section
            const SectionTitle('数据与资料'),
            PremiumCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SquircleListItem(
                    icon: Icons.bubble_chart_rounded,
                    iconColor: NemoColors.brandBlue,
                    title: '学习日历',
                    subtitle: '查看学习计划与记录',
                    onClick: () => context.pushNamed(StatisticsRouteNames.calendar),
                  ),
                  SquircleListItem(
                    icon: Icons.query_stats_rounded,
                    iconColor: const Color(0xFFEF4444), // Danger/Red
                    title: '今日统计',
                    subtitle: '查看今日详细的学习统计',
                    onClick: () {
                      context.pushNamed(StatisticsRouteNames.today);
                    },
                  ),
                  SquircleListItem(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: NemoColors.accentOrange,
                    title: '学习热力图',
                    subtitle: '年度学习活跃度回顾',
                    onClick: () => context.pushNamed(StatisticsRouteNames.heatmap),
                  ),
                  SquircleListItem(
                    icon: Icons.insights_rounded,
                    iconColor: const Color(0xFFAF52DE), // Purple
                    title: '历史统计',
                    subtitle: '查看所有详细的学习统计',
                    onClick: () => context.pushNamed(StatisticsRouteNames.history),
                  ),
                  SquircleListItem(
                    icon: Icons.sort_by_alpha_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: '单词列表',
                    subtitle: '词汇库管理',
                    onClick: () {
                      context.push('/library/wordList');
                    },
                  ),
                  SquircleListItem(
                    icon: Icons.dataset_rounded,
                    iconColor: NemoColors.brandBlue,
                    title: '专项词汇',
                    subtitle: '按分类查看词汇',
                    onClick: () {
                      context.push('/library/category/library');
                    },
                  ),
                  SquircleListItem(
                    icon: Icons.book_rounded,
                    iconColor: NemoColors.brandBlue,
                    title: '语法列表',
                    subtitle: '语法知识库',
                    onClick: () {
                      context.push('/library/grammarList');
                    },
                  ),
                  SquircleListItem(
                    icon: Icons.auto_fix_high_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: '复学清单',
                    subtitle: '难点项召回与复习',
                    onClick: () => context.pushNamed(StatisticsRouteNames.leech),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
