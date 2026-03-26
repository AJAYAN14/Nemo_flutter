import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.count,
    required this.level,
  });

  final DateTime date;
  final int count;
  final int level; // 0-4
}

class LearningHeatmapCard extends StatelessWidget {
  const LearningHeatmapCard({
    super.key,
    required this.heatmapData,
  });

  final List<HeatmapDay> heatmapData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Fire Style Colors
    final levelColors = isDark
        ? [
            const Color(0xFF161B22), // L0
            const Color(0xFF3A1C1C), // L1
            const Color(0xFF682424), // L2
            const Color(0xFFB52A2A), // L3
            const Color(0xFFE63E3E), // L4
          ]
        : [
            const Color(0xFFEBEDF0), // L0
            const Color(0xFFFFD7D5), // L1
            const Color(0xFFFFA39E), // L2
            const Color(0xFFFF4D4F), // L3
            const Color(0xFFCF1322), // L4
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceVariant.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Scroll to recent days
            child: CustomPaint(
              size: Size(
                (heatmapData.length / 7).ceil() * 18.0,
                7 * 18.0,
              ),
              painter: _HeatmapPainter(
                data: heatmapData,
                levelColors: levelColors,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _HeatmapLegend(levelColors: levelColors),
        ],
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.data,
    required this.levelColors,
  });

  final List<HeatmapDay> data;
  final List<Color> levelColors;

  @override
  void paint(Canvas canvas, Size size) {
    const double blockSize = 14.0;
    const double spacing = 4.0;
    final Paint paint = Paint();

    for (int i = 0; i < data.length; i++) {
      final col = i ~/ 7;
      final row = i % 7;

      final x = col * (blockSize + spacing);
      final y = row * (blockSize + spacing);

      paint.color = levelColors[data[i].level.clamp(0, 4)];
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, blockSize, blockSize),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.levelColors != levelColors;
}

class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend({required this.levelColors});
  final List<Color> levelColors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          '少',
          style: TextStyle(fontSize: 10, color: NemoColors.textSub),
        ),
        const SizedBox(width: 4),
        ...levelColors.map((color) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )),
        const SizedBox(width: 4),
        const Text(
          '多',
          style: TextStyle(fontSize: 10, color: NemoColors.textSub),
        ),
      ],
    );
  }
}
