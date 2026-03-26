import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../mock/learning_mock_data.dart';

class LearningUiModel {
  const LearningUiModel({
    required this.items,
    required this.currentIndex,
    required this.revealedItemIds,
    this.isCompleted = false,
  });

  final List<LearningItem> items;
  final int currentIndex;
  final Set<String> revealedItemIds;
  final bool isCompleted;

  String get currentId {
    final item = items[currentIndex];
    if (item is WordItem) return item.word.id;
    if (item is GrammarItem) return item.grammar.id.toString();
    return '';
  }

  bool isRevealed(String id) => revealedItemIds.contains(id);

  double get progress {
    if (items.isEmpty) return 0;
    return (currentIndex + 1) / items.length;
  }

  LearningUiModel copyWith({
    List<LearningItem>? items,
    int? currentIndex,
    Set<String>? revealedItemIds,
    bool? isCompleted,
  }) {
    return LearningUiModel(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      revealedItemIds: revealedItemIds ?? this.revealedItemIds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static const LearningUiModel initial = LearningUiModel(
    items: mockLearningItems,
    currentIndex: 0,
    revealedItemIds: <String>{},
    isCompleted: false,
  );
}

class LearningNotifier extends Notifier<LearningUiModel> {
  @override
  LearningUiModel build() => LearningUiModel.initial;

  void onPageChanged(int index) {
    if (index < 0 || index >= state.items.length) {
      return;
    }
    state = state.copyWith(currentIndex: index);
  }

  void toggleReveal(String id) {
    final next = <String>{...state.revealedItemIds};
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(revealedItemIds: next);
  }

  void onRate(int score) {
    if (state.isCompleted) return;

    final isLast = state.currentIndex == state.items.length - 1;
    if (isLast) {
      state = state.copyWith(isCompleted: true);
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
      );
    }
  }
}

final learningProvider = NotifierProvider<LearningNotifier, LearningUiModel>(
  LearningNotifier.new,
);
