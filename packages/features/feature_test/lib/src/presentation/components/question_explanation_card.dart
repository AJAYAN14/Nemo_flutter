import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core_designsystem/core_designsystem.dart';

part 'question_explanation_card.freezed.dart';

@freezed
class ExplanationPayload with _$ExplanationPayload {
  const factory ExplanationPayload.wordSummary({
    required String japanese,
    required String hiragana,
    required String meaning,
  }) = _WordSummary;

  const factory ExplanationPayload.text({
    required String text,
  }) = _Text;
}

class QuestionExplanationCard extends StatelessWidget {
  const QuestionExplanationCard({
    super.key,
    required this.payload,
  });

  final ExplanationPayload payload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "解析",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          payload.when(
            wordSummary: (japanese, hiragana, meaning) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  japanese,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hiragana,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    meaning,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            text: (text) => Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
