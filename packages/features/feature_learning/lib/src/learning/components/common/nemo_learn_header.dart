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
    this.onUndo,
    this.onSuspend,
    this.onBury,
    this.onToggleAutoRead,
    this.autoReadEnabled = true,
    this.onToggleShowAnswerWait,
    this.showAnswerWaitEnabled = false,
    this.answerWaitDuration = 1.0,
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
  final VoidCallback? onUndo;
  final VoidCallback? onSuspend;
  final VoidCallback? onBury;
  final ValueChanged<bool>? onToggleAutoRead;
  final bool autoReadEnabled;
  final ValueChanged<bool>? onToggleShowAnswerWait;
  final bool showAnswerWaitEnabled;
  final double answerWaitDuration;

  @override
  Size get preferredSize => const Size.fromHeight(88); // 56 (Content) + 32 (Progress area)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // MD3: TopAppBar content color
    final contentColor = isDark ? Colors.white : Colors.black87;
    
    // MD3: Navigation group background
    final navGroupBg = isDark ? Colors.white.withOpacity(0.15) : Colors.white;

    final progressBackground = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

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
                                color: Colors.black.withOpacity(0.05),
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
                                  disabledColor: contentColor.withOpacity(0.38),
                                  iconSize: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '剩余 $remainingCount',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: contentColor.withOpacity(0.6),
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
                                  disabledColor: contentColor.withOpacity(0.38),
                                  iconSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
  
                      const SizedBox(width: 8),
  
                      if (showMoreMenu)
                        Theme(
                          data: theme.copyWith(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: navGroupBg,
                              shape: BoxShape.circle,
                              boxShadow: isDark ? null : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: PopupMenuButton<int>(
                              icon: Icon(
                                Icons.more_vert_rounded,
                                color: contentColor,
                                size: 24,
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 1: onUndo?.call(); break;
                                  case 3: onSuspend?.call(); break;
                                  case 4: onBury?.call(); break;
                                }
                              },
                              offset: const Offset(0, 48),
                              color: isDark ? theme.colorScheme.surface : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (context) => [
                                _buildMenuItem(
                                  value: 1,
                                  icon: Icons.undo_rounded,
                                  text: '撤销上一次评分',
                                  theme: theme,
                                  enabled: onUndo != null,
                                ),
                                const PopupMenuDivider(),
                                _buildMenuItem(
                                  value: 2,
                                  icon: Icons.check_circle_outline_rounded,
                                  text: '评分说明（新学/复习）',
                                  theme: theme,
                                ),
                                const PopupMenuDivider(),
                                _buildMenuItem(
                                  value: 3,
                                  icon: Icons.pause_rounded,
                                  text: '暂停此卡片 (Suspend)',
                                  theme: theme,
                                ),
                                _buildMenuItem(
                                  value: 4,
                                  icon: Icons.access_time_rounded,
                                  text: '今日暂缓此项 (Bury)',
                                  theme: theme,
                                ),
                                const PopupMenuDivider(),
                                _buildSwitchMenuItem(
                                  value: 5,
                                  text: '翻面自动朗读',
                                  initialValue: autoReadEnabled,
                                  theme: theme,
                                  onChanged: (val) => onToggleAutoRead?.call(val),
                                ),
                                _buildSwitchMenuItem(
                                  value: 6,
                                  text: '显示答案等待',
                                  initialValue: showAnswerWaitEnabled,
                                  theme: theme,
                                  onChanged: (val) => onToggleShowAnswerWait?.call(val),
                                ),
                                _buildMenuItem(
                                  value: 7,
                                  icon: Icons.timer_rounded,
                                  text: '等待时长: ${answerWaitDuration.toStringAsFixed(1)}s',
                                  theme: theme,
                                ),
                              ],
                            ),
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

  PopupMenuItem<int> _buildMenuItem({
    required int value,
    required IconData icon,
    required String text,
    required ThemeData theme,
    bool enabled = true,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return PopupMenuItem<int>(
      value: value,
      enabled: enabled,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon, 
            size: 20, 
            color: const Color(0xFF0E68FF), // Nemo brand blue
          ),
          const SizedBox(width: 12),
          Text(
            text, 
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<int> _buildSwitchMenuItem({
    required int value,
    required String text,
    required bool initialValue,
    required ThemeData theme,
    required ValueChanged<bool> onChanged,
  }) {
    return PopupMenuItem<int>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text, 
            style: TextStyle(
              fontSize: 14,
              color: theme.brightness == Brightness.dark 
                  ? Colors.white.withOpacity(0.9) 
                  : Colors.black87,
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            height: 24,
            width: 40,
            child: Switch(
              value: initialValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF0E68FF), 
            ),
          ),
        ],
      ),
    );
  }
}
