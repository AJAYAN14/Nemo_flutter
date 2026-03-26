import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/user_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NemoColors.surfaceSoft,
      appBar: AppBar(
        title: const Text('我的', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.settings, color: NemoColors.textMain),
            // Navigate to settings route via context
            onPressed: () {
              // The Settings Route is added at root level, so we go absolute
              context.pushNamed('settings'); 
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar & Name Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.person_solid,
                      size: 50,
                      color: NemoColors.brandBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nemo Learner',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: NemoColors.textMain,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'UID: 8848123',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NemoColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Study Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: NemoMetrics.radius(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(context, label: '连续打卡', value: '12', suffix: '天'),
                    _buildDivider(),
                    _buildStatColumn(context, label: '累计学习', value: '87', suffix: '天'),
                    _buildDivider(),
                    _buildStatColumn(context, label: '掌握词汇', value: '1.2k', suffix: '词'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Navigation Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildListTile(
                    context,
                    icon: CupertinoIcons.person_crop_circle,
                    title: '账号与安全管理',
                    color: const Color(0xFF3B82F6),
                    onTap: () => context.pushNamed(UserRouteNames.account),
                  ),
                  const SizedBox(height: 12),
                  _buildListTile(
                    context,
                    icon: CupertinoIcons.star_fill,
                    title: '给应用打分',
                    color: const Color(0xFFF59E0B),
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildListTile(
                    context,
                    icon: CupertinoIcons.question_circle_fill,
                    title: '帮助与反馈',
                    color: const Color(0xFF10B981),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, {required String label, required String value, required String suffix}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: NemoColors.textMain,
                  ),
            ),
            const SizedBox(width: 2),
            Text(
              suffix,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: NemoColors.textMuted,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: NemoColors.textSub,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: NemoColors.borderLight,
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: NemoMetrics.radius(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: NemoMetrics.radius(16),
          border: Border.all(color: NemoColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: NemoColors.textMain,
                    ),
              ),
            ),
            const Icon(CupertinoIcons.chevron_right, color: NemoColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
