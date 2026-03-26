import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MistakeItem {
  const MistakeItem(this.id, this.title, this.subtitle, this.meaning, this.fails);
  final String id;
  final String title;
  final String subtitle;
  final String meaning;
  final int fails;
}

class MistakesNotifier extends Notifier<List<MistakeItem>> {
  @override
  List<MistakeItem> build() => [
        const MistakeItem('1', '偶然', 'ぐうぜん', '偶然', 8),
        const MistakeItem('2', '詳細', 'しょうさい', '详细，详情', 5),
        const MistakeItem('3', '発展', 'はってん', '发展', 3),
        const MistakeItem('4', '努力', 'どりょく', '努力', 2),
      ];

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final mistakesProvider = NotifierProvider<MistakesNotifier, List<MistakeItem>>(MistakesNotifier.new);

class MistakesScreen extends HookConsumerWidget {
  const MistakesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: NemoColors.surfaceSoft,
        appBar: AppBar(
          title: const Text('错题本', style: TextStyle(fontWeight: FontWeight.w800)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(),
          bottom: const TabBar(
            labelColor: NemoColors.brandBlue,
            unselectedLabelColor: NemoColors.textMuted,
            indicatorColor: NemoColors.brandBlue,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            tabs: [
              Tab(text: '错词'),
              Tab(text: '错题'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MistakesList(),
            _MistakesList(isQuestion: true),
          ],
        ),
      ),
    );
  }
}

class _MistakesList extends HookConsumerWidget {
  const _MistakesList({this.isQuestion = false});
  final bool isQuestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(mistakesProvider);

    if (items.isEmpty) {
      return Center(
        child: Text(
          '太棒了！错题已经全部消灭',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w800,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            ref.read(mistakesProvider.notifier).removeItem(item.id);
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981), // Green for marking as resolved
              borderRadius: NemoMetrics.radius(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: NemoMetrics.radius(16),
              border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5), // Subtle red border
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isQuestion ? 'Q: ${item.title}' : item.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: NemoColors.textMain,
                                ),
                          ),
                          const SizedBox(width: 8),
                          if (!isQuestion)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                item.subtitle,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: NemoColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.meaning,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NemoColors.textSub),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '做错',
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${item.fails}次',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
