import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 1:1 Parity with Kotlin LearnHeader composable.
///
/// Uses PopupMenuButton (anchored dropdown) matching Kotlin's NemoDropdownMenu,
/// NOT a BottomSheet. The menu contains: Undo, Rating Guide, Suspend, Bury,
/// Auto-Read toggle, Show-Answer-Wait toggle, and Wait Duration cycle.
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
    this.onShowRatingGuide,
    this.onCycleAnswerWaitDuration,
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
  final VoidCallback? onShowRatingGuide;
  final VoidCallback? onCycleAnswerWaitDuration;

  @override
  Size get preferredSize => const Size.fromHeight(88); // 56 (Content) + 32 (Progress area)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // MD3: TopAppBar content color — matches Kotlin's MaterialTheme.colorScheme.onSurface
    final contentColor = isDark ? Colors.white : Colors.black87;
    
    // MD3: Navigation group background — matches Kotlin's navGroupBg logic
    final navGroupBg = isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white;

    final progressBackground = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (56dp height content area) — matches Kotlin Row height=56.dp
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                   // Left: Back button (48x48) + Title — matches Kotlin IconButton size(48.dp)
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
                    ),
                  ),
                  
                  const Spacer(),
  
                  // Right: Navigation Group + Menu — matches Kotlin Row spacedBy(8.dp)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (remainingCount > 0)
                        Container(
                          decoration: BoxDecoration(
                            color: navGroupBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Prev Button (40x40) — matches Kotlin IconButton size(40.dp)
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  onPressed: canGoPrev ? () {
                                    // 1:1 Haptic: matches Kotlin performHapticFeedback()
                                    HapticFeedback.selectionClick();
                                    onPrev?.call();
                                  } : null,
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Next Button (40x40)
                               SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  onPressed: canGoNext ? () {
                                    HapticFeedback.selectionClick();
                                    onNext?.call();
                                  } : null,
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
  
                      // More Menu — 1:1 Parity: PopupMenuButton matching Kotlin NemoDropdownMenu
                      if (showMoreMenu)
                        _buildDropdownMenu(context, contentColor, navGroupBg, isDark),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
  
          // Progress Bar Area — matches Kotlin Box height(4.dp) with RoundedCornerShape
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

  /// Build PopupMenuButton matching Kotlin's NemoDropdownMenu (anchored dropdown).
  /// This replaces the previous LearnActionSheet (BottomSheet) approach.
  Widget _buildDropdownMenu(BuildContext context, Color contentColor, Color navGroupBg, bool isDark) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: contentColor, size: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF2A2A2E) : Colors.white,
      elevation: 8,
      offset: const Offset(0, 48),
      onSelected: (value) {
        switch (value) {
          case 'undo':
            onUndo?.call();
          case 'rating_guide':
            onShowRatingGuide?.call();
          case 'suspend':
            onSuspend?.call();
          case 'bury':
            onBury?.call();
          case 'cycle_duration':
            onCycleAnswerWaitDuration?.call();
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];

        // 1. Undo (conditional) — matches Kotlin: canUndo check
        if (onUndo != null) {
          items.add(PopupMenuItem<String>(
            value: 'undo',
            child: _MenuRow(
              icon: Icons.undo_rounded,
              text: '撤销上一次评分',
            ),
          ));
          items.add(const PopupMenuDivider());
        }

        // 2. Rating Guide — matches Kotlin: 评分说明（新学/复习）
        if (onShowRatingGuide != null) {
          items.add(PopupMenuItem<String>(
            value: 'rating_guide',
            child: _MenuRow(
              icon: Icons.check_circle_rounded,
              text: '评分说明（新学/复习）',
            ),
          ));
          items.add(const PopupMenuDivider());
        }

        // 3. Suspend — matches Kotlin: 暂停此卡片 (Suspend)
        items.add(PopupMenuItem<String>(
          value: 'suspend',
          child: _MenuRow(
            icon: Icons.pause_rounded,
            text: '暂停此卡片 (Suspend)',
          ),
        ));

        // 4. Bury — matches Kotlin: 今日暂缓此项 (Bury)
        items.add(PopupMenuItem<String>(
          value: 'bury',
          child: _MenuRow(
            icon: Icons.access_time_rounded,
            text: '今日暂缓此项 (Bury)',
          ),
        ));

        items.add(const PopupMenuDivider());

        // 5. Auto-read Switch — matches Kotlin DropdownMenuItem with Switch
        if (onToggleAutoRead != null) {
          items.add(_SwitchMenuItem(
            icon: Icons.volume_up_rounded,
            text: '翻面自动朗读',
            value: autoReadEnabled,
            onChanged: (v) {
              Navigator.pop(context);
              onToggleAutoRead?.call(v);
            },
          ));
        }

        // 6. Show-answer-wait Switch
        if (onToggleShowAnswerWait != null) {
          items.add(_SwitchMenuItem(
            icon: Icons.timer_rounded,
            text: '显示答案等待',
            value: showAnswerWaitEnabled,
            onChanged: (v) {
              Navigator.pop(context);
              onToggleShowAnswerWait?.call(v);
            },
          ));

          // 7. Wait Duration (conditional) — matches Kotlin: 等待时长: $label
          if (showAnswerWaitEnabled && onCycleAnswerWaitDuration != null) {
            items.add(PopupMenuItem<String>(
              value: 'cycle_duration',
              child: _MenuRow(
                icon: Icons.hourglass_bottom_rounded,
                text: '等待时长: ${answerWaitDuration.toStringAsFixed(1)}s',
              ),
            ));
          }
        }

        return items;
      },
      // Style the button container to match Kotlin's CircleShape background
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(navGroupBg),
        shape: const WidgetStatePropertyAll(CircleBorder()),
        fixedSize: const WidgetStatePropertyAll(Size(48, 48)),
      ),
    );
  }
}

/// Simple icon + text row for popup menu items.
class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MenuRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

/// Popup menu item with inline Switch — matches Kotlin DropdownMenuItem + Switch pattern.
class _SwitchMenuItem extends PopupMenuEntry<String> {
  final IconData icon;
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchMenuItem({
    required this.icon,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  double get height => 48;

  @override
  bool represents(String? value) => false;

  @override
  State<_SwitchMenuItem> createState() => _SwitchMenuItemState();
}

class _SwitchMenuItemState extends State<_SwitchMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChanged(!widget.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(widget.icon, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(widget.text, style: Theme.of(context).textTheme.bodyLarge),
            ),
            SizedBox(
              width: 36,
              height: 20,
              child: Switch(
                value: widget.value,
                onChanged: widget.onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
