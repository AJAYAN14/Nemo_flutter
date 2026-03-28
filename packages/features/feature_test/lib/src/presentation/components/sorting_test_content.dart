import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import '../../test/test_notifier.dart';
import 'question_explanation_card.dart';

class SortingTestContent extends ConsumerWidget {
  const SortingTestContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testProvider);
    final question = state.currentQuestion;

    if (question == null || question.type != QuestionType.sorting) {
      return const Center(child: Text('无效题目类型'));
    }

    final theme = Theme.of(context);
    final isGrammar = question.grammarId != null || (question.wordId == null && !question.questionText.contains('假名'));

    return Column(
      children: [
        const SizedBox(height: 16),
        // Chinese/Meaning Text
        Text(
          question.chinese ?? question.questionText,
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        // Tip Text
        Text(
          isGrammar ? '选择字符，按正确顺序排列' : '选择假名，按正确顺序排列',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),

        // Answer Container
        _AnswerContainer(
          userAnswer: state.userSortableAnswer,
          isAnswered: question.isAnswered,
          isCorrect: question.isCorrect,
        ),
        const SizedBox(height: 32),

        // Feedback
        if (question.isAnswered) ...[
          _SortingFeedback(question: question),
          if (!isGrammar) ...[
            const SizedBox(height: 16),
            QuestionExplanationCard(
              payload: ExplanationPayload.wordSummary(
                japanese: question.japanese ?? '',
                hiragana: question.hiragana ?? '',
                meaning: question.chinese ?? '',
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],

        // Options Container
        _OptionsContainer(
          options: question.sortingOptions,
        ),
      ],
    );
  }
}

class _AnswerContainer extends ConsumerWidget {
  final List<SortableChar> userAnswer;
  final bool isAnswered;
  final bool isCorrect;

  const _AnswerContainer({
    required this.userAnswer,
    required this.isAnswered,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Color borderColor;
    if (!isAnswered && userAnswer.isNotEmpty) {
      borderColor = theme.colorScheme.primary;
    } else if (isAnswered && isCorrect) {
      borderColor = theme.colorScheme.secondary;
    } else if (isAnswered && !isCorrect) {
      borderColor = theme.colorScheme.error;
    } else {
      borderColor = theme.colorScheme.outlineVariant;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: userAnswer.isNotEmpty ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: userAnswer.isEmpty
          ? Center(
              child: Text(
                '在此处构建答案',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 12,
              children: userAnswer
                  .map((char) => _SortableChip(
                        char: char,
                        isSelected: true,
                        onTap: () => ref.read(testProvider.notifier).deselectSortableChar(char),
                      ))
                  .toList(),
            ),
    );
  }
}

class _OptionsContainer extends ConsumerWidget {
  final List<SortableChar> options;

  const _OptionsContainer({required this.options});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: options.map((char) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: char.isSelected
              ? const SizedBox.shrink()
              : _SortableChip(
                  key: ValueKey(char.id),
                  char: char,
                  isSelected: false,
                  onTap: () => ref.read(testProvider.notifier).selectSortableChar(char),
                ),
        );
      }).toList(),
    );
  }
}

class _SortableChip extends StatelessWidget {
  final SortableChar char;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortableChip({
    super.key,
    required this.char,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface;
    final textColor = isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface;
    final borderColor = isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant;

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Feedback.forTap(context);
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            char.char,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SortingFeedback extends StatelessWidget {
  final TestQuestion question;

  const _SortingFeedback({required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final containerColor = question.isCorrect
        ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.1)
        : theme.colorScheme.errorContainer.withValues(alpha: 0.1);
    
    final borderColor = question.isCorrect ? theme.colorScheme.secondary : theme.colorScheme.error;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      color: containerColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              question.isCorrect ? Icons.check_circle : Icons.cancel,
              color: borderColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              question.isCorrect ? '回答正确！' : '回答错误',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: borderColor,
              ),
            ),
            if (!question.isCorrect) ...[
              const SizedBox(height: 8),
              Text(
                '正确答案',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                question.correctAnswer,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
