import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../routes/learning_routes.dart';
import 'session_prep_providers.dart';

class SessionPrepScreen extends ConsumerWidget {
  const SessionPrepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionDataAsync = ref.watch(sessionPrepViewModelProvider);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      body: sessionDataAsync.when(
        data: (sessionData) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: NemoColors.textMain, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                '复习准备',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: NemoColors.textMain,
                    ),
              ),
              centerTitle: true,
              pinned: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SummaryStatCard(
                    totalCount: sessionData.totalCount,
                    reviewedCount: sessionData.reviewedCount,
                    remainingCount: sessionData.remainingCount,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Text(
                        '内容预览',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: NemoColors.textMain,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${sessionData.words.length} 条待复习',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: NemoColors.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...sessionData.words.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _WordCard(item: item),
                      )),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: NemoColors.brandBlue),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: NemoColors.accentOrange, size: 48),
              const SizedBox(height: 16),
              Text('加载失败: $err', style: const TextStyle(color: NemoColors.textMain)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(sessionPrepViewModelProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: sessionDataAsync.valueOrNull?.words.isNotEmpty == true 
          ? _FloatingStartButton() 
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _FloatingStartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            context.pushNamed(
              LearningRouteNames.srsReview,
              pathParameters: {'mode': 'all'}, // Unified review mode (word + grammar)
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: NemoColors.brandBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
            elevation: 8,
            shadowColor: NemoColors.brandBlue.withValues(alpha: 0.4),
          ),
          child: const Text(
            '开始复习',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({
    required this.totalCount,
    required this.reviewedCount,
    required this.remainingCount,
  });

  final int totalCount;
  final int reviewedCount;
  final int remainingCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCardItem(
            label: '总任务',
            value: '$totalCount',
            color: NemoColors.brandBlue,
            icon: Icons.assignment_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCardItem(
            label: '已复习',
            value: '$reviewedCount',
            color: NemoColors.accentGreen,
            icon: Icons.check_circle_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCardItem(
            label: '剩余',
            value: '$remainingCount',
            color: NemoColors.accentOrange,
            icon: Icons.schedule_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCardItem extends StatelessWidget {
  const _StatCardItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: NemoColors.textMain,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: NemoColors.textMuted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.item});

  final SessionPrepWordItem item;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: NemoColors.brandBlue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      item.japanese,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: NemoColors.textMain,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.hiragana,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: NemoColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.meaning,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NemoColors.textSub,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          _LevelTag(level: item.level),
        ],
      ),
    );
  }
}

class _LevelTag extends StatelessWidget {
  const _LevelTag({required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NemoColors.bgBase,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: NemoColors.brandBlue,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
