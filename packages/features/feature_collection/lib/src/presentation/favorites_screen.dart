import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteItem {
  const FavoriteItem(this.id, this.title, this.subtitle, this.meaning);
  final String id;
  final String title;
  final String subtitle;
  final String meaning;
}

class FavoritesNotifier extends Notifier<List<FavoriteItem>> {
  @override
  List<FavoriteItem> build() => [
        const FavoriteItem('1', '挑戦', 'ちょうせん', '挑战，尝试'),
        const FavoriteItem('2', '習慣', 'しゅうかん', '习惯，习俗'),
        const FavoriteItem('3', '曖昧', 'あいまい', '模棱两可'),
        const FavoriteItem('4', '遠慮', 'えんりょ', '客气，谢绝'),
      ];

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<FavoriteItem>>(FavoritesNotifier.new);

class FavoritesScreen extends HookConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: NemoColors.surfaceSoft,
        appBar: AppBar(
          title: const Text('我的收藏', style: TextStyle(fontWeight: FontWeight.w800)),
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
              Tab(text: '单词'),
              Tab(text: '语法'),
              Tab(text: '题目'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoritesList(),
            _FavoritesList(titleOffset: '语法'),
            _FavoritesList(titleOffset: '题目'),
          ],
        ),
      ),
    );
  }
}

class _FavoritesList extends HookConsumerWidget {
  const _FavoritesList({this.titleOffset = ''});
  final String titleOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(favoritesProvider);

    if (items.isEmpty) {
      return Center(
        child: Text(
          '空空如也，快去学习吧！',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: NemoColors.textMuted),
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
            ref.read(favoritesProvider.notifier).removeItem(item.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已从收藏中移除: ${item.title}'), duration: const Duration(seconds: 2)),
            );
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: NemoMetrics.radius(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(CupertinoIcons.trash, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: NemoMetrics.radius(16),
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
                            '$titleOffset${item.title}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: NemoColors.textMain,
                                ),
                          ),
                          const SizedBox(width: 8),
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
                const Icon(CupertinoIcons.heart_fill, color: Color(0xFFF43F5E)),
              ],
            ),
          ),
        );
      },
    );
  }
}
