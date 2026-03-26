import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class LeechManagementScreen extends StatefulWidget {
  const LeechManagementScreen({super.key});

  @override
  State<LeechManagementScreen> createState() => _LeechManagementScreenState();
}

enum _LeechTab { word, grammar }

class _LeechManagementScreenState extends State<LeechManagementScreen> {
  _LeechTab _selectedTab = _LeechTab.word;

  final List<Map<String, dynamic>> _mockWords = [
    {'kanji': '曖昧', 'kana': 'あいまい', 'meaning': '模棱两可，含糊', 'fails': 15},
    {'kanji': '遠慮', 'kana': 'えんりょ', 'meaning': '客气，谢绝', 'fails': 12},
    {'kanji': '偶然', 'kana': 'ぐうぜん', 'meaning': '偶然', 'fails': 8},
  ];

  final List<Map<String, dynamic>> _mockGrammars = [
    {'title': '～にしたがって', 'meaning': '随着...', 'fails': 5},
    {'title': '～ざるを得ない', 'meaning': '不得不...', 'fails': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('复学清单', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: NemoColors.bgBase,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // 1. Floating Pill Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _PillTab(
                    title: '单词',
                    count: _mockWords.length,
                    isSelected: _selectedTab == _LeechTab.word,
                    onTap: () => setState(() => _selectedTab = _LeechTab.word),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PillTab(
                    title: '语法',
                    count: _mockGrammars.length,
                    isSelected: _selectedTab == _LeechTab.grammar,
                    onTap: () => setState(() => _selectedTab = _LeechTab.grammar),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 2. Content List
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final items = _selectedTab == _LeechTab.word ? _mockWords : _mockGrammars;
    
    if (items.isEmpty) {
      return _EmptyLeechView(
        message: _selectedTab == _LeechTab.word ? '太棒了！\n没有需要复学的单词' : '太棒了！\n没有需要复学的语法',
      );
    }

    return ListView.builder(
      key: ValueKey(_selectedTab),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _LeechItemCard(
            title: item['kanji'] ?? item['title'],
            subtitle: _selectedTab == _LeechTab.word 
                ? '${item['kana']} ${item['meaning']}' 
                : item['meaning'],
            onRecover: () {
              // TODO: Implement recover logic
            },
          ),
        );
      },
    );
  }
}

class _PillTab extends StatelessWidget {
  const _PillTab({
    required this.title,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? NemoColors.brandBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Colors.transparent 
                : (isDark ? Colors.white24 : Colors.black12),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$title ($count)',
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _LeechItemCard extends StatelessWidget {
  const _LeechItemCard({
    required this.title,
    required this.subtitle,
    required this.onRecover,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRecover;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      child: Row(
        children: [
          // Pill Indicator
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: NemoColors.brandBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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

          // Recover Button
          Material(
            color: NemoColors.brandBlue.withOpacity(0.1),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: onRecover,
              icon: const Icon(
                Icons.restore_rounded,
                color: NemoColors.brandBlue,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLeechView extends StatelessWidget {
  const _EmptyLeechView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 48,
              color: NemoColors.brandBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: NemoColors.textSub,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
