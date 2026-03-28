import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomQuestionCountDialog extends HookWidget {
  final bool show;
  final int initialValue;
  final VoidCallback onDismiss;
  final ValueChanged<int> onConfirm;

  const CustomQuestionCountDialog({
    super.key,
    required this.show,
    required this.initialValue,
    required this.onDismiss,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final currentValue = useState(initialValue);
    final presets = [10, 15, 20, 25, 30, 50];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _DialogContainer(
        title: "自定义题数",
        subtitle: "设置本次测试的题目数量",
        currentValue: currentValue.value,
        minValue: 1,
        maxValue: 1000,
        unit: "题",
        presets: presets,
        onValueChange: (val) => currentValue.value = val,
        onDismiss: onDismiss,
        onConfirm: () {
          onConfirm(currentValue.value);
          onDismiss();
        },
      ),
    );
  }
}

class CustomTimeLimitDialog extends HookWidget {
  final bool show;
  final int initialValue;
  final VoidCallback onDismiss;
  final ValueChanged<int> onConfirm;

  const CustomTimeLimitDialog({
    super.key,
    required this.show,
    required this.initialValue,
    required this.onDismiss,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final currentValue = useState(initialValue);
    final presets = [5, 10, 20, 30, 45, 60];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _DialogContainer(
        title: "自定义时长",
        subtitle: "设置测试时间限制 (分钟)",
        currentValue: currentValue.value,
        minValue: 0,
        maxValue: 180,
        unit: currentValue.value == 0 ? "不限时间" : "分钟",
        presets: presets,
        onValueChange: (val) => currentValue.value = val,
        onDismiss: onDismiss,
        onConfirm: () {
          onConfirm(currentValue.value);
          onDismiss();
        },
      ),
    );
  }
}

class _DialogContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final String unit;
  final List<int> presets;
  final ValueChanged<int> onValueChange;
  final VoidCallback onDismiss;
  final VoidCallback onConfirm;

  const _DialogContainer({
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.presets,
    required this.onValueChange,
    required this.onDismiss,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _IconButton(
                icon: Icons.remove,
                enabled: currentValue > minValue,
                onPressed: () => onValueChange(currentValue - 1),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 80, // Prevent jitter
                child: Text(
                  "$currentValue",
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 24),
              _IconButton(
                icon: Icons.add,
                enabled: currentValue < maxValue,
                onPressed: () => onValueChange(currentValue + 1),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: presets.map((preset) {
              final isSelected = currentValue == preset;
              return ChoiceChip(
                label: Text(preset.toString()),
                selected: isSelected,
                onSelected: (_) => onValueChange(preset),
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onDismiss,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text("取消", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 2,
                  ),
                  child: const Text("确定", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _IconButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: enabled ? theme.colorScheme.secondaryContainer : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: enabled ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
