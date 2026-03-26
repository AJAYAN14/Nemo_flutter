import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'components/flip_card.dart';

enum CategoryViewMode { list, card }

class CategoryWordsScreen extends StatefulWidget {
  const CategoryWordsScreen({
    super.key,
    required this.categoryId,
    required this.title,
    this.initialMode = CategoryViewMode.list,
  });

  final String categoryId;
  final String title;
  final CategoryViewMode initialMode;

  @override
  State<CategoryWordsScreen> createState() => _CategoryWordsScreenState();
}

class _CategoryWordsScreenState extends State<CategoryWordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _expandedLevels = {'N5', 'N4', 'N3', 'N2', 'N1'};
  String _searchQuery = '';
  late CategoryViewMode _viewMode;
  int _currentCardIndex = 0;
  final Map<int, bool> _flippedStates = {};
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.initialMode;
    _pageController = PageController();
  }

  final List<Map<String, dynamic>> _mockWords = [
    {
      'id': 1,
      'japanese': '曖昧[あいまい]',
      'hiragana': 'あいまい',
      'meaning': '模棱两可，含糊',
      'level': 'N1',
      'examples': [
        {'japanese': '曖昧[あいまい]な返事[へんじ]をする。', 'chinese': '做出含糊的回答。'}
      ]
    },
    {
      'id': 2,
      'japanese': '遠慮[えんりょ]',
      'hiragana': 'えんりょ',
      'meaning': '客气，谢绝',
      'level': 'N2',
      'examples': [
        {'japanese': 'どうぞご遠慮[えんりょ]なく。', 'chinese': '请不要客气。'}
      ]
    },
    {
      'id': 3,
      'japanese': '昨日[きのう]',
      'hiragana': 'きのう',
      'meaning': '昨天',
      'level': 'N5',
      'examples': [
        {'japanese': '昨日[きのう]避头[あめ]でした。', 'chinese': '昨天打雷了。'}
      ]
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Color _getCategoryThemeColor() {
    switch (widget.categoryId) {
      case 'verb': return NemoCategoryColors.cardVerbTextLight;
      case 'noun': return NemoCategoryColors.cardNounTextLight;
      case 'adj': return NemoCategoryColors.cardAdjITextLight;
      case 'adv': return NemoCategoryColors.cardAdvTextLight;
      case 'kata': return NemoCategoryColors.cardKataTextLight;
      case 'particle': return NemoCategoryColors.cardFixTextLight;
      case 'expression': return NemoCategoryColors.cardKeigoTextLight;
      default: return NemoColors.brandBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = NemoColors.bgBase;
    final themeColor = _getCategoryThemeColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _viewMode == CategoryViewMode.list 
              ? widget.title 
              : '${widget.title} (${_currentCardIndex + 1}/${_mockWords.length})',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _viewMode == CategoryViewMode.list ? Icons.view_carousel_rounded : Icons.list_alt_rounded,
              color: themeColor,
            ),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == CategoryViewMode.list 
                    ? CategoryViewMode.card 
                    : CategoryViewMode.list;
              });
            },
          ),
        ],
      ),
      body: _viewMode == CategoryViewMode.list ? _buildListView() : _buildCardView(themeColor),
    );
  }

  Widget _buildListView() {
    final allLevels = ['N1', 'N2', 'N3', 'N4', 'N5'];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: _SearchBar(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
        for (final level in allLevels) ...[
          _buildLevelHeader(level),
          if (_expandedLevels.contains(level) || _searchQuery.isNotEmpty)
            _buildWordList(level),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildCardView(Color themeColor) {
    if (_mockWords.isEmpty) {
      return const Center(child: Text('该分类下暂无词汇'));
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _mockWords.length,
            onPageChanged: (index) => setState(() {
              _currentCardIndex = index;
            }),
            itemBuilder: (context, index) {
              final word = _mockWords[index];
              final isFlipped = _flippedStates[index] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: FlipCard(
                  japanese: word['japanese'],
                  hiragana: word['hiragana'],
                  meaning: word['meaning'],
                  examples: List<Map<String, String>>.from(word['examples'] ?? []),
                  themeColor: themeColor,
                  isFlipped: isFlipped,
                  onFlip: () => setState(() => _flippedStates[index] = !isFlipped),
                  onSpeak: () {},
                  categoryId: widget.categoryId,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Row(
            children: [
              _TintedSquircleIconButton(
                iconData: Icons.arrow_back_ios_new_rounded,
                onPressed: _currentCardIndex > 0 ? () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } : null,
                themeColor: themeColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text(
                      '跟打练习', 
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _TintedSquircleIconButton(
                iconData: Icons.arrow_forward_ios_rounded,
                onPressed: _currentCardIndex < _mockWords.length - 1 ? () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } : null,
                themeColor: themeColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelHeader(String level) {
    final isExpanded = _expandedLevels.contains(level);
    final color = _getLevelColor(level);
    final count = _mockWords.where((w) => w['level'] == level).length;

    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          if (_searchQuery.isEmpty) {
            setState(() {
              if (isExpanded) {
                _expandedLevels.remove(level);
              } else {
                _expandedLevels.add(level);
              }
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                level,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 8),
              Text(
                '$count 词',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_searchQuery.isEmpty)
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordList(String level) {
    final words = _mockWords.where((w) => w['level'] == level).toList();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final word = words[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WordListItem(
                japanese: word['japanese'],
                hiragana: word['hiragana'],
                meaning: word['meaning'],
                onClick: () {},
              ),
            );
          },
          childCount: words.length,
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'N5': return Colors.green;
      case 'N4': return Colors.cyan;
      case 'N3': return Colors.blue;
      case 'N2': return Colors.orange;
      case 'N1': return Colors.pink;
      default: return Colors.blue;
    }
  }
}

class _TintedSquircleIconButton extends StatelessWidget {
  const _TintedSquircleIconButton({
    required this.iconData,
    this.onPressed,
    required this.themeColor,
  });

  final IconData iconData;
  final VoidCallback? onPressed;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Container(
      width: 56,
      height: 56,
      decoration: ShapeDecoration(
        color: enabled ? themeColor.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: IconButton(
        icon: Icon(
          iconData, 
          color: enabled ? themeColor : Colors.grey.withValues(alpha: 0.5), 
          size: 24,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: '搜索：汉字 / 假名 / 释义',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordListItem extends StatelessWidget {
  const _WordListItem({
    required this.japanese,
    required this.hiragana,
    required this.meaning,
    required this.onClick,
  });

  final String japanese;
  final String hiragana;
  final String meaning;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(20),
      onClick: onClick,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: NemoColors.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              japanese.isNotEmpty ? japanese[0] : '?',
              style: const TextStyle(color: NemoColors.brandBlue, fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NemoFuriganaText(
                  text: japanese,
                  baseTextStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text('$hiragana · $meaning', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
