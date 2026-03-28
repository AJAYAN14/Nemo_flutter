import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_designsystem/core_designsystem.dart';

enum CardState { default_, selected, correct, incorrect }

class FlippableCard extends StatefulWidget {
  const FlippableCard({
    super.key,
    required this.id,
    required this.text,
    required this.state,
    required this.onTap,
    this.isMatched = false,
  });

  final String id;
  final String text;
  final CardState state;
  final VoidCallback onTap;
  final bool isMatched;

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == CardState.selected && oldWidget.state != CardState.selected) {
      _controller.forward();
      _playHaptic();
    } else if (widget.state != CardState.selected && oldWidget.state == CardState.selected) {
      _controller.reverse();
    }

    if (widget.state == CardState.incorrect && oldWidget.state != CardState.incorrect) {
      _playErrorHaptic();
    }
    
    if (widget.state == CardState.correct && oldWidget.state != CardState.correct) {
      _playSuccessHaptic();
    }
  }

  void _playHaptic() => HapticFeedback.lightImpact();
  void _playErrorHaptic() => HapticFeedback.heavyImpact();
  void _playSuccessHaptic() => HapticFeedback.mediumImpact();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor = colorScheme.surface;
    Color borderColor = colorScheme.outlineVariant;
    Widget? icon;

    switch (widget.state) {
      case CardState.selected:
        backgroundColor = colorScheme.primaryContainer.withValues(alpha: 0.1);
        borderColor = colorScheme.primary;
        break;
      case CardState.correct:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        borderColor = Colors.green;
        icon = const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20);
        break;
      case CardState.incorrect:
        backgroundColor = colorScheme.errorContainer.withValues(alpha: 0.1);
        borderColor = colorScheme.error;
        icon = Icon(Icons.cancel_rounded, color: colorScheme.error, size: 20);
        break;
      default:
        break;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: widget.isMatched ? 0.0 : 1.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: widget.isMatched ? 0.8 : 1.0,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: widget.isMatched ? null : widget.onTap,
            child: Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: widget.state == CardState.selected
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.text,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.state == CardState.selected 
                            ? colorScheme.primary 
                            : colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (icon != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: icon,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardMatchingContentArea extends StatelessWidget {
  const CardMatchingContentArea({
    super.key,
    required this.termCards,
    required this.definitionCards,
    required this.selectedId,
    required this.matchedIds,
    required this.isError,
    required this.onCardTap,
  });

  final List<CardMatchPair> termCards;
  final List<CardMatchPair> definitionCards;
  final String? selectedId;
  final List<String> matchedIds;
  final bool isError;
  final Function(String) onCardTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: termCards.map((pair) {
                final id = 'term_${pair.id}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FlippableCard(
                    id: id,
                    text: pair.term,
                    state: _getState(id),
                    isMatched: matchedIds.contains(id),
                    onTap: () => onCardTap(id),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: definitionCards.map((pair) {
                final id = 'def_${pair.id}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FlippableCard(
                    id: id,
                    text: pair.definition,
                    state: _getState(id),
                    isMatched: matchedIds.contains(id),
                    onTap: () => onCardTap(id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  CardState _getState(String id) {
    if (matchedIds.contains(id)) return CardState.correct;
    if (selectedId == id) {
      return isError ? CardState.incorrect : CardState.selected;
    }
    return CardState.default_;
  }
}

class MatchingFeedbackPanel extends StatelessWidget {
  const MatchingFeedbackPanel({
    super.key,
    required this.isComplete,
    required this.errorCount,
    required this.onNext,
    required this.onFinish,
  });

  final bool isComplete;
  final int errorCount;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: isComplete ? colorScheme.primaryContainer : colorScheme.errorContainer.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                color: isComplete ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Text(
                isComplete ? "配对成功！" : "还可以再试一次哦 ($errorCount/3)",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isComplete ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onFinish,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isComplete ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                    side: BorderSide(
                      color: isComplete ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("完成测试"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: isComplete ? colorScheme.primary : colorScheme.error,
                    foregroundColor: isComplete ? colorScheme.onPrimary : colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("下一组"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardMatchingTestHeader extends StatelessWidget {
  const CardMatchingTestHeader({
    super.key,
    required this.onBack,
    required this.timeLabel,
    required this.isTimeLow,
  });

  final VoidCallback onBack;
  final String timeLabel;
  final bool isTimeLow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isTimeLow 
                  ? theme.colorScheme.errorContainer.withValues(alpha: 0.5) 
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: isTimeLow ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  timeLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isTimeLow ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
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
