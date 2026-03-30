import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core_domain/core_domain.dart';
import 'leech_management_providers.dart';

class LeechManagementScreen extends HookConsumerWidget {
  const LeechManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leechAsync = ref.watch(leechManagementNotifierProvider);
    final notifier = ref.read(leechManagementNotifierProvider.notifier);
    final selectedTab = useState(_LeechTab.word);
    
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
      body: leechAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: NemoColors.brandBlue)),
        error: (err, stack) => Center(child: Text('加载失败: $err')),
        data: (state) => Stack(
          children: [
            Column(
              children: [
                // 1. Floating Pill Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PillTab(
                          title: '单词',
                          count: state.skippedWords.length,
                          isSelected: selectedTab.value == _LeechTab.word,
                          onTap: () => selectedTab.value = _LeechTab.word,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PillTab(
                          title: '语法',
                          count: state.skippedGrammars.length,
                          isSelected: selectedTab.value == _LeechTab.grammar,
                          onTap: () => selectedTab.value = _LeechTab.grammar,
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
                    child: _buildList(context, state, selectedTab.value, notifier),
                  ),
                ),
              ],
            ),
            
            // Undo/Message Snackbar
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: SafeArea(
                child: NemoSnackbar(
                  visible: state.successMessage != null || state.error != null,
                  message: state.successMessage ?? state.error ?? '',
                  type: state.error != null ? NemoSnackbarType.error : NemoSnackbarType.success,
                  onDismiss: () => notifier.clearMessages(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, LeechManagementState state, _LeechTab tab, LeechManagementNotifier notifier) {
    final items = tab == _LeechTab.word ? state.skippedWords : state.skippedGrammars;
    
    if (items.isEmpty) {
      return _EmptyLeechView(
        key: ValueKey('empty_$tab'),
        message: tab == _LeechTab.word ? '太棒了！\n没有需要复学的单词' : '太棒了！\n没有需要复学的语法',
      );
    }

    return ListView.builder(
      key: ValueKey(tab),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final id = item is WordItem ? item.word.id : (item as GrammarItem).grammar.id;
        final type = item is WordItem ? 'word' : 'grammar';
        final title = item is WordItem ? item.word.japanese : (item as GrammarItem).grammar.grammar;
        final subtitle = item is WordItem 
            ? '${item.word.hiragana} ${item.word.chinese}' 
            : (item as GrammarItem).grammar.usages.firstOrNull?.explanation ?? '';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _LeechItemCard(
            title: title,
            subtitle: subtitle,
            onRecover: () => notifier.recover(id, type),
          ),
        );
      },
    );
  }
}

enum _LeechTab { word, grammar }

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

class _LeechItemCard extends HookWidget {
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
    final isRecovering = useState(false);

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
            color: NemoColors.brandBlue.withValues(alpha: 0.1),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: isRecovering.value 
                ? null 
                : () async {
                    isRecovering.value = true;
                    onRecover();
                    // State will update and this widget will likely be removed from list
                  },
              icon: isRecovering.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: NemoColors.brandBlue),
                  )
                : const Icon(
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
  const _EmptyLeechView({super.key, required this.message});
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
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
