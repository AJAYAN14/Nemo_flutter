import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class TestSettingsBottomSheet extends StatelessWidget {
  const TestSettingsBottomSheet({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SelectorHeader(title),
          content,
          const SizedBox(height: 24),
          _CancelButton(onPressed: () => Navigator.pop(context)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SelectorHeader extends StatelessWidget {
  const _SelectorHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900, // ExtraBold
              color: Theme.of(context).colorScheme.onSurface,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PremiumSelectorChip extends StatelessWidget {
  final String text;
  final bool selected;
  final bool isAvailable;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  const PremiumSelectorChip({
    super.key,
    required this.text,
    required this.selected,
    this.isAvailable = true,
    required this.onPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerColor = selected ? NemoColors.brandBlue : theme.colorScheme.onSurface.withValues(alpha: 0.08);
    final contentColor = selected ? Colors.white : theme.colorScheme.onSurface;

    return Material(
      color: containerColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isAvailable ? onPressed : null,
        onLongPress: isAvailable ? onLongPress : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: contentColor,
                ),
          ),
        ),
      ),
    );
  }
}

class PremiumLevelChip extends StatelessWidget {
  final String level;
  final int count;
  final String unit;
  final bool selected;
  final bool isAvailable;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  const PremiumLevelChip({
    super.key,
    required this.level,
    required this.count,
    this.unit = "词",
    required this.selected,
    this.isAvailable = true,
    required this.onPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerColor = !isAvailable 
        ? theme.colorScheme.onSurface.withValues(alpha: 0.04)
        : selected ? NemoColors.brandBlue : theme.colorScheme.onSurface.withValues(alpha: 0.08);
    final contentColor = !isAvailable
        ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
        : selected ? Colors.white : theme.colorScheme.onSurface;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.6,
      child: Material(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isAvailable ? onPressed : null,
          onLongPress: isAvailable ? onLongPress : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 64,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        level,
                        style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: contentColor,
                            ),
                      ),
                      Text(
                        isAvailable ? "$count $unit" : "不可用",
                        style: theme.textTheme.bodySmall?.copyWith(
                              color: selected ? Colors.white.withValues(alpha: 0.8) : theme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
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

class PremiumCustomChip extends StatelessWidget {
  final VoidCallback onClick;
  const PremiumCustomChip({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        foregroundColor: NemoColors.brandBlue,
      ),
      child: const Text("自定义...", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "取消",
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
