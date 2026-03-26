import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SortingStateNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ['て', '食べ', 'ました', 'しまい'];

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<String> items = List.from(state);
    final String item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = items;
  }
}

final sortingStateProvider = NotifierProvider<SortingStateNotifier, List<String>>(SortingStateNotifier.new);

class SortingScreen extends HookConsumerWidget {
  const SortingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(sortingStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(
            'ケーキを全部 ______。',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: NemoColors.textMain,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '(把蛋糕全吃光了。)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NemoColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Expanded(
            child: ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              proxyDecorator: (child, index, animation) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: NemoColors.brandBlue.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: child,
                  ),
                );
              },
              itemCount: items.length,
              onReorder: (oldIndex, newIndex) => ref.read(sortingStateProvider.notifier).reorder(oldIndex, newIndex),
              itemBuilder: (context, index) {
                final text = items[index];
                return Padding(
                  key: ValueKey(text),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: NemoMetrics.radius(16),
                      border: Border.all(color: NemoColors.borderLight, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: NemoColors.textSub,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          text,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: NemoColors.textMain,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const Expanded(child: SizedBox()),
                        const Icon(CupertinoIcons.bars, color: NemoColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
