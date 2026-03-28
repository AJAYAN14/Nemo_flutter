import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../routes/settings_routes.dart';
import 'components/settings_components.dart';
import 'components/settings_dialogs.dart';

import 'package:core_prefs/core_prefs.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 16.0;
    final bottomPadding = mediaQuery.padding.bottom + 104.0;
    
    // Watch persistent providers from core_prefs
    final darkMode = ref.watch(darkModeProvider);
    final isAutoSync = ref.watch(autoSyncProvider);
    final dailyGoal = ref.watch(wordGoalProvider); // Renamed to wordGoalProvider
    final grammarGoal = ref.watch(grammarGoalProvider);
    final resetHour = ref.watch(resetHourProvider);
    final isRandom = ref.watch(randomContentProvider);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, topPadding, 16, bottomPadding),
        children: [
            // 0. Immersive Settings Header
            const ImmersiveSettingsHeader(title: '设置'),

            // 1. Account & Sync
            const SettingsSectionTitle('账号与同步'),
            PremiumCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _UserProfileRow(
                    username: 'Nemo Learner',
                    email: 'nemo@example.com',
                    onClick: () => context.pushNamed('user_account'),
                  ),
                  const _SectionDivider(),
                  PremiumSettingsItem(
                    icon: Icons.cloud_sync_rounded,
                    iconColor: const Color(0xFF00C7BE), // NemoCyan
                    title: '自动同步',
                    subtitle: isAutoSync ? '上次同步：03-25 19:10' : '同步您的学习进度',
                    onClick: () {
                       showDialog(
                        context: context,
                        builder: (context) => const ConflictResolutionDialog(),
                      );
                    },
                    showDivider: false,
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: isAutoSync,
                        activeTrackColor: const Color(0xFF0E68FF), // NemoPrimary
                        onChanged: (val) => ref.read(autoSyncProvider.notifier).toggle(val),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Appearance
            const SettingsSectionTitle('外观'),
            PremiumCard(
              padding: EdgeInsets.zero,
              child: PremiumSettingsItem(
                icon: Icons.contrast_rounded,
                iconColor: const Color(0xFFAF52DE), // NemoPurple
                title: '主题外观',
                showDivider: false,
                trailing: _ThemeSelector(
                  selectedOption: darkMode,
                  onSelected: (val) => ref.read(darkModeProvider.notifier).set(val),
                ),
              ),
            ),

            // 3. Learning
            const SettingsSectionTitle('学习'),
            PremiumCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   PremiumSettingsItem(
                    icon: Icons.track_changes_rounded,
                    iconColor: const Color(0xFFFF9500), // NemoOrange
                    title: '每日单词目标',
                    subtitle: '设置每天要学习的单词数量',
                    onClick: () => context.showNemoBottomSheet(
                      child: DailyGoalSelectionBottomSheet(
                        currentGoal: dailyGoal,
                        onSelected: (val) => ref.read(wordGoalProvider.notifier).set(val),
                      ),
                    ),
                    trailing: _TrailingValue('$dailyGoal个'),
                  ),
                  PremiumSettingsItem(
                    icon: Icons.join_left_rounded,
                    iconColor: const Color(0xFF34C759), // NemoGreen
                    title: '每日语法目标',
                    subtitle: '设置每天要学习的语法数量',
                    onClick: () => context.showNemoBottomSheet(
                      child: GrammarDailyGoalSelectionBottomSheet(
                        currentGoal: grammarGoal,
                        onSelected: (val) => ref.read(grammarGoalProvider.notifier).set(val),
                      ),
                    ),
                    trailing: _TrailingValue('$grammarGoal条'),
                  ),
                  PremiumSettingsItem(
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFF5856D6), // NemoIndigo
                    title: '学习日重置时间',
                    subtitle: '零点跨天保护，过了此时间才算新的一天',
                    onClick: () => context.showNemoBottomSheet(
                      child: LearningDayResetHourBottomSheet(
                        currentHour: resetHour,
                        onSelected: (val) => ref.read(resetHourProvider.notifier).set(val),
                      ),
                    ),
                    trailing: _TrailingValue('${resetHour.toString().padLeft(2, '0')}:00'),
                  ),
                  PremiumSettingsItem(
                    icon: Icons.shuffle_rounded,
                    iconColor: const Color(0xFF0E68FF), // NemoPrimary
                    title: '新内容乱序抽取',
                    subtitle: isRandom ? '随机抽取新内容' : '按顺序抽取新内容',
                    onClick: () => ref.read(randomContentProvider.notifier).toggle(!isRandom),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isRandom,
                        activeTrackColor: const Color(0xFF0E68FF), // NemoPrimary
                        onChanged: (val) => ref.read(randomContentProvider.notifier).toggle(val),
                      ),
                    ),
                  ),
                  PremiumSettingsItem(
                    icon: Icons.settings_rounded,
                    iconColor: const Color(0xFFAF52DE), // NemoPurple
                    title: '记忆算法配置',
                    subtitle: '步进、提前复习与 Leech 策略',
                    onClick: () => context.pushNamed(SettingsRouteNames.srs),
                    showDivider: false,
                  ),
                ],
              ),
            ),

            // 4. Audio
            const SettingsSectionTitle('语音'),
            PremiumCard(
              padding: EdgeInsets.zero,
              child: PremiumSettingsItem(
                icon: Icons.volume_up_rounded,
                iconColor: const Color(0xFFFF2D55), // NemoRed/Pink
                title: '语音参数',
                subtitle: '调节语速和音调',
                onClick: () => context.pushNamed(SettingsRouteNames.tts),
                showDivider: false,
              ),
            ),

            // 5. Data
            const SettingsSectionTitle('数据'),
            PremiumCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const PremiumSettingsItem(
                    icon: Icons.file_download_rounded,
                    iconColor: Color(0xFF34C759), // NemoGreen
                    title: '导出同步数据',
                    subtitle: '导出本地同步文件',
                  ),
                  const PremiumSettingsItem(
                    icon: Icons.file_upload_rounded,
                    iconColor: Color(0xFF0E68FF), // NemoPrimary
                    title: '导入同步数据',
                    subtitle: '从文件恢复进度',
                  ),
                  PremiumSettingsItem(
                    icon: Icons.delete_rounded,
                    iconColor: const Color(0xFFE53935), // NemoDanger
                    title: '重置学习进度',
                    subtitle: '清空所有数据 (慎用)',
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ConfirmResetDialog(),
                      );
                    },
                  ),
                  const PremiumSettingsItem(
                    icon: Icons.build_rounded,
                    iconColor: Color(0xFF0E68FF), // NemoPrimary
                    title: '修复本地数据',
                    subtitle: '清理重复数据 (同步计数异常时使用)',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            // 6. About
            const SettingsSectionTitle('关于'),
            PremiumCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const PremiumSettingsItem(
                    icon: Icons.info_rounded,
                    iconColor: Color(0xFF0E68FF), // NemoBlue
                    title: '版本信息',
                    subtitle: '当前版本：2.0.0-beta',
                  ),
                  const PremiumSettingsItem(
                    icon: Icons.system_update_rounded,
                    iconColor: Color(0xFF34C759), // NemoGreen
                    title: '检查更新',
                    subtitle: '获取最新版本',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
    );
  }
}

class ImmersiveSettingsHeader extends StatelessWidget {
  const ImmersiveSettingsHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

class _UserProfileRow extends StatelessWidget {
  const _UserProfileRow({
    required this.username,
    this.email,
    this.onClick,
  });

  final String username;
  final String? email;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar Placeholder (Squircle 12dp)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (email != null)
                    Text(
                      email!,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 74),
      child: Divider(
        height: 0.5,
        thickness: 0.5,
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.selectedOption,
    required this.onSelected,
  });

  final int selectedOption;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(0, '浅色'),
          _buildOption(1, '深色'),
          _buildOption(2, '系统'),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String label) {
    final active = selectedOption == index;
    return GestureDetector(
      onTap: () => onSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? Colors.black87 : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _TrailingValue extends StatelessWidget {
  const _TrailingValue(this.value);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
