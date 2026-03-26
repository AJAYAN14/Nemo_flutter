import 'dart:async';
import 'dart:ui';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum QuestionSource {
  wrong('wrong'),
  favorite('favorite'),
  today('today'),
  todayReviewed('today_reviewed'),
  learned('learned'),
  all('all');

  const QuestionSource(this.key);
  final String key;

  static QuestionSource fromKey(String key) {
    return QuestionSource.values.firstWhere((e) => e.key == key, orElse: () => QuestionSource.all);
  }

  String get label {
    switch (this) {
      case QuestionSource.wrong: return '我的错题';
      case QuestionSource.favorite: return '我的收藏';
      case QuestionSource.today: return '今日学习';
      case QuestionSource.todayReviewed: return '今日复习';
      case QuestionSource.learned: return '所有已学';
      case QuestionSource.all: return '所有内容';
    }
  }
}

enum TestContentType {
  words('words'),
  grammar('grammar'),
  mixed('mixed');

  const TestContentType(this.key);
  final String key;

  static TestContentType fromKey(String key) {
    return TestContentType.values.firstWhere((e) => e.key == key, orElse: () => TestContentType.words);
  }

  String get label {
    switch (this) {
      case TestContentType.words: return '仅单词';
      case TestContentType.grammar: return '仅语法';
      case TestContentType.mixed: return '单词/语法混合';
    }
  }
}

enum MessageType { info, success, warning, error }
enum MessagePriority { low, medium, high }

class UIMessage {
  final int id;
  final String message;
  final MessageType type;
  final MessagePriority priority;
  final String? actionLabel;
  final VoidCallback? onAction;

  UIMessage({
    required this.id,
    required this.message,
    this.type = MessageType.info,
    this.priority = MessagePriority.low,
    this.actionLabel,
    this.onAction,
  });
}

class TestSettingsUiState {
  final TestConfig config;
  final int todayLearnedCount;
  final int todayLearnedGrammarCount;
  final (int, int)? availableDataCount;
  final bool isLoadingDataCount;
  final String? error;
  final List<UIMessage> messages;

  TestSettingsUiState({
    required this.config,
    this.todayLearnedCount = 0,
    this.todayLearnedGrammarCount = 0,
    this.availableDataCount,
    this.isLoadingDataCount = false,
    this.error,
    this.messages = const [],
  });

  TestSettingsUiState copyWith({
    TestConfig? config,
    int? todayLearnedCount,
    int? todayLearnedGrammarCount,
    (int, int)? availableDataCount,
    bool? isLoadingDataCount,
    String? error,
    List<UIMessage>? messages,
  }) {
    return TestSettingsUiState(
      config: config ?? this.config,
      todayLearnedCount: todayLearnedCount ?? this.todayLearnedCount,
      todayLearnedGrammarCount: todayLearnedGrammarCount ?? this.todayLearnedGrammarCount,
      availableDataCount: availableDataCount ?? this.availableDataCount,
      isLoadingDataCount: isLoadingDataCount ?? this.isLoadingDataCount,
      error: error ?? this.error,
      messages: messages ?? this.messages,
    );
  }
}

class TestConfig {
  final int questionCount;
  final int timeLimitMinutes;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final bool autoAdvance;
  final bool prioritizeWrong;
  final bool prioritizeNew;
  final QuestionSource questionSource;
  final int wrongAnswerRemovalThreshold;
  final TestContentType testContentType;
  final List<String> selectedWordLevels;
  final List<String> selectedGrammarLevels;
  final Map<String, int> comprehensiveQuestionCounts;

  TestConfig({
    this.questionCount = 20,
    this.timeLimitMinutes = 0,
    this.shuffleQuestions = true,
    this.shuffleOptions = true,
    this.autoAdvance = false,
    this.prioritizeWrong = true,
    this.prioritizeNew = false,
    this.questionSource = QuestionSource.all,
    this.wrongAnswerRemovalThreshold = 0,
    this.testContentType = TestContentType.words,
    this.selectedWordLevels = const ['N5', 'N4', 'N3', 'N2', 'N1'],
    this.selectedGrammarLevels = const ['N5', 'N4', 'N3', 'N2', 'N1'],
    this.comprehensiveQuestionCounts = const {
      'multiple_choice': 20,
      'typing': 0,
      'card_matching': 0,
      'sorting': 0,
    },
  });

  TestConfig copyWith({
    int? questionCount,
    int? timeLimitMinutes,
    bool? shuffleQuestions,
    bool? shuffleOptions,
    bool? autoAdvance,
    bool? prioritizeWrong,
    bool? prioritizeNew,
    QuestionSource? questionSource,
    int? wrongAnswerRemovalThreshold,
    TestContentType? testContentType,
    List<String>? selectedWordLevels,
    List<String>? selectedGrammarLevels,
    Map<String, int>? comprehensiveQuestionCounts,
  }) {
    return TestConfig(
      questionCount: questionCount ?? this.questionCount,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      shuffleOptions: shuffleOptions ?? this.shuffleOptions,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      prioritizeWrong: prioritizeWrong ?? this.prioritizeWrong,
      prioritizeNew: prioritizeNew ?? this.prioritizeNew,
      questionSource: questionSource ?? this.questionSource,
      wrongAnswerRemovalThreshold: wrongAnswerRemovalThreshold ?? this.wrongAnswerRemovalThreshold,
      testContentType: testContentType ?? this.testContentType,
      selectedWordLevels: selectedWordLevels ?? this.selectedWordLevels,
      selectedGrammarLevels: selectedGrammarLevels ?? this.selectedGrammarLevels,
      comprehensiveQuestionCounts: comprehensiveQuestionCounts ?? this.comprehensiveQuestionCounts,
    );
  }
}

