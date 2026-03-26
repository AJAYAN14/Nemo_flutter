import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import '../category/category_classification_screen.dart';
import 'package:go_router/go_router.dart';
import '../../mock/mock_category_grammar.dart';
import '../../routes/library_routes.dart';

class GrammarListScreen extends StatefulWidget {
  const GrammarListScreen({super.key});

  @override
  State<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<GrammarListScreen> {
  String _searchQuery = '';
  final List<String> _expandedLevels = [];

  // Group grammars by level
  Map<String, List<GrammarMockData>> get _groupedGrammars {
    final groups = <String, List<GrammarMockData>>{};
    for (var grammar in mockGrammars) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!grammar.title.toLowerCase().contains(query) &&
            !grammar.meaning.toLowerCase().contains(query)) {
          continue;
        }
      }
      groups.putIfAbsent(grammar.level, () => []).add(grammar);
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
      case 'N5':
        return const Color(0xFF10B981); // Green
      case 'N4':
        return const Color(0xFF06B6D4); // Cyan
      case 'N3':
        return NemoColors.brandBlue; // Blue
      case 'N2':
        return const Color(0xFFF59E0B); // Orange
      case 'N1':
        return const Color(0xFFEC4899); // Pink
      default:
        return NemoColors.brandBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedGrammars;
    final levels = grouped.keys.toList()..sort();

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('语法库', style: TextStyle(fontWeight: FontWeight.w900)),
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
              query: _searchQuery,
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
      body: grouped.isEmpty
          ? const Center(child: _EmptyState(message: '未找到相关语法'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                final grammars = grouped[level]!;
                final isExpanded =
                    _searchQuery.isNotEmpty || _expandedLevels.contains(level);
                final levelColor = _getLevelColor(level);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level Header
                    InkWell(
                      onTap: () => _toggleLevel(level),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                              '${grammars.length} 条',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Grammars List
                    if (isExpanded)
                      ...grammars.map(
                            (grammar) => Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                              child: _GrammarListItemPremium(
                                grammar: grammar,
                                onClick: () {
                                  final id = mockGrammars.indexOf(grammar);
                                  context.pushNamed(
                                    LibraryRouteNames.grammarDetail,
                                    pathParameters: {'grammarId': id.toString()},
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.query, required this.onChanged});
  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Colors.white;

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
          Icon(
            Icons.search_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: TextEditingController(text: query)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: query.length),
                ),
              decoration: InputDecoration(
                hintText: '搜索：语法 / 解释',
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () => onChanged(''),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

class _GrammarListItemPremium extends StatelessWidget {
  const _GrammarListItemPremium({required this.grammar, required this.onClick});
  final GrammarMockData grammar;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final avatarColors = [
      NemoColors.brandBlue,
      const Color(0xFFF59E0B), // Orange
      const Color(0xFF10B981), // Green
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFD946EF), // Pink
    ];
    final color =
        avatarColors[grammar.title.hashCode.abs() % avatarColors.length];

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
              '文',
              style: TextStyle(
                fontSize: 20,
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
                  grammar.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grammar.meaning,
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
