import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mock/typing_practice_mock_data.dart';

typedef CloseCallback = void Function();

enum TypingFeedback {
  hidden,
  correct,
  incorrect,
}

class TypingPracticeState {
  const TypingPracticeState({
    required this.kanaInput,
    required this.kanjiInput,
    required this.feedback,
  });

  final String kanaInput;
  final String kanjiInput;
  final TypingFeedback feedback;

  bool get canSubmit => kanaInput.trim().isNotEmpty && kanjiInput.trim().isNotEmpty;

  TypingPracticeState copyWith({
    String? kanaInput,
    String? kanjiInput,
    TypingFeedback? feedback,
  }) {
    return TypingPracticeState(
      kanaInput: kanaInput ?? this.kanaInput,
      kanjiInput: kanjiInput ?? this.kanjiInput,
      feedback: feedback ?? this.feedback,
    );
  }

  static const TypingPracticeState initial = TypingPracticeState(
    kanaInput: '',
    kanjiInput: '',
    feedback: TypingFeedback.hidden,
  );
}

class TypingPracticeNotifier extends Notifier<TypingPracticeState> {
  Timer? _closeDelayTimer;

  @override
  TypingPracticeState build() {
    ref.onDispose(() {
      _closeDelayTimer?.cancel();
    });
    return TypingPracticeState.initial;
  }

  void updateKanaInput(String value) {
    state = state.copyWith(
      kanaInput: value,
      feedback: state.feedback == TypingFeedback.incorrect
          ? TypingFeedback.hidden
          : state.feedback,
    );
  }

  void updateKanjiInput(String value) {
    state = state.copyWith(
      kanjiInput: value,
      feedback: state.feedback == TypingFeedback.incorrect
          ? TypingFeedback.hidden
          : state.feedback,
    );
  }

  void clear() {
    state = TypingPracticeState.initial;
  }

  void validate({
    required TypingPracticePrompt prompt,
    required CloseCallback onClose,
  }) {
    final kanaOk = state.kanaInput.trim() == prompt.hiragana;
    final kanjiOk = state.kanjiInput.trim() == prompt.japanese;

    if (kanaOk && kanjiOk) {
      state = state.copyWith(feedback: TypingFeedback.correct);
      _closeDelayTimer?.cancel();
      _closeDelayTimer = Timer(const Duration(milliseconds: 1200), onClose);
      return;
    }

    state = state.copyWith(feedback: TypingFeedback.incorrect);
  }
}

final typingPracticePromptProvider = Provider<TypingPracticePrompt>(
  (ref) => typingPracticeMockPrompt,
);

final typingPracticeProvider =
    NotifierProvider<TypingPracticeNotifier, TypingPracticeState>(
  TypingPracticeNotifier.new,
);
