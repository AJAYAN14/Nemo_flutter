import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';

class NemoCompletionView extends StatelessWidget {
  const NemoCompletionView({
    super.key,
    this.title = '今日目标达成！',
    this.subtitle = '坚持就是胜利，明天继续加油',
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = NemoColors.blue600;
    
    return Container(
      width: double.infinity,
      color: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
      child: Column(
        children: [
          // Header with close button
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: isDark ? NemoColors.darkTextPrimary : NemoColors.gray900),
              onPressed: onClose,
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero Icon with Glow Effect
                  _GlowIcon(primaryColor: primaryColor),
                  
                  const SizedBox(height: 32),
                  
                  // Title & Subtitle
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? NemoColors.darkTextPrimary : NemoColors.gray900,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: NemoColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Quote Card
                  _QuoteCard(isDark: isDark),
                  
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowIcon extends StatelessWidget {
  const _GlowIcon({required this.primaryColor});
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 48,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : NemoColors.gray100,
          width: 1,
        ),
      ),
      child: const Column(
        children: [
          Text(
            '“温故而知新，可以为师矣。”',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: NemoColors.gray500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
