import 'package:core_domain/core_domain.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../test/test_notifier.dart';
import 'question_explanation_card.dart';

class MultipleChoiceTestContent extends HookConsumerWidget {
  const MultipleChoiceTestContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testProvider);
    final question = state.currentQuestion;

    if (question == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: NemoFuriganaText(
              text: question.questionText,
              baseTextStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              baseTextColor: Theme.of(context).colorScheme.onBackground,
              furiganaTextSize: 12,
            ),
          ),

          // Already Answered Warning
          if (question.isAnswered)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  "已回答，无法修改",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Option List
          Column(
            children: List.generate(question.options.length, (index) {
              final option = question.options[index];
              final status = _calculateOptionStatus(question, index, state.selectedOptionIndex);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TestOption(
                  index: index,
                  text: option,
                  status: status,
                  onTap: () => ref.read(testProvider.notifier).selectOption(index),
                ),
              );
            }),
          ),

          // Explanation Card
          if (question.isAnswered && (question.explanation != null))
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: QuestionExplanationCard(
                payload: ExplanationPayload.text(text: question.explanation!),
              ),
            ),
        ],
      ),
    );
  }

  OptionStatus _calculateOptionStatus(TestQuestion question, int index, int selectedOptionIndex) {
    if (question.isAnswered) {
      final isCorrectAnswer = (question.options[index] == question.correctAnswer);
      final wasUserChoice = question.userAnswerIndex == index;

      if (isCorrectAnswer) return OptionStatus.correct;
      if (wasUserChoice && !question.isCorrect) return OptionStatus.incorrect;
      return OptionStatus.none;
    } else {
      return selectedOptionIndex == index ? OptionStatus.selected : OptionStatus.none;
    }
  }
}

enum OptionStatus { none, selected, correct, incorrect }

class TestOption extends StatefulWidget {
  final int index;
  final String text;
  final OptionStatus status;
  final VoidCallback onTap;

  const TestOption({
    super.key,
    required this.index,
    required this.text,
    required this.status,
    required this.onTap,
  });

  @override
  State<TestOption> createState() => _TestOptionState();
}

class _TestOptionState extends State<TestOption> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Best Practice: Define layout constants locally
  static const double _circleSize = 28.0;
  static const double _furiganaFontSize = 10.0;
  static const double _furiganaPadding = 4.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    // 1. Calculate logic-based alignment offset
    // NemoFuriganaText adds (furiganaFontSize + furiganaPadding) empty space at the top.
    // To center the circle with the main text, we need to shift the text component
    // UP by half of that empty space.
    const double furiganaSpace = _furiganaFontSize + _furiganaPadding;
    const double alignmentOffset = -(furiganaSpace / 2);

    final optionLabel = widget.index < 26 
        ? String.fromCharCode('A'.codeUnitAt(0) + widget.index) 
        : (widget.index + 1).toString();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 2. Derive colors based on state
    final stateColors = _getColorsForStatus(widget.status, colorScheme);

    final enabled = widget.status == OptionStatus.none || widget.status == OptionStatus.selected;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: enabled ? (_) => _controller.forward() : null,
        onTapUp: enabled ? (_) => _controller.reverse() : null,
        onTapCancel: enabled ? () => _controller.reverse() : null,
        onTap: enabled ? widget.onTap : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 60),
            decoration: BoxDecoration(
              color: stateColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: stateColors.borderColor, width: 1.5),
              boxShadow: widget.status == OptionStatus.selected 
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.1), 
                        blurRadius: 8, 
                        offset: const Offset(0, 4),
                      )
                    ] 
                  : null,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding, 
              vertical: _verticalPadding,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Label Circle
                  _buildLabelCircle(optionLabel, stateColors, colorScheme, theme),
                  
                  const SizedBox(width: 14),

                  // Text Content
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, alignmentOffset), 
                      child: NemoFuriganaText(
                        text: widget.text,
                        baseTextStyle: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: widget.status != OptionStatus.none ? FontWeight.w600 : FontWeight.w500,
                          height: 1.0,
                        ),
                        baseTextColor: stateColors.contentColor,
                        furiganaTextSize: _furiganaFontSize,
                      ),
                    ),
                  ),

                  // Status Indicator
                  if (widget.status == OptionStatus.correct || widget.status == OptionStatus.incorrect)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        widget.status == OptionStatus.correct ? Icons.check_circle : Icons.cancel,
                        color: stateColors.contentColor,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelCircle(String label, _StateColors colors, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      width: _circleSize,
      height: _circleSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.status == OptionStatus.none 
            ? colorScheme.surfaceVariant 
            : colors.contentColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.status == OptionStatus.none 
              ? colorScheme.onSurfaceVariant 
              : colorScheme.surface,
        ),
      ),
    );
  }

  _StateColors _getColorsForStatus(OptionStatus status, ColorScheme colorScheme) {
    switch (status) {
      case OptionStatus.selected:
        return _StateColors(
          backgroundColor: colorScheme.primary.withOpacity(0.08),
          borderColor: colorScheme.primary,
          contentColor: colorScheme.primary,
        );
      case OptionStatus.correct:
        return _StateColors(
          backgroundColor: colorScheme.secondary.withOpacity(0.08),
          borderColor: colorScheme.secondary,
          contentColor: colorScheme.secondary,
        );
      case OptionStatus.incorrect:
        return _StateColors(
          backgroundColor: colorScheme.error.withOpacity(0.08),
          borderColor: colorScheme.error,
          contentColor: colorScheme.error,
        );
      default:
        return _StateColors(
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.outlineVariant.withOpacity(0.4),
          contentColor: colorScheme.onSurface,
        );
    }
  }
}

class _StateColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color contentColor;

  const _StateColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.contentColor,
  });
}
