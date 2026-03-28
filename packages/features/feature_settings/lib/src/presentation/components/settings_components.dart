import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class PremiumSettingsItem extends StatelessWidget {
  const PremiumSettingsItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onClick,
    this.showDivider = true,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onClick;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) 
                  trailing!
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 74),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
        ],
      ),
    );
  }
}

class DailyGoalSelectionBottomSheet extends StatelessWidget {
  const DailyGoalSelectionBottomSheet({
    super.key,
    required this.currentGoal,
    required this.onSelected,
  });

  final int currentGoal;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const goals = [5, 10, 20, 30, 50];
    const accentColor = Color(0xFFFF9500); // NemoOrange
    
    return _SelectionBottomSheetLayout(
      title: '每日单词目标',
      icon: Icons.flag_rounded,
      accentColor: accentColor,
      children: goals.map((goal) => _GoalSelectionItem(
        text: '$goal 个单词',
        isSelected: goal == currentGoal,
        color: accentColor,
        onTap: () {
          onSelected(goal);
          Navigator.pop(context);
        },
      )).toList(),
    );
  }
}

class GrammarDailyGoalSelectionBottomSheet extends StatelessWidget {
  const GrammarDailyGoalSelectionBottomSheet({
    super.key,
    required this.currentGoal,
    required this.onSelected,
  });

  final int currentGoal;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const goals = [5, 10, 15, 20, 25];
    const accentColor = Color(0xFF34C759); // NemoGreen
    
    return _SelectionBottomSheetLayout(
      title: '每日语法目标',
      icon: Icons.subject_rounded,
      accentColor: accentColor,
      children: goals.map((goal) => _GoalSelectionItem(
        text: '$goal 条语法',
        isSelected: goal == currentGoal,
        color: accentColor,
        onTap: () {
          onSelected(goal);
          Navigator.pop(context);
        },
      )).toList(),
    );
  }
}

class LearningDayResetHourBottomSheet extends StatelessWidget {
  const LearningDayResetHourBottomSheet({
    super.key,
    required this.currentHour,
    required this.onSelected,
  });

  final int currentHour;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const hours = [0, 2, 4, 5, 6];
    const accentColor = Color(0xFF5856D6); // NemoIndigo
    
    return _SelectionBottomSheetLayout(
      title: '学习日重置时间',
      subtitle: '每天此时间后开始新的学习日',
      icon: Icons.schedule_rounded,
      accentColor: accentColor,
      children: hours.map((hour) {
        String displayText = switch (hour) {
          0 => '凌晨 0:00 (午夜)',
          2 => '凌晨 2:00',
          4 => '凌晨 4:00 (推荐)',
          5 => '凌晨 5:00',
          6 => '凌晨 6:00',
          _ => '$hour:00',
        };
        return _GoalSelectionItem(
          text: displayText,
          isSelected: hour == currentHour,
          color: accentColor,
          onTap: () {
            onSelected(hour);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}

class _SelectionBottomSheetLayout extends StatelessWidget {
  const _SelectionBottomSheetLayout({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          
          // Selection Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _GoalSelectionItem extends StatelessWidget {
  const _GoalSelectionItem({
    required this.text,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = isSelected ? color.withValues(alpha: 0.12) : Colors.transparent;
    final textColor = isSelected ? color : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),
              if (isSelected)
                Icon(Icons.check_rounded, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class VoiceSelectionBottomSheet extends StatelessWidget {
  const VoiceSelectionBottomSheet({
    super.key,
    required this.currentVoiceName,
    required this.voices,
    required this.onVoiceSelected,
    required this.onPreviewVoice,
    this.isLoading = false,
    this.previewingVoiceName,
  });

  final String? currentVoiceName;
  final List<dynamic> voices; // List<TtsVoice> or mock
  final ValueChanged<String> onVoiceSelected;
  final ValueChanged<String> onPreviewVoice;
  final bool isLoading;
  final String? previewingVoiceName;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF2D55); // NemoRed
    final theme = Theme.of(context);

    // Mock grouping logic (simplified for Flutter)
    final localVoices = voices.where((v) => !v.toString().toLowerCase().contains('network')).toList();
    final cloudVoices = voices.where((v) => v.toString().toLowerCase().contains('network')).toList();

    return Container(
      padding: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.record_voice_over_rounded, color: accentColor, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  '选择语音',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
          
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: accentColor),
            )
          else if (voices.isEmpty)
             const Padding(
              padding: EdgeInsets.all(32),
              child: Text('未找到可用语音', style: TextStyle(color: Colors.grey)),
            )
          else
            SizedBox(
              height: 400, // Fixed height for demo/scroll
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (localVoices.isNotEmpty) ...[
                    const _VoiceGroupHeader(title: '本地语音'),
                    ...localVoices.map((v) => _VoiceItem(
                      name: v.toString(),
                      isSelected: v == currentVoiceName,
                      isPreviewing: v == previewingVoiceName,
                      color: accentColor,
                      onTap: () => onVoiceSelected(v.toString()),
                      onPreview: () => onPreviewVoice(v.toString()),
                    )),
                  ],
                  if (cloudVoices.isNotEmpty) ...[
                    const _VoiceGroupHeader(title: '云端语音'),
                    ...cloudVoices.map((v) => _VoiceItem(
                      name: v.toString(),
                      isSelected: v == currentVoiceName,
                      isPreviewing: v == previewingVoiceName,
                      color: accentColor,
                      onTap: () => onVoiceSelected(v.toString()),
                      onPreview: () => onPreviewVoice(v.toString()),
                    )),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _VoiceGroupHeader extends StatelessWidget {
  const _VoiceGroupHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _VoiceItem extends StatelessWidget {
  const _VoiceItem({
    required this.name,
    required this.isSelected,
    required this.isPreviewing,
    required this.color,
    required this.onTap,
    required this.onPreview,
  });

  final String name;
  final bool isSelected;
  final bool isPreviewing;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = isSelected ? color.withValues(alpha: 0.12) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color.withValues(alpha: 0.5) : Colors.transparent),
          ),
          child: Row(
            children: [
               Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person_rounded, color: isSelected ? color : Colors.grey, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (isSelected) const Text('当前选中', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onPreview,
                  icon: Icon(
                    isPreviewing ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                    color: color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumSliderSettingItem extends StatelessWidget {
  const PremiumSliderSettingItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.valueDisplay,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    required this.accentColor,
    this.labels = const [],
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final double value;
  final String valueDisplay;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color accentColor;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  valueDisplay,
                  style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: accentColor,
              inactiveTrackColor: Colors.grey.withValues(alpha: 0.2),
              thumbColor: accentColor,
              overlayColor: accentColor.withValues(alpha: 0.12),
              tickMarkShape: SliderTickMarkShape.noTickMark,
            ),
            child: Slider(
              value: value.clamp(min, max),
              onChanged: (val) {
                if (val != value) {
                  HapticFeedback.selectionClick();
                  onChanged(val);
                }
              },
              min: min,
              max: max,
              divisions: divisions,
            ),
          ),
          if (labels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: labels.map((l) => Text(l, style: const TextStyle(fontSize: 11, color: Colors.grey))).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class PremiumRadioSettingItem extends StatelessWidget {
  const PremiumRadioSettingItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onSelected,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onSelected(value);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? accentColor : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: accentColor,
              onChanged: (v) {
                if (v != null) {
                   HapticFeedback.lightImpact();
                   onSelected(v);
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
