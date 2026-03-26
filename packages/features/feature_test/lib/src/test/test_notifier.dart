import 'dart:async';
import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'test_notifier.freezed.dart';

@freezed
class TestState with _$TestState {
  const factory TestState({
    @Default([]) List<TestQuestion> questions,
    @Default(0) int currentIndex,
    @Default(false) bool isLoading,
    @Default(false) bool isTestActive,
    @Default(false) bool showResult,
    TestResult? testResult,
    @Default(-1) int selectedOptionIndex,
    String? error,
    @Default(0) int timeRemainingSeconds,
    @Default(0) int timeLimitSeconds,
    @Default(false) bool isAutoAdvancing,
    @Default('') String userTypingInput,
    DateTime? testStartTime,
    // Card Matching State
    String? selectedCardId,
    @Default([]) List<String> matchedCardIds,
    @Default(false) bool isMatchError,
    @Default(0) int matchErrorCount,
    @Default([]) List<SortableChar> userSortableAnswer,
  }) = _TestState;

  const TestState._();

  TestQuestion? get currentQuestion =>
      questions.isNotEmpty && currentIndex < questions.length ? questions[currentIndex] : null;

  bool get isLastQuestion => currentIndex == questions.length - 1;
}

class TestNotifier extends Notifier<TestState> {
  @override
  TestState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const TestState();
  }

  Timer? _timer;

  void startTest({
    required List<TestQuestion> questions,
    int timeLimitMinutes = 0,
  }) {
    _timer?.cancel();
    
    state = state.copyWith(
      questions: questions,
      currentIndex: 0,
      isTestActive: true,
      showResult: false,
      testResult: null,
      selectedOptionIndex: -1,
      timeLimitSeconds: timeLimitMinutes * 60,
      timeRemainingSeconds: timeLimitMinutes * 60,
      testStartTime: DateTime.now(),
    );

    if (timeLimitMinutes > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemainingSeconds <= 0) {
        timer.cancel();
        finishTest();
      } else {
        state = state.copyWith(
          timeRemainingSeconds: state.timeRemainingSeconds - 1,
        );
      }
    });
  }

  void selectOption(int index) {
    if (state.currentQuestion?.isAnswered ?? true) return;
    state = state.copyWith(selectedOptionIndex: index);
  }

  void onTypingInputChange(String value) {
    if (state.currentQuestion?.isAnswered ?? true) return;
    state = state.copyWith(userTypingInput: value);
  }

  void submitAnswer() {
    final question = state.currentQuestion;
    if (question == null || question.isAnswered || !state.isTestActive) return;

    bool isCorrect = false;
    String? finalUserAnswer;
    int? selectedIndex;

    if (question.type == QuestionType.multipleChoice) {
      if (state.selectedOptionIndex == -1) return;
      isCorrect = question.options[state.selectedOptionIndex] == question.correctAnswer;
      selectedIndex = state.selectedOptionIndex;
      finalUserAnswer = question.options[state.selectedOptionIndex];
    } else if (question.type == QuestionType.typing) {
      if (state.userTypingInput.trim().isEmpty) return;
      // Normalizing input for Japanese (simple trim for now, could be smarter)
      finalUserAnswer = state.userTypingInput.trim();
    } else if (question.type == QuestionType.sorting) {
      if (state.userSortableAnswer.isEmpty) return;
      finalUserAnswer = state.userSortableAnswer.map((c) => c.char).join();
      isCorrect = finalUserAnswer == question.correctAnswer;
    }

    final updatedQuestion = question.copyWith(
      isAnswered: true,
      isCorrect: isCorrect,
      userAnswerIndex: selectedIndex,
      userAnswer: finalUserAnswer,
    );

    final updatedQuestions = [...state.questions];
    updatedQuestions[state.currentIndex] = updatedQuestion;

    state = state.copyWith(questions: updatedQuestions);

    // Auto advance if correct and enabled
    if (isCorrect && !state.isLastQuestion) {
      _autoAdvance();
    }
    
    // Reset sorting and typing input after submission
    state = state.copyWith(
      userTypingInput: '',
      userSortableAnswer: [],
    );
  }

  void selectSortableChar(SortableChar char) {
    if (state.currentQuestion?.isAnswered ?? true) return;
    
    final question = state.currentQuestion;
    if (question == null || question.type != QuestionType.sorting) return;

    final updatedOptions = question.sortingOptions.map((c) {
      if (c.id == char.id) {
        return c.copyWith(isSelected: true);
      }
      return c;
    }).toList();

    final updatedQuestion = question.copyWith(sortingOptions: updatedOptions);
    final updatedQuestions = [...state.questions];
    updatedQuestions[state.currentIndex] = updatedQuestion;

    state = state.copyWith(
      questions: updatedQuestions,
      userSortableAnswer: [...state.userSortableAnswer, char.copyWith(isSelected: true)],
    );
  }

  void deselectSortableChar(SortableChar char) {
    if (state.currentQuestion?.isAnswered ?? true) return;

    final question = state.currentQuestion;
    if (question == null || question.type != QuestionType.sorting) return;

    final updatedOptions = question.sortingOptions.map((c) {
      if (c.id == char.id) {
        return c.copyWith(isSelected: false);
      }
      return c;
    }).toList();

    final updatedQuestion = question.copyWith(sortingOptions: updatedOptions);
    final updatedQuestions = [...state.questions];
    updatedQuestions[state.currentIndex] = updatedQuestion;

    state = state.copyWith(
      questions: updatedQuestions,
      userSortableAnswer: state.userSortableAnswer.where((c) => c.id != char.id).toList(),
    );
  }

  void selectCard(String cardId) {
    if (state.matchedCardIds.contains(cardId)) return;

    if (state.selectedCardId == null) {
      state = state.copyWith(
        selectedCardId: cardId,
        isMatchError: false,
      );
      return;
    }

    if (state.selectedCardId == cardId) {
      state = state.copyWith(selectedCardId: null);
      return;
    }

    // Try to match
    final firstId = state.selectedCardId!;
    final firstParts = firstId.split('_');
    final secondParts = cardId.split('_');

    if (firstParts.length < 2 || secondParts.length < 2) return;

    final isSameType = firstParts[0] == secondParts[0];
    final isMatch = !isSameType && firstParts[1] == secondParts[1];

    if (isMatch) {
      final newMatched = [...state.matchedCardIds, firstId, cardId];
      state = state.copyWith(
        selectedCardId: null,
        matchedCardIds: newMatched,
        isMatchError: false,
      );
    } else {
      // Incorrect match
      state = state.copyWith(
        isMatchError: true,
        matchErrorCount: state.matchErrorCount + 1,
        selectedCardId: cardId, 
      );
    }
  }

  Future<void> _autoAdvance() async {
    state = state.copyWith(isAutoAdvancing: true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (state.isAutoAdvancing) {
      nextQuestion();
      state = state.copyWith(isAutoAdvancing: false);
    }
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedOptionIndex: -1,
        userTypingInput: '',
        selectedCardId: null,
        matchedCardIds: [],
        isMatchError: false,
        matchErrorCount: 0,
        userSortableAnswer: [],
      );
    } else {
      finishTest();
    }
  }

  void nextMatchSet() => nextQuestion();

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        selectedOptionIndex: -1,
        userTypingInput: '',
        userSortableAnswer: [],
      );
    }
  }

  void finishTest() {
    _timer?.cancel();
    final result = TestResult.calculate(
      questions: state.questions,
      startTime: state.testStartTime ?? DateTime.now(),
      endTime: DateTime.now(),
    );

    state = state.copyWith(
      isTestActive: false,
      showResult: true,
      testResult: result,
    );
  }
}

final testProvider = NotifierProvider<TestNotifier, TestState>(TestNotifier.new);