class TestSettingsNotifier extends Notifier<TestSettingsUiState> {
  String? _currentModeId;
  Timer? _refreshTimer;

  @override
  TestSettingsUiState build() {
    ref.onDispose(() => _refreshTimer?.cancel());
    
    // Start periodic refresh
    _startRefreshingTodayCounts();
    
    return TestSettingsUiState(config: TestConfig());
  }

  void _startRefreshingTodayCounts() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) => refreshTodayCounts());
    // Initial fetch
    Future.microtask(() => refreshTodayCounts());
  }

  void refreshTodayCounts() {
    // Mocking the repository call
    state = state.copyWith(
      todayLearnedCount: 15,
      todayLearnedGrammarCount: 8,
    );
  }

  void initMode(String? modeId) {
    if (_currentModeId == modeId) return;
    _currentModeId = modeId;
    _enforceConstraints();
    queryAvailableDataCount();
  }

  void _enforceConstraints() {
    var config = state.config;
    bool changed = false;

    // 1. Content Type Constraints
    if (_currentModeId == 'typing' || _currentModeId == 'card_matching' || _currentModeId == 'sorting') {
      if (config.testContentType != TestContentType.words) {
        config = config.copyWith(testContentType: TestContentType.words);
        changed = true;
      }
    } else if (_currentModeId == 'comprehensive') {
      if (config.testContentType == TestContentType.grammar) {
        config = config.copyWith(testContentType: TestContentType.mixed);
        changed = true;
        showMessage(message: "综合测试不支持仅测试语法，已自动调整", type: MessageType.info);
      }
    }

    // 2. Question Counts Constraints
    final targetCounts = _getTargetCountsForMode(_currentModeId, config.questionCount);
    if (targetCounts != null && config.comprehensiveQuestionCounts != targetCounts) {
      config = config.copyWith(comprehensiveQuestionCounts: targetCounts);
      changed = true;
    }

    if (changed) {
      state = state.copyWith(config: config);
    }
  }

  Map<String, int>? _getTargetCountsForMode(String? mode, int total) {
    switch (mode) {
      case 'typing':
        return {'multiple_choice': 0, 'typing': total, 'card_matching': 0, 'sorting': 0};
      case 'multiple_choice':
        return {'multiple_choice': total, 'typing': 0, 'card_matching': 0, 'sorting': 0};
      case 'card_matching':
        return {'multiple_choice': 0, 'typing': 0, 'card_matching': total, 'sorting': 0};
      case 'sorting':
        return {'multiple_choice': 0, 'typing': 0, 'card_matching': 0, 'sorting': total};
      default:
        return null;
    }
  }

  void update(TestConfig newConfig) {
    state = state.copyWith(config: newConfig);
    _enforceConstraints();
    queryAvailableDataCount();
  }

  void toggleLevel(String level, bool isGrammar) {
    final current = isGrammar ? state.config.selectedGrammarLevels : state.config.selectedWordLevels;
    final next = current.contains(level)
        ? current.where((l) => l != level).toList()
        : [...current, level];
    
    if (isGrammar) {
      update(state.config.copyWith(selectedGrammarLevels: next));
    } else {
      update(state.config.copyWith(selectedWordLevels: next));
    }
  }

  void exclusiveSelectLevel(String level, bool isGrammar) {
    if (isGrammar) {
      update(state.config.copyWith(selectedGrammarLevels: [level]));
    } else {
      update(state.config.copyWith(selectedWordLevels: [level]));
    }
  }

  void toggleAllLevels(bool isGrammar) {
    final all = ['N5', 'N4', 'N3', 'N2', 'N1'];
    final current = isGrammar ? state.config.selectedGrammarLevels : state.config.selectedWordLevels;
    final next = current.length == all.length ? <String>[] : all;

    if (isGrammar) {
      update(state.config.copyWith(selectedGrammarLevels: next));
    } else {
      update(state.config.copyWith(selectedWordLevels: next));
    }
  }

  Future<void> queryAvailableDataCount() async {
    state = state.copyWith(isLoadingDataCount: true);
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoadingDataCount: false,
      availableDataCount: (1200, 150),
    );
  }

  void showMessage({required String message, MessageType type = MessageType.info}) {
    final newMessage = UIMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      message: message,
      type: type,
    );
    state = state.copyWith(messages: [...state.messages, newMessage]);
  }

  void dismissMessage(int id) {
    state = state.copyWith(messages: state.messages.where((m) => m.id != id).toList());
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final testSettingsProvider = NotifierProvider<TestSettingsNotifier, TestSettingsUiState>(TestSettingsNotifier.new);
