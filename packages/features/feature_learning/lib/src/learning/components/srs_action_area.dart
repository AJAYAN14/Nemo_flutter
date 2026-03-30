import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_audio/core_audio.dart';
import 'srs_rating_button.dart';
import '../../domain/srs_scheduler.dart';

class SRSActionArea extends StatelessWidget {
  const SRSActionArea({
    super.key,
    required this.showAnswer,
    required this.onShowAnswer,
    required this.onRate,
    this.ratingIntervals,
    this.showAnswerAvailableAt,
    this.isShowAnswerDelayEnabled = false,
  });

  final bool showAnswer;
  final VoidCallback onShowAnswer;
  final Function(int) onRate;
  final Map<SrsRating, String>? ratingIntervals;
  final int? showAnswerAvailableAt;
  final bool isShowAnswerDelayEnabled;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !showAnswer
            ? _ShowAnswerButton(
                onPressed: onShowAnswer,
                revealAt: showAnswerAvailableAt,
                delayEnabled: isShowAnswerDelayEnabled,
              )
            : Row(
                key: const ValueKey('rating_buttons'),
                children: [
                  // 重来
                  SRSRatingButton(
                    type: SRSRatingType.again,
                    label: '重来',
                    interval: ratingIntervals?[SrsRating.again] ?? '<1m',
                    onPressed: () {
                      SoundEffectService().playOtherSound();
                      onRate(0);
                    },
                  ),
                  const SizedBox(width: 8),
                  // 困难
                  SRSRatingButton(
                    type: SRSRatingType.hard,
                    label: '困难',
                    interval: ratingIntervals?[SrsRating.hard] ?? '1d',
                    onPressed: () {
                      SoundEffectService().playOtherSound();
                      onRate(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  // 良好
                  SRSRatingButton(
                    type: SRSRatingType.good,
                    label: '良好',
                    interval: ratingIntervals?[SrsRating.good] ?? '3d',
                    onPressed: () {
                      SoundEffectService().playGoodSound();
                      onRate(2);
                    },
                  ),
                  const SizedBox(width: 8),
                  // 简单
                  SRSRatingButton(
                    type: SRSRatingType.easy,
                    label: '简单',
                    interval: ratingIntervals?[SrsRating.easy] ?? '7d',
                    onPressed: () {
                      SoundEffectService().playGoodSound();
                      onRate(3);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _ShowAnswerButton extends StatefulWidget {
  const _ShowAnswerButton({
    required this.onPressed,
    this.revealAt,
    this.delayEnabled = false,
  });

  final VoidCallback onPressed;
  final int? revealAt;
  final bool delayEnabled;

  @override
  State<_ShowAnswerButton> createState() => _ShowAnswerButtonState();
}

class _ShowAnswerButtonState extends State<_ShowAnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _timer;
  int _remainingSec = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller;
    _startTimer();
  }

  @override
  void didUpdateWidget(_ShowAnswerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealAt != oldWidget.revealAt) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.delayEnabled && widget.revealAt != null) {
      _updateRemaining();
      _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        _updateRemaining();
      });
    } else {
      setState(() => _remainingSec = 0);
    }
  }

  void _updateRemaining() {
    if (widget.revealAt == null) return;
    final now = DateTimeUtils.getCurrentCompensatedMillis();
    final diff = widget.revealAt! - now;
    final sec = (diff / 1000).ceil();
    if (sec != _remainingSec) {
      if (mounted) setState(() => _remainingSec = sec.clamp(0, 99));
    }
    if (diff <= 0) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBlocked = _remainingSec > 0;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.reverse(),
        onTapUp: (_) {
          _controller.forward();
          if (isBlocked) {
            HapticFeedback.mediumImpact();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('请先回想一会儿 ($_remainingSec s)'),
                duration: const Duration(milliseconds: 1500),
                behavior: SnackBarBehavior.floating,
                width: 240,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else {
            widget.onPressed();
          }
        },
        onTapCancel: () => _controller.forward(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isBlocked
                ? (isDark ? Colors.grey.shade800 : Colors.grey.shade400)
                : const Color(0xFF111827),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBlocked ? Icons.access_time_rounded : Icons.auto_awesome,
                color: isBlocked ? Colors.white70 : const Color(0xFFFACC15),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                isBlocked ? '显示答案 (${_remainingSec}s)' : '显示答案',
                style: TextStyle(
                  color: isBlocked ? Colors.white70 : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
