import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class RichStatItem extends StatelessWidget {
  const RichStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.subLabel,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String subLabel;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerColor = isDark ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white;
    final borderColor = isDark ? theme.colorScheme.outline.withValues(alpha: 0.1) : theme.colorScheme.outlineVariant.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.04),
            blurRadius: isDark ? 2 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark ? theme.colorScheme.onSurfaceVariant : NemoColors.textSub,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7) : NemoColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
