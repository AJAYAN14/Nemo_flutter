import 'package:flutter/material.dart';

class SimpleProgressIndicator extends StatelessWidget {
  final int current;
  final int total;

  const SimpleProgressIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress Labels
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                "进度",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                "$current / $total",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Progress Bar with Animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                minHeight: 8, // Set explicit minHeight for 1:1 restoration
              ),
            );
          },
        ),
      ],
    );
  }
}
