import 'dart:async';
import 'package:core_storage/core_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_material_browser_providers.g.dart';

enum SlideDirection {
  forward, // 下一个
  backward, // 上一个
}

class CategoryMaterialBrowserUiState {
  const CategoryMaterialBrowserUiState({
    this.isLoading = true,
    this.words = const [],
    this.currentWordIndex = 0,
    this.isFlipped = false,
    this.isProcessingClick = false,
    this.slideDirection = SlideDirection.forward,
    this.error,
    this.navigationHistory = const [],
  });

  final bool isLoading;
  final List<WordEntry> words;
  final int currentWordIndex;
  final bool isFlipped;
  final bool isProcessingClick;
  final SlideDirection slideDirection;
  final String? error;
  final List<int> navigationHistory;

  WordEntry? get currentWord => words.isEmpty ? null : words[currentWordIndex];
  bool get hasNext => currentWordIndex < words.length - 1;
  bool get hasPrevious => currentWordIndex > 0;
  bool get canGoBack => navigationHistory.isNotEmpty;

  CategoryMaterialBrowserUiState copyWith({
    bool? isLoading,
    List<WordEntry>? words,
    int? currentWordIndex,
    bool? isFlipped,
    bool? isProcessingClick,
    SlideDirection? slideDirection,
    String? error,
    List<int>? navigationHistory,
  }) {
    return CategoryMaterialBrowserUiState(
      isLoading: isLoading ?? this.isLoading,
      words: words ?? this.words,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      isProcessingClick: isProcessingClick ?? this.isProcessingClick,
      slideDirection: slideDirection ?? this.slideDirection,
      error: error ?? this.error,
      navigationHistory: navigationHistory ?? this.navigationHistory,
    );
  }
}

@riverpod
class CategoryMaterialBrowserNotifier extends _$CategoryMaterialBrowserNotifier {
  @override
  CategoryMaterialBrowserUiState build(String categoryId) {
    // Watch the words stream and update the state accordingly
    final wordsAsync = ref.watch(wordsByCategoryProvider(categoryId));

    return wordsAsync.when(
      data: (words) => CategoryMaterialBrowserUiState(
        isLoading: false,
        words: words,
        // Preserve current state if we're just updating the list
        currentWordIndex: stateOrNull?.currentWordIndex ?? 0,
        navigationHistory: stateOrNull?.navigationHistory ?? [0],
      ),
      loading: () => const CategoryMaterialBrowserUiState(isLoading: true),
      error: (e, _) => CategoryMaterialBrowserUiState(isLoading: false, error: e.toString()),
    );
  }

  CategoryMaterialBrowserUiState? get stateOrNull {
    try {
      return state;
    } catch (_) {
      return null;
    }
  }

  void flipCard() {
    if (state.isProcessingClick) return;
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  void nextWord() {
    if (state.currentWordIndex < state.words.length - 1 && !state.isProcessingClick) {
      final newIndex = state.currentWordIndex + 1;
      final newHistory = [...state.navigationHistory, state.currentWordIndex];
      
      state = state.copyWith(
        currentWordIndex: newIndex,
        isFlipped: false,
        isProcessingClick: true,
        slideDirection: SlideDirection.forward,
        navigationHistory: newHistory,
      );

      _resetProcessingState();
    }
  }

  void previousWord() {
    if (state.currentWordIndex > 0 && !state.isProcessingClick) {
      final newIndex = state.currentWordIndex - 1;
      final newHistory = [...state.navigationHistory, state.currentWordIndex];

      state = state.copyWith(
        currentWordIndex: newIndex,
        isFlipped: false,
        isProcessingClick: true,
        slideDirection: SlideDirection.backward,
        navigationHistory: newHistory,
      );

      _resetProcessingState();
    }
  }

  void jumpToWord(int sequenceNumber) {
    final targetIndex = sequenceNumber - 1;
    if (targetIndex >= 0 && targetIndex < state.words.length && !state.isProcessingClick) {
      final direction = targetIndex > state.currentWordIndex ? SlideDirection.forward : SlideDirection.backward;
      final newHistory = [...state.navigationHistory, state.currentWordIndex];

      state = state.copyWith(
        currentWordIndex: targetIndex,
        isFlipped: false,
        isProcessingClick: true,
        slideDirection: direction,
        navigationHistory: newHistory,
       );

      _resetProcessingState();
    }
  }

  void goBack() {
    if (state.canGoBack && !state.isProcessingClick) {
      final newHistory = List<int>.from(state.navigationHistory);
      final lastIndex = newHistory.removeLast();

      state = state.copyWith(
        currentWordIndex: lastIndex,
        isFlipped: false,
        isProcessingClick: true,
        slideDirection: SlideDirection.backward,
        navigationHistory: newHistory,
      );

      _resetProcessingState();
    }
  }

  void _resetProcessingState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      try {
        state = state.copyWith(isProcessingClick: false);
      } catch (_) {}
    });
  }
}
