import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';

/// Nemo 自定义 Snackbar 类型
enum NemoSnackbarType {
  /// 默认信息提示 (蓝色)
  info,
  /// 成功提示 (绿色)
  success,
  /// 警告提示 (橙色)
  warning,
  /// 错误提示 (红色)
  error
}

/// Nemo 自定义顶部 Snackbar (1:1 还原 Kotlin 版)
///
/// 用于提供统一的项目 UI 风格，支持顶部弹出及其特有的渐变色背景。
class NemoSnackbar extends StatefulWidget {
  const NemoSnackbar({
    super.key,
    required this.visible,
    required this.message,
    this.actionText,
    this.icon,
    this.type = NemoSnackbarType.info,
    this.cornerRadius = 16,
    this.autoDismissMs = 5000,
    this.onDismiss,
    this.onClick,
  });

  /// 是否显示
  final bool visible;

  /// 消息内容
  final String message;

  /// 操作按钮文本 (可选)
  final String? actionText;

  /// 图标 (可选)
  final IconData? icon;

  /// Snackbar 类型，决定颜色
  final NemoSnackbarType type;

  /// 圆角半径
  final double cornerRadius;

  /// 自动消失时间 (毫秒)，null 表示不自动消失，默认 5000ms
  final int? autoDismissMs;

  /// 自动消失时的回调，用于更新外部状态
  final VoidCallback? onDismiss;

  /// 点击回调 (整个 Snackbar 可点击)
  final VoidCallback? onClick;

  @override
  State<NemoSnackbar> createState() => _NemoSnackbarState();
}

class _NemoSnackbarState extends State<NemoSnackbar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(NemoSnackbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _startTimer();
    } else if (!widget.visible && oldWidget.visible) {
      _cancelTimer();
    }
  }

  void _startTimer() {
    _cancelTimer();
    if (widget.autoDismissMs != null && widget.onDismiss != null) {
      _timer = Timer(Duration(milliseconds: widget.autoDismissMs!), () {
        if (mounted) widget.onDismiss!();
      });
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  List<Color> _getGradientColors(bool isDark) {
    switch (widget.type) {
      case NemoSnackbarType.info:
        return isDark
            ? [const Color(0xFF3D3A50), const Color(0xFF2B2930)]
            : [NemoColors.brandBlue.withValues(alpha: 0.95), const Color(0xFF4A90D9)];
      case NemoSnackbarType.success:
        return isDark
            ? [const Color(0xFF2D4A3D), const Color(0xFF1E3A2F)]
            : [const Color(0xFF34C759), const Color(0xFF28A745)];
      case NemoSnackbarType.warning:
        return isDark
            ? [const Color(0xFF4A3D2D), const Color(0xFF3A2F1E)]
            : [const Color(0xFFFF9500), const Color(0xFFE68A00)];
      case NemoSnackbarType.error:
        return isDark
            ? [const Color(0xFF4A2D2D), const Color(0xFF3A1E1E)]
            : [const Color(0xFFFF3B30), const Color(0xFFE53935)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = _getGradientColors(isDark);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      // 入场从顶部向下滑动
      offset: widget.visible ? Offset.zero : const Offset(0, -1.5),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.visible ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(widget.cornerRadius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onClick,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.actionText != null) ...[
                      const SizedBox(width: 12),
                      Text(
                        widget.actionText!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
