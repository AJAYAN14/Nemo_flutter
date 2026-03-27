import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_storage/core_storage.dart';

import 'category_card_learning_providers.dart';
import 'typing_practice_dialog.dart';

class CategoryCardLearningScreen extends ConsumerWidget {
  const CategoryCardLearningScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  final String categoryId;
  final String categoryTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(categoryCardLearningNotifierProvider(categoryId));
    final notifier = ref.read(categoryCardLearningNotifierProvider(categoryId).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // UI/UX PRO: Get theme color for category
    final themeColor = _getThemeColorForCategory(categoryId, isDark);

    final titleWithCount = uiState.isLoading || uiState.error != null
        ? categoryTitle
        : '$categoryTitle (${uiState.currentWordIndex + 1}/${uiState.words.length})';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          titleWithCount,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_numbered_rounded),
            onPressed: () => _showAnswerSheet(context, ref, uiState, themeColor),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark ? const Color(0xFF121212) : themeColor.withValues(alpha: 0.05),
              isDark ? const Color(0xFF1E1E1E) : themeColor.withValues(alpha: 0.15),
            ],
          ),
        ),
        child: _buildContent(context, ref, uiState, notifier, themeColor),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    CategoryCardLearningUiState uiState,
    CategoryCardLearningNotifier notifier,
    Color themeColor,
  ) {
    if (uiState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (uiState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('加载失败', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(uiState.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(categoryCardLearningNotifierProvider(categoryId)),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (uiState.words.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('暂无词汇', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('该分类下暂时没有词汇'),
          ],
        ),
      );
    }

    final currentWord = uiState.currentWord!;

    return Stack(
      children: [
        // Word Card with Swipe Gestures
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 500) {
                  // Swipe Right -> Previous
                  notifier.previousWord();
                } else if (details.primaryVelocity! < -500) {
                  // Swipe Left -> Next
                  notifier.nextWord();
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offset = uiState.slideDirection == SlideDirection.forward
                      ? (child.key == ValueKey(uiState.currentWordIndex)
                          ? const Offset(1.0, 0.0)
                          : const Offset(-1.0, 0.0))
                      : (child.key == ValueKey(uiState.currentWordIndex)
                          ? const Offset(-1.0, 0.0)
                          : const Offset(1.0, 0.0));

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: offset,
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  key: ValueKey(uiState.currentWordIndex),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
                      child: _CategoryFlipCard(
                        word: currentWord,
                        isFlipped: uiState.isFlipped,
                        onFlip: notifier.flipCard,
                        themeColor: themeColor,
                        categoryId: categoryId,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Action Buttons
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _CategoryCardActionButtons(
            hasPrevious: uiState.currentWordIndex > 0,
            hasNext: uiState.currentWordIndex < uiState.words.length - 1,
            onPrevious: notifier.previousWord,
            onPractice: () => _showTypingDialog(context, ref, currentWord, themeColor),
            onNext: notifier.nextWord,
            themeColor: themeColor,
          ),
        ),
      ],
    );
  }

  void _showAnswerSheet(BuildContext context, WidgetRef ref, CategoryCardLearningUiState uiState, Color themeColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AnswerSheetDrawer(
        totalWords: uiState.words.length,
        currentIndex: uiState.currentWordIndex,
        canGoBack: uiState.canGoBack,
        themeColor: themeColor,
        onWordSelected: (seq) {
          ref.read(categoryCardLearningNotifierProvider(categoryId).notifier).jumpToWord(seq);
          Navigator.pop(context);
        },
        onGoBack: () {
          ref.read(categoryCardLearningNotifierProvider(categoryId).notifier).goBack();
        },
      ),
    );
  }

  void _showTypingDialog(BuildContext context, WidgetRef ref, WordEntry word, Color themeColor) {
    showTypingPracticeDialog(context, ref, word: word, themeColor: themeColor);
  }

  Color _getThemeColorForCategory(String categoryId, bool isDark) {
    switch (categoryId) {
      case 'verb': return isDark ? NemoCategoryColors.cardVerbTextDark : NemoCategoryColors.cardVerbTextLight;
      case 'noun': return isDark ? NemoCategoryColors.cardNounTextDark : NemoCategoryColors.cardNounTextLight;
      case 'adj': return isDark ? NemoCategoryColors.cardAdjITextDark : NemoCategoryColors.cardAdjITextLight;
      case 'adv': return isDark ? NemoCategoryColors.cardAdvTextDark : NemoCategoryColors.cardAdvTextLight;
      case 'kata': return isDark ? NemoCategoryColors.cardKataTextDark : NemoCategoryColors.cardKataTextLight;
      case 'particle': return isDark ? NemoCategoryColors.cardFixTextDark : NemoCategoryColors.cardFixTextLight;
      case 'expression': return isDark ? NemoCategoryColors.cardKeigoTextDark : NemoCategoryColors.cardKeigoTextLight;
      case 'rentai': return isDark ? NemoCategoryColors.cardRentaiTextDark : NemoCategoryColors.cardRentaiTextLight;
      case 'conj': return isDark ? NemoCategoryColors.cardConjTextDark : NemoCategoryColors.cardConjTextLight;
      case 'exclam': return isDark ? NemoCategoryColors.cardIdiomTextDark : NemoCategoryColors.cardIdiomTextLight;
      case 'prefix': return isDark ? NemoCategoryColors.cardKataTextDark : NemoCategoryColors.cardKataTextLight;
      case 'suffix': return isDark ? NemoCategoryColors.cardSoundTextDark : NemoCategoryColors.cardSoundTextLight;
      default: return NemoColors.brandBlue;
    }
  }
}

