import 'dart:math' as math;
import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'nemo_furigana_text.dart';

class NemoFlipCard extends StatefulWidget {
  const NemoFlipCard({
    super.key,
    required this.japanese,
    required this.hiragana,
    required this.meaning,
    required this.examples,
    required this.themeColor,
    required this.isFlipped,
    required this.onFlip,
    required this.onSpeak,
    this.categoryId,
  });

  final String japanese;
  final String hiragana;
  final String meaning;
  final List<Map<String, String>> examples;
  final Color themeColor;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onSpeak;
  final String? categoryId;

  @override
  State<NemoFlipCard> createState() => _NemoFlipCardState();
}

class _NemoFlipCardState extends State<NemoFlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  void _runSpringAnimation(bool forward) {
    final simulation = SpringSimulation(
      SpringDescription(
        mass: 1.0,
        stiffness: 200.0,
        damping: 17.0,
      ),
      _controller.value,
      forward ? 1.0 : 0.0,
      _controller.velocity,
    );
    _controller.animateWith(simulation);
  }

  @override
  void didUpdateWidget(NemoFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      _runSpringAnimation(widget.isFlipped);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final rotationDegrees = _controller.value * 180;
        final isFrontVisible = rotationDegrees < 90;
        final rotationValue = rotationDegrees * math.pi / 180;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(isFrontVisible ? rotationValue : rotationValue - math.pi),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: widget.themeColor.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.8),
                    Colors.white,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: isFrontVisible 
                              ? Colors.white.withValues(alpha: 0.5) 
                              : Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: isFrontVisible
                        ? _buildFront()
                        : _buildBack(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFront() {
    return GestureDetector(
      onTap: widget.onFlip,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NemoFuriganaText(
              text: widget.japanese,
              baseTextStyle: const TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
              baseTextColor: widget.themeColor,
              furiganaTextSize: 16,
              furiganaTextColor: NemoColors.textMuted.withValues(alpha: 0.7),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              widget.hiragana,
              style: const TextStyle(
                fontSize: 24,
                color: NemoColors.textSub,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 48),
            _SpeakButton(onPressed: widget.onSpeak, color: widget.themeColor),
            const SizedBox(height: 40),
            Text(
              "点 击 翻 转",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: NemoColors.textMuted.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return GestureDetector(
      onTap: widget.onFlip,
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          children: [
            if (widget.categoryId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.categoryId!.toUpperCase(),
                  style: TextStyle(
                    color: widget.themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            Text(
              widget.japanese,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.hiragana,
              style: const TextStyle(
                fontSize: 18,
                color: NemoColors.textSub,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: NemoColors.divider.withValues(alpha: 0.2)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '词 义',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: widget.themeColor.withValues(alpha: 0.6),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.meaning,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: NemoColors.textMain,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.examples.isNotEmpty) ...[
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '例 句',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: widget.themeColor.withValues(alpha: 0.6),
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...widget.examples.map((ex) => _ExampleRow(
                    japanese: ex['japanese'] ?? '',
                    chinese: ex['chinese'] ?? '',
                    color: widget.themeColor,
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpeakButton extends StatefulWidget {
  const _SpeakButton({required this.onPressed, required this.color});
  final VoidCallback onPressed;
  final Color color;

  @override
  State<_SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<_SpeakButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const ElasticOutCurve(0.7), 
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.volume_up_rounded,
            color: widget.color,
            size: 42,
          ),
        ),
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({
    required this.japanese,
    required this.chinese,
    required this.color,
  });

  final String japanese;
  final String chinese;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NemoFuriganaText(
                  text: japanese,
                  baseTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  furiganaTextSize: 10,
                  furiganaTextColor: NemoColors.textMuted.withValues(alpha: 0.6),
                ),
                if (chinese.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    chinese,
                    style: TextStyle(
                      fontSize: 14,
                      color: NemoColors.textSub.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.volume_up_rounded, size: 20, color: color.withValues(alpha: 0.6)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
