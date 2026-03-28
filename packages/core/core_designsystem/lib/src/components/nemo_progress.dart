import 'dart:math' as math;
import 'package:flutter/material.dart';

class NemoCircularProgress extends StatelessWidget {
  const NemoCircularProgress({
    super.key,
    required this.progress,
    this.strokeWidth = 12.0,
    this.size = 100.0,
    this.progressColor,
    this.trackColor,
    this.duration = const Duration(milliseconds: 800),
  });

  final double progress;
  final double strokeWidth;
  final double size;
  final Color? progressColor;
  final Color? trackColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveProgressColor = progressColor ?? theme.colorScheme.primary;
    final effectiveTrackColor = trackColor ?? theme.dividerColor.withValues(alpha: 0.1);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: _NemoCircularProgressPainter(
            progress: value,
            strokeWidth: strokeWidth,
            progressColor: effectiveProgressColor,
            trackColor: effectiveTrackColor,
          ),
        );
      },
    );
  }
}

class _NemoCircularProgressPainter extends CustomPainter {
  _NemoCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.trackColor,
  });

  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const startAngle = -math.pi / 2;
    final progressSweepAngle = 2 * math.pi * progress;

    // 计算缺口（Gap）弧度：设缺口长度为线宽的 1.5 倍
    final gapAngle = (1.5 * strokeWidth) / radius;

    // 1. 绘制进度条 (Progress)
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        progressSweepAngle,
        false,
        progressPaint,
      );
    }

    // 2. 绘制底轨 (Track) - 带动态避让逻辑
    // 底轨弧度 = 全圆 - 进度弧度 - 两个缺口弧度
    final trackSweepAngle = 2 * math.pi - progressSweepAngle - (progress > 0 ? 2 * gapAngle : 0);

    if (trackSweepAngle > 0) {
      final trackPaint = Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = progress > 0 ? StrokeCap.round : StrokeCap.butt;

      // 如果进度为 0，绘制完整圆（此时无缺口）
      if (progress <= 0) {
        canvas.drawCircle(center, radius, trackPaint);
      } else {
        // 如果有进度，从进度结束后的 Gap 位置开始绘制底轨
        final trackStartAngle = startAngle + progressSweepAngle + gapAngle;
        canvas.drawArc(
          rect,
          trackStartAngle,
          trackSweepAngle,
          false,
          trackPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NemoCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
