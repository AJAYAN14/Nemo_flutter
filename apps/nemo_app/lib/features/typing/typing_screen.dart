import 'package:flutter/material.dart';

/// 仅UI复刻，无业务逻辑与状态管理
class TypingScreen extends StatelessWidget {
  const TypingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例静态数据
    final question = _FakeTypingQuestion();
    final isAnswered = false;
    final isCorrect = false;
    final userInput = '';

    final (displayText, hintText) = _getDisplayAndHint(question);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text('拼写题')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Stimulus Text
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
            TextField(
              enabled: !isAnswered,
              decoration: InputDecoration(
                labelText: "你的答案",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1.5),
                ),
                filled: true,
                fillColor: isAnswered
                    ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3)
                    : Theme.of(context).colorScheme.surface,
              ),
              style: TextStyle(
                color: isAnswered && !isCorrect
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            // Feedback Section
            if (isAnswered)
              _TypingFeedback(isCorrect: isCorrect, correctAnswer: question.correctAnswer),
            // Word Explanation Card
            if (isAnswered)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _QuestionExplanationCard(
                  japanese: question.japanese,
                  hiragana: question.hiragana,
                  meaning: question.chinese,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// region: 伪造静态数据与UI辅助
class _FakeTypingQuestion {
  final int typingQuestionType = 1;
  final String chinese = '日语单词释义';
  final String hiragana = 'ひらがな';
  final String japanese = '日本語';
  final String questionText = '问题文本';
  final String correctAnswer = '正确答案';
}

(String, String) _getDisplayAndHint(_FakeTypingQuestion q) {
  switch (q.typingQuestionType) {
    case 1:
      return (q.chinese, "输入对应的日语假名");
    case 2:
      return (q.chinese, "输入对应的日语汉字");
    case 3:
      return (q.hiragana, "输入对应的日语汉字");
    case 4:
      return (q.japanese, "输入对应的日语假名");
    case 5:
      return (q.hiragana, "输入对应的中文释义");
    case 6:
      return (q.japanese, "输入对应的中文释义");
    default:
      return (q.questionText, "请输入答案");
  }
}

class _TypingFeedback extends StatelessWidget {
  const _TypingFeedback({required this.isCorrect, required this.correctAnswer});
  final bool isCorrect;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeColor = isCorrect ? colorScheme.primary : colorScheme.error;
    return Container(
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
              correctAnswer,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuestionExplanationCard extends StatelessWidget {
  const _QuestionExplanationCard({required this.japanese, required this.hiragana, required this.meaning});
  final String japanese;
  final String hiragana;
  final String meaning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
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
    );
  }
}
