import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/test_routes.dart';

class TestDashboardScreen extends StatefulWidget {
  const TestDashboardScreen({super.key});

  @override
  State<TestDashboardScreen> createState() => _TestDashboardScreenState();
}

class _TestDashboardScreenState extends State<TestDashboardScreen> {
  late final PageController _pageController;
  late final List<_StatsPagerData> _pages;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.96);
    _pages = const [
      _StatsPagerData(
        title: '今日测试',
        icon: Icons.bolt_rounded,
        iconBg: Color(0xFFD1FAE5),
        iconColor: Color(0xFF0F766E),
        leftValue: '36',
        leftLabel: '已测题目',
        midValue: '12天',
        midLabel: '连续学习',
        ringValue: 87,
        ringColor: Color(0xFF16A34A),
      ),
      _StatsPagerData(
        title: '总体统计',
        icon: Icons.emoji_events_rounded,
        iconBg: Color(0xFFFEE2E2),
        iconColor: Color(0xFFDC2626),
        leftValue: '528',
        leftLabel: '累计测试',
        midValue: '23天',
        midLabel: '最高连签',
        ringValue: 82,
        ringColor: Color(0xFFF59E0B),
      ),
    ];
    _autoScroll();
  }

  Future<void> _autoScroll() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(seconds: 5));
      if (!mounted || !_pageController.hasClients) {
        continue;
      }
      final next = (_currentPage + 1) % _pages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Text(
                '测试',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '选择题型，开始今日挑战',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 156,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _StatsCard(page: page);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final selected = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selected ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF0F766E)
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              _SectionTitle(title: '复习与回顾'),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(
                    child: _TileCard(
                      title: '我的错题',
                      subtitle: '27 个',
                      icon: Icons.cancel_rounded,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _TileCard(
                      title: '我的收藏',
                      subtitle: '43 个',
                      icon: Icons.star_rounded,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionTitle(title: '基础练习'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'multiple_choice'}),
                      borderRadius: BorderRadius.circular(18),
                      child: const _TileCard(
                        title: '选择题',
                        subtitle: '快速认知',
                        icon: Icons.assignment_rounded,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'typing'}),
                      borderRadius: BorderRadius.circular(18),
                      child: const _TileCard(
                        title: '手打题',
                        subtitle: '拼写强化',
                        icon: Icons.text_fields_rounded,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'card_matching'}),
                      borderRadius: BorderRadius.circular(18),
                      child: const _TileCard(
                        title: '卡片题',
                        subtitle: '翻牌记忆',
                        icon: Icons.view_module_rounded,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'sorting'}),
                      borderRadius: BorderRadius.circular(18),
                      child: const _TileCard(
                        title: '排序题',
                        subtitle: '逻辑构建',
                        icon: Icons.extension_rounded,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionTitle(title: '挑战自我'),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => context.pushNamed(TestRouteNames.settings, queryParameters: {'modeId': 'comprehensive'}),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x330F766E),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.all_inclusive_rounded,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '综合测试',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '随机组合全部题型，检测整体水平',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.page});

  final _StatsPagerData page;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: page.icon,
              iconColor: page.iconColor,
              iconBg: page.iconBg,
              value: page.leftValue,
              label: page.leftLabel,
              title: page.title,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: const Color(0xFFDC2626),
              iconBg: const Color(0xFFFEE2E2),
              value: page.midValue,
              label: page.midLabel,
            ),
          ),
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: page.ringValue / 100,
                  strokeWidth: 8,
                  backgroundColor: Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(page.ringColor),
                ),
                Text(
                  '${page.ringValue}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
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

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.title,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF64748B),
              ),
        ),
      ],
    );
  }
}

class _StatsPagerData {
  const _StatsPagerData({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.leftValue,
    required this.leftLabel,
    required this.midValue,
    required this.midLabel,
    required this.ringValue,
    required this.ringColor,
  });

  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String leftValue;
  final String leftLabel;
  final String midValue;
  final String midLabel;
  final int ringValue;
  final Color ringColor;
}

class _TileCard extends StatelessWidget {
  const _TileCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
        ],
      ),
    );
  }
}
