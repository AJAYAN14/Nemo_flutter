import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';

class AudioWaveIndicator extends StatelessWidget {
  const AudioWaveIndicator({
    super.key,
    required this.playingId,
  });

  final String? playingId;

  @override
  Widget build(BuildContext context) {
    if (playingId == null) return const Positioned(child: SizedBox.shrink());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SoundWaveAnimation(
                color: isDark ? Colors.white : NemoColors.brandBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                playingId == 'word' ? '正在播放发音...' : '正在播放例句...',
                style: TextStyle(
                  color: isDark ? Colors.white : NemoColors.brandBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
