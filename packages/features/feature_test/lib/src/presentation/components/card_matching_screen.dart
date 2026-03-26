import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MatchCardModel {
  const MatchCardModel({
    required this.id,
    required this.text,
    required this.pairId,
    this.isMatched = false,
  });
  final String id;
  final String text;
  final String pairId;
  final bool isMatched;

  MatchCardModel copyWith({bool? isMatched}) {
    return MatchCardModel(
      id: id,
      text: text,
      pairId: pairId,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

class MatchGameState {
  const MatchGameState({required this.cards, this.selectedIndex});
  final List<MatchCardModel> cards;
  final int? selectedIndex;

  MatchGameState copyWith({List<MatchCardModel>? cards, int? selectedIndex, bool clearSelection = false}) {
    return MatchGameState(
      cards: cards ?? this.cards,
      selectedIndex: clearSelection ? null : (selectedIndex ?? this.selectedIndex),
    );
  }
}

class MatchGameStateNotifier extends Notifier<MatchGameState> {
  @override
  MatchGameState build() {
    // 3 pairs = 6 cards, duplicate for 12 cards total? 3x4 = 12 cards = 6 pairs.
    return const MatchGameState(cards: [
      MatchCardModel(id: '1', text: '挑戦', pairId: 'A'),
      MatchCardModel(id: '2', text: '习惯', pairId: 'B'),
      MatchCardModel(id: '3', text: 'ちょうせん', pairId: 'A'),
      MatchCardModel(id: '4', text: '全部', pairId: 'C'),
      MatchCardModel(id: '5', text: 'ぜんぶ', pairId: 'C'),
      MatchCardModel(id: '6', text: '偶然', pairId: 'D'),
      MatchCardModel(id: '7', text: 'ぐうぜん', pairId: 'D'),
      MatchCardModel(id: '8', text: '習慣', pairId: 'B'),
      MatchCardModel(id: '9', text: '安全', pairId: 'E'),
      MatchCardModel(id: '10', text: 'あんぜん', pairId: 'E'),
      MatchCardModel(id: '11', text: '旅行', pairId: 'F'),
      MatchCardModel(id: '12', text: 'りょこう', pairId: 'F'),
    ]);
  }

  void selectCard(int index) {
    if (state.cards[index].isMatched) return;

    final selectedIndex = state.selectedIndex;

    if (selectedIndex == null) {
      state = state.copyWith(selectedIndex: index);
      return;
    }

    if (selectedIndex == index) {
      // Deselect
      state = state.copyWith(clearSelection: true);
      return;
    }

    final card1 = state.cards[selectedIndex];
    final card2 = state.cards[index];

    if (card1.pairId == card2.pairId) {
      // Match!
      final newCards = List<MatchCardModel>.from(state.cards);
      newCards[selectedIndex] = card1.copyWith(isMatched: true);
      newCards[index] = card2.copyWith(isMatched: true);
      state = MatchGameState(cards: newCards, selectedIndex: null);
    } else {
      // Mismatch, simply clear selection for now.
      // A full implementation would show a red shake animation here.
      state = state.copyWith(clearSelection: true);
    }
  }
}

final matchGameStateProvider = NotifierProvider<MatchGameStateNotifier, MatchGameState>(MatchGameStateNotifier.new);

class CardMatchingScreen extends HookConsumerWidget {
  const CardMatchingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(matchGameStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Text(
            '消除意思相同的卡片',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: NemoColors.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: gameState.cards.length,
              itemBuilder: (context, index) {
                final card = gameState.cards[index];
                final isSelected = gameState.selectedIndex == index;

                return AnimatedOpacity(
                  opacity: card.isMatched ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: card.isMatched,
                    child: GestureDetector(
                      onTap: () => ref.read(matchGameStateProvider.notifier).selectCard(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? NemoColors.brandBlue.withValues(alpha: 0.1) : Colors.white,
                          borderRadius: NemoMetrics.radius(16),
                          border: Border.all(
                            color: isSelected ? NemoColors.brandBlue : NemoColors.borderLight,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          card.text,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isSelected ? NemoColors.brandBlue : NemoColors.textMain,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
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
