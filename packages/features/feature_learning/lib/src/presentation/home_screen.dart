import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mock/home_mock_data.dart';
import '../routes/learning_routes.dart';
import 'components/level_selection_sheet.dart';
import 'home_providers.dart';

const double kCardRadius = 24.0;
const double kGridGap = 12.0;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    // Padding values: edge-to-edge immersive navigation
    final topPadding = mediaQuery.padding.top + 16.0;
    final bottomPadding = mediaQuery.padding.bottom + 104.0;

    Widget buildBody(HomeViewModel vm) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, topPadding, 16, bottomPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _Header(vm: vm),
                const SizedBox(height: 20),
                _BentoControlCard(vm: vm, ref: ref),
                const SizedBox(height: kGridGap),
                _BentoMiddleGrid(vm: vm),
                const SizedBox(height: kGridGap),
                _BentoActionButton(vm: vm),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '学习资源',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: NemoColors.textSub,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ResourceSection(),
              ]),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      body: homeAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (vm) => buildBody(vm),
        loading: () {
          // 提供一个带有默认值的骨架，避免闪烁且保持初始 UI 处于原位
          final dummyVm = HomeViewModel(
            mode: LearningMode.words,
            dateText: '...',
            greeting: '...',
            learned: 0,
            goal: 0,
            reviewed: 0,
            reviewDue: 0,
            accuracy: 0,
            progress: 0.0,
            levelLabel: '-',
            highlightColor: NemoColors.wordsPrimary,
          );
          return buildBody(dummyVm);
        },
        error: (err, stack) => Center(child: Text('加载失败: $err')),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.vm});
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.dateText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: NemoColors.textSub,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                vm.greeting,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: NemoColors.textMain,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: NemoColors.textMuted.withValues(alpha: 0.3), width: 2),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: NemoColors.surfaceSoft,
              child: Icon(Icons.person_rounded, color: NemoColors.textMain, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoControlCard extends StatelessWidget {
  const _BentoControlCard({required this.vm, required this.ref});
  final HomeViewModel vm;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isWords = vm.mode == LearningMode.words;
    final primaryColor = isWords ? NemoColors.wordsPrimary : NemoColors.grammarPrimary;
    final secondaryColor = isWords ? NemoColors.wordsLight : NemoColors.grammarLight;

    return _cardContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  builder: (context) => LevelSelectionSheet(
                    selectedLevel: vm.levelLabel,
                    primaryColor: primaryColor,
                    onLevelSelected: (level) {
                      ref.read(selectedLevelNotifierProvider.notifier).setLevel(level);
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(999)),
                child: Row(
                  children: [
                    Text(
                      'JLPT ${vm.levelLabel}',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.2),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 10, color: primaryColor.withValues(alpha: 0.5)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: NemoColors.bgBase, borderRadius: BorderRadius.circular(999)),
              child: Row(
                children: [
                  _ModeButton(
                    label: '单词',
                    isSelected: isWords,
                    onTap: () => ref.read(learningModeNotifierProvider.notifier).setMode(LearningMode.words),
                  ),
                  _ModeButton(
                    label: '语法',
                    isSelected: !isWords,
                    onTap: () => ref.read(learningModeNotifierProvider.notifier).setMode(LearningMode.grammar),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? NemoColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? NemoColors.textMain : NemoColors.textSub,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _BentoMiddleGrid extends StatelessWidget {
  const _BentoMiddleGrid({required this.vm});
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _cardContainer(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('今日新学进度', style: TextStyle(color: NemoColors.textSub, fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: NemoCircularProgress(
                          progress: vm.progress,
                          strokeWidth: 12,
                          trackColor: NemoColors.divider,
                          progressColor: vm.highlightColor,
                        ),
                      ),
                      Text(
                        '${vm.learned}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: NemoColors.textMain),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '新学目标 ${vm.goal}',
                    style: const TextStyle(color: NemoColors.textMuted, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: kGridGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _cardContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatusIcon(icon: Icons.restore_rounded, color: NemoColors.accentOrange, bgColor: NemoColors.iconBgOrange),
                        const SizedBox(height: 12),
                        _AnnotatedStat(current: vm.reviewed, total: vm.reviewDue + vm.reviewed),
                        const Text('复习进度', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NemoColors.textSub)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kGridGap),
                Expanded(
                  child: _cardContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatusIcon(icon: Icons.check_circle_rounded, color: NemoColors.accentGreen, bgColor: NemoColors.iconBgGreen),
                        const SizedBox(height: 12),
                        Text(
                          '${vm.accuracy}%',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: NemoColors.textMain, height: 1.1),
                        ),
                        const Text('学习达成率', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NemoColors.textSub)),
                        const Text('仅统计新学目标', style: TextStyle(fontSize: 11, color: NemoColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.icon, required this.color, required this.bgColor});
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _AnnotatedStat extends StatelessWidget {
  const _AnnotatedStat({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$current',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: NemoColors.textMain),
          ),
          TextSpan(
            text: '/$total',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: NemoColors.textSub),
          ),
        ],
      ),
    );
  }
}

class _BentoActionButton extends StatelessWidget {
  const _BentoActionButton({required this.vm});
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final mode = vm.mode == LearningMode.words ? 'word' : 'grammar';
        context.pushNamed(
          LearningRouteNames.srsStudy,
          pathParameters: {'mode': mode},
        );
      },
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(color: vm.highlightColor, borderRadius: BorderRadius.circular(kCardRadius)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '立即开始',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ResourceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '学习资源',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: NemoColors.textSub,
                  letterSpacing: 0.5,
                ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/statistics/heatmap'),
          child: _cardContainer(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: NemoColors.iconBgPurple, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.emoji_events_rounded, color: NemoColors.accentPurple, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('学习热力图', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: NemoColors.textMain)),
                      Text('查看你的学习足迹', style: TextStyle(fontSize: 12, color: NemoColors.textSub)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: NemoColors.bgBase, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_rounded, color: NemoColors.textSub, size: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SubResource(
                title: '五十音图',
                sub: '平假名片假名',
                icon: Icons.language_rounded,
                color: NemoColors.accentBlue,
                bg: NemoColors.iconBgBlue,
                onTap: () => context.push('/home/kana'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SubResource(
                title: '语法分类',
                sub: '语法精讲',
                icon: Icons.create_rounded,
                color: NemoColors.accentGreen,
                bg: NemoColors.iconBgGreen,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('语法分类即将上线')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubResource extends StatelessWidget {
  const _SubResource({
    required this.title,
    required this.sub,
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });
  final String title, sub;
  final IconData icon;
  final Color color, bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.3,
        child: _cardContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: NemoColors.textSub.withValues(alpha: 0.5)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: NemoColors.textMain)),
                  Text(sub, style: const TextStyle(fontSize: 11, color: NemoColors.textSub)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _cardContainer({required Widget child, EdgeInsetsGeometry? padding}) {
  return Container(
    padding: padding,
    decoration: BoxDecoration(
      color: NemoColors.surface,
      borderRadius: BorderRadius.circular(kCardRadius),
      border: Border.all(color: NemoColors.divider.withValues(alpha: 0.5), width: 0.5),
    ),
    child: child,
  );
}