class _CategoryFlipCard extends ConsumerWidget {
  const _CategoryFlipCard({
    required this.word,
    required this.isFlipped,
    required this.onFlip,
    required this.themeColor,
    required this.categoryId,
  });

  final WordEntry word;
  final bool isFlipped;
  final VoidCallback onFlip;
  final Color themeColor;
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch examples from DB
    final examplesAsync = ref.watch(wordWithExamplesProvider(word.id));

    return examplesAsync.when(
      data: (data) {
        final examples = data?.examples.map((e) => {'japanese': e.japanese, 'chinese': e.chinese}).toList() ?? [];
        return NemoFlipCard(
          japanese: word.japanese,
          hiragana: word.hiragana,
          meaning: word.chinese,
          examples: List<Map<String, String>>.from(examples),
          themeColor: themeColor,
          isFlipped: isFlipped,
          onFlip: onFlip,
          onSpeak: () {}, // TODO: Implement TTS
          categoryId: categoryId,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('加载例句失败: $e')),
    );
  }
}

class _CategoryCardActionButtons extends StatelessWidget {
  const _CategoryCardActionButtons({
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onPractice,
    required this.onNext,
    required this.themeColor,
  });

  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onPractice;
  final VoidCallback onNext;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          _TintedSquircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            enabled: hasPrevious,
            onClick: onPrevious,
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
                onPressed: onPractice,
                child: const Text(
                  '跟打练习',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _TintedSquircleIconButton(
            icon: Icons.arrow_forward_ios_rounded,
            enabled: hasNext,
            onClick: onNext,
            themeColor: themeColor,
          ),
        ],
      ),
    );
  }
}

class _TintedSquircleIconButton extends StatelessWidget {
  const _TintedSquircleIconButton({
    required this.icon,
    required this.enabled,
    required this.onClick,
    required this.themeColor,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onClick;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
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
          icon,
          color: enabled ? themeColor : Colors.grey.withValues(alpha: 0.5),
          size: 24,
        ),
        onPressed: enabled ? onClick : null,
      ),
    );
  }
}

class _AnswerSheetDrawer extends StatelessWidget {
  const _AnswerSheetDrawer({
    required this.totalWords,
    required this.currentIndex,
    required this.canGoBack,
    required this.themeColor,
    required this.onWordSelected,
    required this.onGoBack,
  });

  final int totalWords;
  final int currentIndex;
  final bool canGoBack;
  final Color themeColor;
  final Function(int) onWordSelected;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '编号列表',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _SmallIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      enabled: canGoBack,
                      onPressed: onGoBack,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '当前 ${currentIndex + 1}',
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: totalWords,
              itemBuilder: (context, index) {
                final isActive = index == currentIndex;
                return InkWell(
                  onTap: () => onWordSelected(index + 1),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive ? themeColor : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      gradient: isActive
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [themeColor, themeColor.withValues(alpha: 0.7)],
                            )
                          : null,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black87,
                        fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
                        fontSize: 16,
                      ),
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

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: enabled ? Colors.grey.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14),
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
