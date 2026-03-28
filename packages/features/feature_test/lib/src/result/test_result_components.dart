import 'dart:math';
import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'test_result_palette.dart';

class NemoAuroraBackground extends StatelessWidget {
  const NemoAuroraBackground({super.key, required this.accuracy});
  final int accuracy;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = TestResultPalette.getAccuracyColor(accuracy);

    return CustomPaint(
      painter: AuroraPainter(primaryColor: primaryColor, isDark: isDark),
      size: Size.infinite,
    );
  }
}

class AuroraPainter extends CustomPainter {
  final Color primaryColor;
  final bool isDark;

  AuroraPainter({required this.primaryColor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Left Top Main Aurora (Correctness based color)
    final mainGradient = RadialGradient(
      colors: [
        primaryColor.withValues(alpha: isDark ? 0.25 : 0.35),
        primaryColor.withValues(alpha: 0),
      ],
    );
    paint.shader = mainGradient.createShader(Rect.fromLTWH(-size.width * 0.2, -size.height * 0.2, size.width * 0.8, size.height * 0.8));
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.1), size.width * 0.6, paint);

    // Right Bottom Auxiliary Aurora (Blue/Purple/Cyan)
    final auxGradient = RadialGradient(
      colors: [
        const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.15 : 0.2), // Purple
        const Color(0xFF3B82F6).withValues(alpha: 0), // Blue
      ],
    );
    paint.shader = auxGradient.createShader(Rect.fromLTWH(size.width * 0.4, size.height * 0.4, size.width * 0.8, size.height * 0.8));
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.8), size.width * 0.6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircularProgressBar extends StatelessWidget {
  const CircularProgressBar({
    super.key,
    required this.accuracy,
    this.size = 192,
  });

  final int accuracy;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = TestResultPalette.getAccuracyColor(accuracy);
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: accuracy / 100),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.fastOutSlowIn,
            builder: (context, value, _) {
              return CustomPaint(
                painter: _CircularProgressPainter(
                  progress: value,
                  color: color,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  strokeWidth: 16,
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: accuracy.toDouble()),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                  builder: (context, value, _) {
                    return Text(
                      '${value.toInt()}%',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: NemoColors.textMain,
                      ),
                    );
                  },
                ),
                Text(
                  '正确率',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: NemoColors.textSub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  const _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.contentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, color: contentColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: contentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: contentColor.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class DistributionCard extends StatelessWidget {
  const DistributionCard({
    super.key,
    required this.wordCount,
    required this.grammarCount,
  });

  final int wordCount;
  final int grammarCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = wordCount + grammarCount;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '测试内容分布',
            style: theme.textTheme.titleSmall?.copyWith(
              color: TestResultPalette.distributionTitle,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$wordCount',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: TestResultPalette.wordAccent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text('单词', style: TextStyle(fontSize: 12, color: NemoColors.textMuted)),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: theme.dividerColor,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$grammarCount',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: TestResultPalette.grammarAccent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text('语法', style: TextStyle(fontSize: 12, color: NemoColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
