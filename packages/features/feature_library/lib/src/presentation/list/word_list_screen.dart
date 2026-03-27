import 'dart:async';
import 'package:core_storage/core_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:core_domain/core_domain.dart';
import 'package:go_router/go_router.dart';
import '../../routes/library_routes.dart';

class WordListScreen extends ConsumerStatefulWidget {
  const WordListScreen({super.key});

  @override
  ConsumerState<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen> {
  String _searchQuery = '';
  Timer? _debounce;
  late final TextEditingController _searchController;
  final List<String> _expandedLevels = []; 
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Group words by level
  Map<String, List<WordEntry>> _groupWords(List<WordEntry> words) {
    final groups = <String, List<WordEntry>>{};
    for (var word in words) {
      if (_searchQuery.isNotEmpty) {
        if (!GrammarSearchUtils.isMatch(word.japanese, _searchQuery) &&
            !GrammarSearchUtils.isMatch(word.hiragana, _searchQuery) &&
            !word.chinese.toLowerCase().contains(_searchQuery.toLowerCase())) {
          continue;
        }
      }
      groups.putIfAbsent(word.level, () => []).add(word);
    }
    return groups;
  }

  void _toggleLevel(String level) {
    setState(() {
      if (_expandedLevels.contains(level)) {
        _expandedLevels.remove(level);
      } else {
        _expandedLevels.add(level);
      }
    });
  }

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'N5': return NemoColors.n5;
      case 'N4': return NemoColors.n4;
      case 'N3': return NemoColors.n3;
      case 'N2': return NemoColors.n2;
      case 'N1': return NemoColors.n1;
      default: return NemoColors.brandBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger importer if needed
    final importerAsync = ref.watch(assetDataImporterProvider);
    final wordsAsync = ref.watch(allWordsProvider);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('单词列表', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: NemoColors.bgBase,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _SearchBar(
              controller: _searchController,
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  setState(() => _searchQuery = val);
                });
              },
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),
        ),
      ),
      body: importerAsync.when(
        data: (_) => wordsAsync.when(
          data: (words) {
            final grouped = _groupWords(words);
            final levels = grouped.keys.toList()..sort();

            if (grouped.isEmpty) {
              return const Center(child: _EmptyState(message: '未找到相关单词'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                final levelWords = grouped[level]!;
                final isExpanded = _searchQuery.isNotEmpty || _expandedLevels.contains(level);
                final levelColor = _getLevelColor(level);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level Header
                    InkWell(
                      onTap: () => _toggleLevel(level),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: levelColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              level,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${levelWords.length} 词',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Words List
                    if (isExpanded)
                      ...levelWords.map((word) => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: _WordListItemPremium(
                          word: word,
                          onClick: () => context.pushNamed(
                            LibraryRouteNames.wordDetail,
                            pathParameters: {'wordId': word.id},
                          ),
                        ),
                      )),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Word Loading Error: $err')),
        ),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('正在初始化词库数据...', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        error: (err, stack) => Center(child: Text('数据导入失败: $err')),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller, 
    required this.onChanged,
    required this.onClear,
  });
  
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.white;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: '搜索：汉字 / 假名 / 释义',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WordListItemPremium extends StatelessWidget {
  const _WordListItemPremium({required this.word, required this.onClick});
  final WordEntry word;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final avatarColors = [
      NemoColors.brandBlue,
      NemoColors.n2, // Orange
      NemoColors.n5, // Green
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF14B8A6), // Teal
      NemoColors.accentPurple,
      NemoColors.n1, // Pink
      NemoColors.n4, // Cyan
    ];
    final color = avatarColors[word.id.hashCode.abs() % avatarColors.length];
    final avatarChar = word.japanese.isNotEmpty ? word.japanese[0] : '?';

    return PremiumCard(
      onClick: onClick,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              avatarChar,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.japanese,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${word.hiragana} · ${word.chinese}',
                  style: TextStyle(
                    fontSize: 14,
                    color: NemoColors.textSub,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_rounded,
          size: 64,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
