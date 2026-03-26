import 'package:flutter/material.dart';

/// 仅UI复刻，无业务逻辑与状态管理
class MultipleChoiceScreen extends StatelessWidget {
  const MultipleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例静态数据
    final questionText = '日语单词的中文释义是？';
    final options = ['选项A', '选项B', '选项C', '选项D'];
    final correctIndex = 1;
    final selectedIndex = 2;
    final isAnswered = true;
    final explanation = '解析内容示例';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text('选择题')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                questionText,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            if (isAnswered)
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
            Column(
              children: List.generate(options.length, (index) {
                OptionStatus status;
                if (isAnswered) {
                  if (index == correctIndex) {
                    status = OptionStatus.correct;
                  } else if (index == selectedIndex && selectedIndex != correctIndex) {
                    status = OptionStatus.incorrect;
                  } else {
                    status = OptionStatus.none;
                  }
                } else {
                  status = selectedIndex == index ? OptionStatus.selected : OptionStatus.none;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _TestOption(
                    index: index,
                    text: options[index],
                    status: status,
                  ),
                );
              }),
            ),
            if (isAnswered && explanation.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: _QuestionExplanationCard(text: explanation),
              ),
          ],
        ),
      ),
    );
  }
}

enum OptionStatus { none, selected, correct, incorrect }

class _TestOption extends StatelessWidget {
  final int index;
  final String text;
  final OptionStatus status;

  const _TestOption({super.key, required this.index, required this.text, required this.status});

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color? borderColor;
    Color? textColor = Theme.of(context).colorScheme.onSurface;
    Widget? icon;
    switch (status) {
      case OptionStatus.selected:
        borderColor = Theme.of(context).colorScheme.primary;
        bgColor = Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1);
        break;
      case OptionStatus.correct:
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        icon = const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20);
        break;
      case OptionStatus.incorrect:
        borderColor = Theme.of(context).colorScheme.error;
        bgColor = Theme.of(context).colorScheme.errorContainer.withOpacity(0.1);
        icon = Icon(Icons.cancel_rounded, color: Theme.of(context).colorScheme.error, size: 20);
        textColor = Theme.of(context).colorScheme.error;
        break;
      default:
        borderColor = Theme.of(context).colorScheme.outlineVariant;
        bgColor = Theme.of(context).colorScheme.surface;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor!, width: 2),
      ),
      child: Row(
        children: [
          Text(
            String.fromCharCode(0x41 + index), // A/B/C/D
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            icon,
          ],
        ],
      ),
    );
  }
}

class _QuestionExplanationCard extends StatelessWidget {
  final String text;
  const _QuestionExplanationCard({required this.text});
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
            text,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
