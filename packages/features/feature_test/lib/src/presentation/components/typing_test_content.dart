import 'package:core_domain/core_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'question_explanation_card.dart';

class TypingTestContent extends HookConsumerWidget {
  const TypingTestContent({
    super.key,
    required this.question,
    required this.userInput,
    required this.onInputChange,
  });

  final TestQuestion question;
  final String userInput;
  final ValueChanged<String> onInputChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Determine display and hint text based on typingQuestionType
    final (displayText, hintText) = _getDisplayAndHint(question);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Stimulus Text (32sp Bold)
          Text(
            displayText,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Hint Text
          Text(
            hintText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // Typing Input Field
          _TypingInput(
            question: question,
            userInput: userInput,
            onInputChange: onInputChange,
          ),

          const SizedBox(height: 32),

          // Feedback Section
          _TypingFeedback(question: question),

          // Word Explanation Card
          if (question.isAnswered) ...[
            const SizedBox(height: 24),
            QuestionExplanationCard(
              payload: ExplanationPayload.wordSummary(
                japanese: question.japanese ?? "",
                hiragana: question.hiragana ?? "",
                meaning: question.chinese ?? "",
              ),
            ),
          ],
        ],
      ),
    );
  }

  (String, String) _getDisplayAndHint(TestQuestion q) {
    switch (q.typingQuestionType) {
      case 1: return (q.chinese ?? q.questionText, "输入对应的日语假名");
      case 2: return (q.chinese ?? q.questionText, "输入对应的日语汉字");
      case 3: return (q.hiragana ?? q.questionText, "输入对应的日语汉字");
      case 4: return (q.japanese ?? q.questionText, "输入对应的日语假名");
      case 5: return (q.hiragana ?? q.questionText, "输入对应的中文释义");
      case 6: return (q.japanese ?? q.questionText, "输入对应的中文释义");
      default: return (q.questionText, "请输入答案");
    }
  }
}

class _TypingInput extends HookWidget {
  const _TypingInput({
    required this.question,
    required this.userInput,
    required this.onInputChange,
  });

  final TestQuestion question;
  final String userInput;
  final ValueChanged<String> onInputChange;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final controller = useTextEditingController(
      text: question.isAnswered ? (question.userAnswer ?? "") : userInput,
    );

    // Sync controller with userInput if not answered
    useEffect(() {
      if (!question.isAnswered && controller.text != userInput) {
        controller.text = userInput;
      }
      return null;
    }, [userInput, question.isAnswered]);

    // Auto-focus logic
    useEffect(() {
      if (!question.isAnswered) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });
      }
      return null;
    }, [question.isAnswered]);

    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = !question.isAnswered 
        ? colorScheme.outlineVariant 
        : (question.isCorrect ? colorScheme.primary : colorScheme.error);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (value) {
        HapticFeedback.selectionClick();
        onInputChange(value);
      },
      enabled: !question.isAnswered,
      style: TextStyle(
        color: question.isAnswered && !question.isCorrect 
            ? colorScheme.error 
            : colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: "你的答案",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        filled: true,
        fillColor: question.isAnswered 
            ? colorScheme.surfaceVariant.withOpacity(0.3) 
            : colorScheme.surface,
      ),
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.done,
    );
  }
}

class _TypingFeedback extends StatelessWidget {
  const _TypingFeedback({required this.question});
  final TestQuestion question;

  @override
  Widget build(BuildContext context) {
    if (!question.isAnswered) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final isCorrect = question.isCorrect;
    final themeColor = isCorrect ? colorScheme.primary : colorScheme.error;

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeColor, width: 1),
        ),
        child: Column(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: themeColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              isCorrect ? "回答正确！" : "回答错误",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 12),
              Text(
                "正确答案",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                question.correctAnswer,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
