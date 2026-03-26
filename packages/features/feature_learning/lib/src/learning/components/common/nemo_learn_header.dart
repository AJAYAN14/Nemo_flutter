import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';

class NemoLearnHeader extends StatelessWidget implements PreferredSizeWidget {
  const NemoLearnHeader({
    super.key,
    required this.title,
    required this.remainingCount,
    required this.progress,
    required this.onClose,
    this.onPrev,
    this.onNext,
    this.canGoPrev = false,
    this.canGoNext = false,
    this.showMoreMenu = true,
  });

  final String title;
  final int remainingCount;
  final double progress;
  final VoidCallback onClose;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final bool canGoPrev;
  final bool canGoNext;
  final bool showMoreMenu;

  @override
  Size get preferredSize => const Size.fromHeight(88); // Content (56) + Progress (4) + Padding

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final navGroupBg = isDark ? NemoColors.navGroupBgDark : Colors.white;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                // Left: Back + Title
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.arrow_back_rounded),
                  iconSize: 24,
                  color: contentColor,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                
                const Spacer(),

                // Center/Right: Nav Group (Pill)
                if (remainingCount > 0)
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: navGroupBg,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: isDark ? null : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: canGoPrev ? onPrev : null,
                          icon: const Icon(Icons.keyboard_arrow_left_rounded),
                          color: contentColor,
                          disabledColor: contentColor.withValues(alpha: 0.2),
                          iconSize: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '剩余 $remainingCount',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: contentColor.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: canGoNext ? onNext : null,
                          icon: const Icon(Icons.keyboard_arrow_right_rounded),
                          color: contentColor,
                          disabledColor: contentColor.withValues(alpha: 0.2),
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(width: 8),

                // Far Right: More Menu
                if (showMoreMenu)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: navGroupBg,
                      shape: BoxShape.circle,
                      boxShadow: isDark ? null : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Show Menu
                      },
                      icon: const Icon(Icons.more_vert_rounded),
                      color: contentColor,
                      iconSize: 24,
                    ),
                  ),
                const SizedBox(width: 4),
              ],
            ),
          ),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
