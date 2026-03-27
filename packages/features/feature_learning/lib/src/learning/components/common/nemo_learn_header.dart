import 'package:flutter/material.dart';

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
  Size get preferredSize => const Size.fromHeight(88); // 56 (Content) + 32 (Progress area)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // MD3: TopAppBar content color
    final contentColor = isDark ? Colors.white : Colors.black87;
    
    // MD3: Navigation group background
    final navGroupBg = isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white;

    final progressBackground = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (56dp height content area)
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  // Left: Back button (48x48) + Title
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.arrow_back_rounded),
                      iconSize: 24,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: contentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22, // MD3 titleLarge
                    ),
                  ),
                  
                  const Spacer(),
  
                  // Right: Navigation Group + Menu Expansion
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (remainingCount > 0)
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: navGroupBg,
                            borderRadius: BorderRadius.circular(12), // Aligned with RoundedCornerShape(12.dp)
                            boxShadow: isDark ? null : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Prev Button (40x40)
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  onPressed: canGoPrev ? onPrev : null,
                                  icon: const Icon(Icons.keyboard_arrow_left_rounded),
                                  color: contentColor,
                                  disabledColor: contentColor.withValues(alpha: 0.38),
                                  iconSize: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '剩余 $remainingCount',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: contentColor.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500, // Medium
                                  ),
                                ),
                              ),
                              // Next Button (40x40)
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  onPressed: canGoNext ? onNext : null,
                                  icon: const Icon(Icons.keyboard_arrow_right_rounded),
                                  color: contentColor,
                                  disabledColor: contentColor.withValues(alpha: 0.38),
                                  iconSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
  
                      const SizedBox(width: 8),
  
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
                ],
              ),
            ),
          ),
  
          // Progress Bar Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: progressBackground,
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
