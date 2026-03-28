import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import 'test_result_components.dart';
import 'test_result_palette.dart';

class TestResultScreen extends StatefulWidget {
  const TestResultScreen({
    super.key,
    required this.result,
    required this.onRetakeTest,
    required this.onExit,
  });

  final TestResult result;
  final VoidCallback onRetakeTest;
  final VoidCallback onExit;

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  @override
  void initState() {
    super.initState();
    _triggerEffects();
  }

  void _triggerEffects() async {
    // Delay to match circular progress animation (1500ms)
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    HapticFeedback.mediumImpact();
    
    if (widget.result.score > 85) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      
      Confetti.launch(
        context,
        options: ConfettiOptions(
          particleCount: 100,
          spread: 70,
          y: 0.6,
          colors: [
            Color(0xFFFCE18A),
            Color(0xFFFF726D),
            Color(0xFFF4306D),
            Color(0xFFB48DEF),
            Color(0xFF10B981),
            Color(0xFF3B82F6),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accuracy = widget.result.score;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          NemoAuroraBackground(accuracy: accuracy),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.close_rounded, color: isDark ? Colors.white : Colors.black),
                    onPressed: widget.onExit,
                  ),
                  centerTitle: true,
                  title: Text(
                    '测试完成',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildHeaderRating(context, accuracy),
                        const SizedBox(height: 48),
                        CircularProgressBar(accuracy: accuracy),
                        const SizedBox(height: 48),
                        _buildStatGrid(context),
                        const SizedBox(height: 24),
                        if (widget.result.wordCount > 0 && widget.result.grammarCount > 0)
                          DistributionCard(
                            wordCount: widget.result.wordCount,
                            grammarCount: widget.result.grammarCount,
                          ),
                        const SizedBox(height: 120), // Bottom padding for buttons
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeaderRating(BuildContext context, int accuracy) {
    final theme = Theme.of(context);
    
    IconData ratingIcon;
    if (accuracy > 85) {
      ratingIcon = Icons.emoji_events_rounded;
    } else if (accuracy >= 70) {
      ratingIcon = Icons.star_rounded;
    } else if (accuracy >= 60) {
      ratingIcon = Icons.check_circle_rounded;
    } else {
      ratingIcon = Icons.menu_book_rounded;
    }

    String quote;
    if (accuracy == 100) {
      quote = "完美！你是学习大师！";
    } else if (accuracy >= 80) {
      quote = "太棒了！继续保持！";
    } else if (accuracy >= 60) {
      quote = "不错！离成功又近了一步！";
    } else {
      quote = "别灰心，温故而知新！";
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(ratingIcon, color: theme.colorScheme.onPrimaryContainer, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '测试完成！',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  quote,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
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

  Widget _buildStatGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duration = widget.result.duration;
    final timeFormatted = "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: '答对',
            value: '${widget.result.correctCount}',
            icon: Icons.check_rounded,
            backgroundColor: TestResultPalette.getCorrectCardBg(isDark),
            contentColor: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: '答错',
            value: '${widget.result.totalQuestions - widget.result.correctCount}',
            icon: Icons.close_rounded,
            backgroundColor: TestResultPalette.getWrongCardBg(isDark),
            contentColor: isDark ? const Color(0xFFF87171) : const Color(0xFF991B1B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: '用时',
            value: timeFormatted,
            icon: Icons.access_time_rounded,
            backgroundColor: TestResultPalette.getTimeCardBg(isDark),
            contentColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onExit,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: NemoColors.divider, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('返回菜单', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onRetakeTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NemoColors.brandBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('再来一次', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
