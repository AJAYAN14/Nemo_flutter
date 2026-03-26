import 'package:flutter/material.dart';

/// 仅UI复刻，无业务逻辑与状态管理
class CardMatchingScreen extends StatelessWidget {
  const CardMatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例静态数据
    final termCards = [
      _CardData(id: '1', text: '词语1'),
      _CardData(id: '2', text: '词语2'),
      _CardData(id: '3', text: '词语3'),
    ];
    final definitionCards = [
      _CardData(id: 'a', text: '释义A'),
      _CardData(id: 'b', text: '释义B'),
      _CardData(id: 'c', text: '释义C'),
    ];
    final matchedIds = <String>[];
    final selectedId = '';
    final isError = false;
    final isComplete = false;
    final errorCount = 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text('配对题')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back, size: 28),
                Text('00:45', style: Theme.of(context).textTheme.titleMedium),
                Icon(Icons.help_outline, size: 28),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: termCards.map((card) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: _FlippableCard(
                          text: card.text,
                          state: CardState.default_,
                          isMatched: matchedIds.contains(card.id),
                        ),
                      )).toList(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: definitionCards.map((card) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: _FlippableCard(
                          text: card.text,
                          state: CardState.default_,
                          isMatched: matchedIds.contains(card.id),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: (isComplete || isError)
          ? _MatchingFeedbackPanel(isComplete: isComplete, errorCount: errorCount)
          : null,
    );
  }
}

class _CardData {
  final String id;
  final String text;
  _CardData({required this.id, required this.text});
}

enum CardState { default_, selected, correct, incorrect }

class _FlippableCard extends StatelessWidget {
  final String text;
  final CardState state;
  final bool isMatched;
  const _FlippableCard({required this.text, required this.state, this.isMatched = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color backgroundColor = colorScheme.surface;
    Color borderColor = colorScheme.outlineVariant;
    Widget? icon;
    switch (state) {
      case CardState.selected:
        backgroundColor = colorScheme.primaryContainer.withOpacity(0.1);
        borderColor = colorScheme.primary;
        break;
      case CardState.correct:
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        icon = const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20);
        break;
      case CardState.incorrect:
        backgroundColor = colorScheme.errorContainer.withOpacity(0.1);
        borderColor = colorScheme.error;
        icon = Icon(Icons.cancel_rounded, color: colorScheme.error, size: 20);
        break;
      default:
        break;
    }
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isMatched ? 0.0 : 1.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: isMatched ? 0.8 : 1.0,
        child: Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (icon != null) icon,
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchingFeedbackPanel extends StatelessWidget {
  final bool isComplete;
  final int errorCount;
  const _MatchingFeedbackPanel({required this.isComplete, required this.errorCount});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.error_outline,
            color: isComplete ? Colors.green : colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            isComplete ? '配对完成！' : '有错误，请重试',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isComplete ? Colors.green : colorScheme.error,
                ),
          ),
          if (!isComplete) ...[
            const SizedBox(height: 8),
            Text('错误次数：$errorCount', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
