import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_prefs/core_prefs.dart';

class LearnActionSheet extends ConsumerWidget {
  const LearnActionSheet({
    super.key,
    this.onUndo,
    this.onSuspend,
    this.onBury,
    this.onShowRatingGuide,
  });

  final VoidCallback? onUndo;
  final VoidCallback? onSuspend;
  final VoidCallback? onBury;
  final VoidCallback? onShowRatingGuide;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onUndo,
    VoidCallback? onSuspend,
    VoidCallback? onBury,
    VoidCallback? onShowRatingGuide,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LearnActionSheet(
        onUndo: onUndo,
        onSuspend: onSuspend,
        onBury: onBury,
        onShowRatingGuide: onShowRatingGuide,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reactive consumption of preferences
    final autoReadEnabled = ref.watch(autoSpeakProvider);
    final showAnswerWaitEnabled = ref.watch(showAnswerWaitProvider);
    final answerWaitDuration = ref.watch(answerWaitDurationProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final backgroundColor = isDark ? NemoColors.bgBaseDark : NemoColors.bgBase;
    final surfaceColor = isDark ? NemoColors.surfaceCardDark : NemoColors.surfaceCard;
    final textMain = isDark ? NemoColors.darkTextPrimary : NemoColors.textMain;
    final textSub = isDark ? NemoColors.darkTextSecondary : NemoColors.textSub;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '学习功能',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: textMain,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Section: General Actions
          _SectionTitle('常用操作', color: textSub),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionSquare(
                  icon: Icons.undo_rounded,
                  label: '撤销评分',
                  onTap: onUndo != null ? () {
                    onUndo?.call();
                    Navigator.pop(context);
                  } : null,
                  color: surfaceColor,
                  textColor: textMain,
                  enabled: onUndo != null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionSquare(
                  icon: Icons.pause_circle_outline_rounded,
                  label: '暂停卡片',
                  onTap: () {
                    onSuspend?.call();
                    Navigator.pop(context);
                  },
                  color: surfaceColor,
                  textColor: textMain,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionSquare(
                  icon: Icons.access_time_rounded,
                  label: '今日暂缓',
                  onTap: () {
                    onBury?.call();
                    Navigator.pop(context);
                  },
                  color: surfaceColor,
                  textColor: textMain,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Section: Preferences
          _SectionTitle('偏好设置', color: textSub),
          const SizedBox(height: 12),
          _SettingCard(
            color: surfaceColor,
            children: [
              _SwitchRow(
                icon: Icons.volume_up_rounded,
                title: '翻面自动朗读',
                value: autoReadEnabled,
                onChanged: (_) => ref.read(autoSpeakProvider.notifier).toggle(),
                isDark: isDark,
              ),
              _Divider(isDark: isDark),
              _SwitchRow(
                icon: Icons.timer_rounded,
                title: '显示答案等待',
                value: showAnswerWaitEnabled,
                onChanged: (_) => ref.read(showAnswerWaitProvider.notifier).toggle(),
                isDark: isDark,
              ),
              if (showAnswerWaitEnabled) ...[
                 _Divider(isDark: isDark),
                 _ClickRow(
                  icon: Icons.hourglass_bottom_rounded,
                  title: '等待时长',
                  trailing: Text(
                    '${answerWaitDuration.toStringAsFixed(1)}s',
                    style: const TextStyle(color: NemoColors.brandBlue, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => ref.read(answerWaitDurationProvider.notifier).cycle(),
                  isDark: isDark,
                ),
              ],
              _Divider(isDark: isDark),
              _ClickRow(
                icon: Icons.help_outline_rounded,
                title: '评分准则说明',
                onTap: () {
                  Navigator.pop(context);
                  onShowRatingGuide?.call();
                },
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionTitle(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ActionSquare extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;
  final bool enabled;

  const _ActionSquare({
    required this.icon,
    required this.label,
    this.onTap,
    required this.color,
    required this.textColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.4,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(icon, color: NemoColors.brandBlue, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  const _SettingCard({required this.children, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isDark;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: isDark ? Colors.white70 : Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: NemoColors.brandBlue,
          ),
        ],
      ),
    );
  }
}

class _ClickRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;

  const _ClickRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isDark ? Colors.white70 : Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.black12),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 58,
      endIndent: 20,
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
    );
  }
}
