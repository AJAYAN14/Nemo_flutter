import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class LevelSelectionSheet extends StatelessWidget {
  const LevelSelectionSheet({
    super.key,
    required this.selectedLevel,
    required this.primaryColor,
    required this.onLevelSelected,
  });

  final String selectedLevel;
  final Color primaryColor;
  final ValueChanged<String> onLevelSelected;

  static const _levelDetails = {
    'N5': '初级 - 基础词汇',
    'N4': '初级 - 进阶词汇',
    'N3': '中级 - 常用词汇',
    'N2': '中高级 - 商务词汇',
    'N1': '高级 - 学术词汇',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '选择学习等级',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? theme.colorScheme.onSurface : NemoColors.textMain,
            ),
          ),
          const SizedBox(height: 24),
          ..._levelDetails.entries.map((entry) {
            final level = entry.key;
            final description = entry.value;
            final isSelected = level == selectedLevel;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LevelSelectionCard(
                level: 'JLPT $level',
                description: description,
                isSelected: isSelected,
                primaryColor: primaryColor,
                onTap: () {
                  onLevelSelected(level);
                  Navigator.pop(context);
                },
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _LevelSelectionCard extends StatefulWidget {
  const _LevelSelectionCard({
    required this.level,
    required this.description,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  final String level;
  final String description;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  State<_LevelSelectionCard> createState() => _LevelSelectionCardState();
}

class _LevelSelectionCardState extends State<_LevelSelectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = widget.isSelected
        ? widget.primaryColor.withValues(alpha: 0.12)
        : (isDark ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : NemoColors.bgBase);


    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.level,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: widget.isSelected
                            ? widget.primaryColor
                            : (isDark ? Colors.white : NemoColors.textMain),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isSelected
                            ? widget.primaryColor.withValues(alpha: 0.8)
                            : (isDark ? Colors.white60 : NemoColors.textSub),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                widget.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: widget.isSelected ? widget.primaryColor : (isDark ? Colors.white24 : NemoColors.textMuted),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
