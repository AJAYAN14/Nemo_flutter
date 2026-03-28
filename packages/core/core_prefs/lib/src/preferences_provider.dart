import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPrefs(SharedPrefsRef ref) async {
  return await SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
PreferenceService preferenceService(PreferenceServiceRef ref) {
  final prefs = ref.watch(sharedPrefsProvider).valueOrNull;
  if (prefs == null) throw Exception('SharedPreferences not initialized');
  return PreferenceService(prefs);
}

class PreferenceService {
  PreferenceService(this._prefs);
  final SharedPreferences _prefs;

  static const _keyWordGoal = 'daily_word_goal';
  static const _keyGrammarGoal = 'daily_grammar_goal';
  static const _keyWordLevel = 'word_level';
  static const _keyGrammarLevel = 'grammar_level';
  static const _keyDarkMode = 'dark_mode';
  static const _keyAutoSync = 'auto_sync';
  static const _keyResetHour = 'reset_hour';
  static const _keyRandomContent = 'random_content';
  static const _keyLastLearningMode = 'last_learning_mode';
  static const _keyLearnAheadLimit = 'learn_ahead_limit';
  static const _keyAutoSpeak = 'learning_auto_speak';
  static const _keyShowAnswerWait = 'learning_show_answer_wait';
  static const _keyAnswerWaitDuration = 'learning_answer_wait_duration';
  static const _keyTtsSpeed = 'tts_speed';
  static const _keyTtsPitch = 'tts_pitch';
  static const _keyTtsVoiceName = 'tts_voice_name';
  static const _keyLeechThreshold = 'leech_threshold';
  static const _keyLeechAction = 'leech_action';
  static const _keyLearningSteps = 'learning_steps';
  static const _keyRelearningSteps = 'relearning_steps';


  // Session keys
  static const _keyWordSessionIds = 'word_session_ids';
  static const _keyWordSessionIndex = 'word_session_index';
  static const _keyWordSessionLevel = 'word_session_level';
  static const _keyWordSessionSteps = 'word_session_steps';
  static const _keyWordSessionWaitingUntil = 'word_session_waiting_until';

  static const _keyGrammarSessionIds = 'grammar_session_ids';
  static const _keyGrammarSessionIndex = 'grammar_session_index';
  static const _keyGrammarSessionLevel = 'grammar_session_level';
  static const _keyGrammarSessionSteps = 'grammar_session_steps';
  static const _keyGrammarSessionWaitingUntil = 'grammar_session_waiting_until';

  int get wordGoal => _prefs.getInt(_keyWordGoal) ?? 20;
  Future<void> setWordGoal(int value) => _prefs.setInt(_keyWordGoal, value);

  int get grammarGoal => _prefs.getInt(_keyGrammarGoal) ?? 5;
  Future<void> setGrammarGoal(int value) => _prefs.setInt(_keyGrammarGoal, value);

  String get wordLevel => _prefs.getString(_keyWordLevel) ?? 'N5';
  Future<void> setWordLevel(String value) => _prefs.setString(_keyWordLevel, value);

  String get grammarLevel => _prefs.getString(_keyGrammarLevel) ?? 'N5';
  Future<void> setGrammarLevel(String value) => _prefs.setString(_keyGrammarLevel, value);

  int get darkMode => _prefs.getInt(_keyDarkMode) ?? 2; // 0=Light, 1=Dark, 2=System
  Future<void> setDarkMode(int value) => _prefs.setInt(_keyDarkMode, value);

  bool get autoSync => _prefs.getBool(_keyAutoSync) ?? true;
  Future<void> setAutoSync(bool value) => _prefs.setBool(_keyAutoSync, value);

  int get resetHour => _prefs.getInt(_keyResetHour) ?? 4;
  Future<void> setResetHour(int value) => _prefs.setInt(_keyResetHour, value);

  bool get randomContent => _prefs.getBool(_keyRandomContent) ?? false;
  Future<void> setRandomContent(bool value) => _prefs.setBool(_keyRandomContent, value);

  String get lastLearningMode => _prefs.getString(_keyLastLearningMode) ?? 'words';
  Future<void> setLastLearningMode(String value) => _prefs.setString(_keyLastLearningMode, value);

  int get learnAheadLimit => _prefs.getInt(_keyLearnAheadLimit) ?? 120;
  Future<void> setLearnAheadLimit(int value) => _prefs.setInt(_keyLearnAheadLimit, value);

  bool get autoSpeak => _prefs.getBool(_keyAutoSpeak) ?? true;
  Future<void> setAutoSpeak(bool value) => _prefs.setBool(_keyAutoSpeak, value);

  bool get showAnswerWait => _prefs.getBool(_keyShowAnswerWait) ?? false;
  Future<void> setShowAnswerWait(bool value) => _prefs.setBool(_keyShowAnswerWait, value);

  double get answerWaitDuration => _prefs.getDouble(_keyAnswerWaitDuration) ?? 1.0;
  Future<void> setAnswerWaitDuration(double value) => _prefs.setDouble(_keyAnswerWaitDuration, value);

  double getTtsSpeed() => _prefs.getDouble(_keyTtsSpeed) ?? 1.0;
  Future<void> setTtsSpeed(double value) => _prefs.setDouble(_keyTtsSpeed, value);

  double getTtsPitch() => _prefs.getDouble(_keyTtsPitch) ?? 1.0;
  Future<void> setTtsPitch(double value) => _prefs.setDouble(_keyTtsPitch, value);

  String? getTtsVoiceName() => _prefs.getString(_keyTtsVoiceName);
  Future<void> setTtsVoiceName(String? value) async {
    if (value == null) {
      await _prefs.remove(_keyTtsVoiceName);
    } else {
      await _prefs.setString(_keyTtsVoiceName, value);
    }
  }

  int get leechThreshold => _prefs.getInt(_keyLeechThreshold) ?? 5;
  Future<void> setLeechThreshold(int value) => _prefs.setInt(_keyLeechThreshold, value);

  String get leechAction => _prefs.getString(_keyLeechAction) ?? 'skip'; // 'skip' or 'bury'
  Future<void> setLeechAction(String value) => _prefs.setString(_keyLeechAction, value);

  String get learningSteps => _prefs.getString(_keyLearningSteps) ?? '1 10';
  Future<void> setLearningSteps(String value) => _prefs.setString(_keyLearningSteps, value);

  String get relearningSteps => _prefs.getString(_keyRelearningSteps) ?? '1 10';
  Future<void> setRelearningSteps(String value) => _prefs.setString(_keyRelearningSteps, value);

  // Word Session
  Future<void> saveWordSession(List<String> ids, int index, String level, String stepsJson, int waitingUntil) async {
    await _prefs.setStringList(_keyWordSessionIds, ids);
    await _prefs.setInt(_keyWordSessionIndex, index);
    await _prefs.setString(_keyWordSessionLevel, level);
    await _prefs.setString(_keyWordSessionSteps, stepsJson);
    await _prefs.setInt(_keyWordSessionWaitingUntil, waitingUntil);
  }

  Map<String, dynamic>? getWordSession() {
    final ids = _prefs.getStringList(_keyWordSessionIds);
    if (ids == null) return null;
    return {
      'ids': ids,
      'currentIndex': _prefs.getInt(_keyWordSessionIndex) ?? 0,
      'level': _prefs.getString(_keyWordSessionLevel) ?? '',
      'steps': _prefs.getString(_keyWordSessionSteps) ?? '{}',
      'waitingUntil': _prefs.getInt(_keyWordSessionWaitingUntil) ?? 0,
    };
  }

  Future<void> clearWordSession() async {
    await _prefs.remove(_keyWordSessionIds);
    await _prefs.remove(_keyWordSessionIndex);
    await _prefs.remove(_keyWordSessionLevel);
    await _prefs.remove(_keyWordSessionSteps);
    await _prefs.remove(_keyWordSessionWaitingUntil);
  }

  // Grammar Session
  Future<void> saveGrammarSession(List<String> ids, int index, String level, String stepsJson, int waitingUntil) async {
    await _prefs.setStringList(_keyGrammarSessionIds, ids);
    await _prefs.setInt(_keyGrammarSessionIndex, index);
    await _prefs.setString(_keyGrammarSessionLevel, level);
    await _prefs.setString(_keyGrammarSessionSteps, stepsJson);
    await _prefs.setInt(_keyGrammarSessionWaitingUntil, waitingUntil);
  }

  Map<String, dynamic>? getGrammarSession() {
    final ids = _prefs.getStringList(_keyGrammarSessionIds);
    if (ids == null) return null;
    return {
      'ids': ids,
      'currentIndex': _prefs.getInt(_keyGrammarSessionIndex) ?? 0,
      'level': _prefs.getString(_keyGrammarLevel) ?? '',
      'steps': _prefs.getString(_keyGrammarSessionSteps) ?? '{}',
      'waitingUntil': _prefs.getInt(_keyGrammarSessionWaitingUntil) ?? 0,
    };
  }

  Future<void> clearGrammarSession() async {
    await _prefs.remove(_keyGrammarSessionIds);
    await _prefs.remove(_keyGrammarSessionIndex);
    await _prefs.remove(_keyGrammarSessionLevel);
    await _prefs.remove(_keyGrammarSessionSteps);
    await _prefs.remove(_keyGrammarSessionWaitingUntil);
  }

  // Unified Session API
  List<String> getLearningSessionItems(String mode) {
    final key = mode == 'word' ? _keyWordSessionIds : _keyGrammarSessionIds;
    return _prefs.getStringList(key) ?? [];
  }

  int getLearningSessionIndex(String mode) {
    final key = mode == 'word' ? _keyWordSessionIndex : _keyGrammarSessionIndex;
    return _prefs.getInt(key) ?? 0;
  }

  Future<void> saveLearningSession({
    required String mode,
    required List<String> itemIds,
    required int currentIndex,
  }) async {
    if (mode == 'word') {
      await _prefs.setStringList(_keyWordSessionIds, itemIds);
      await _prefs.setInt(_keyWordSessionIndex, currentIndex);
    } else {
      await _prefs.setStringList(_keyGrammarSessionIds, itemIds);
      await _prefs.setInt(_keyGrammarSessionIndex, currentIndex);
    }
  }

  Future<void> clearLearningSession(String mode) async {
    if (mode == 'word') {
      await clearWordSession();
    } else {
      await clearGrammarSession();
    }
  }
}

@riverpod
class WordGoal extends _$WordGoal {
  @override
  int build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.wordGoal;
  }

  Future<void> set(int value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setWordGoal(value);
    ref.invalidateSelf();
  }
}

@riverpod
class GrammarGoal extends _$GrammarGoal {
  @override
  int build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.grammarGoal;
  }

  Future<void> set(int value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setGrammarGoal(value);
    ref.invalidateSelf();
  }
}

@riverpod
class WordLevel extends _$WordLevel {
  @override
  String build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.wordLevel;
  }

  Future<void> set(String value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setWordLevel(value);
    ref.invalidateSelf();
  }
}

@riverpod
class GrammarLevel extends _$GrammarLevel {
  @override
  String build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.grammarLevel;
  }

  Future<void> set(String value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setGrammarLevel(value);
    ref.invalidateSelf();
  }
}

@riverpod
class LastLearningMode extends _$LastLearningMode {
  @override
  String build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.lastLearningMode;
  }

  Future<void> set(String value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setLastLearningMode(value);
    ref.invalidateSelf();
  }
}

@riverpod
class DarkMode extends _$DarkMode {
  @override
  int build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.darkMode;
  }

  Future<void> set(int value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setDarkMode(value);
    ref.invalidateSelf();
  }
}

@riverpod
class AutoSync extends _$AutoSync {
  @override
  bool build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.autoSync;
  }

  Future<void> toggle(bool value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setAutoSync(value);
    ref.invalidateSelf();
  }
}

@riverpod
class ResetHour extends _$ResetHour {
  @override
  int build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.resetHour;
  }

  Future<void> set(int value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setResetHour(value);
    ref.invalidateSelf();
  }
}

@riverpod
class RandomContent extends _$RandomContent {
  @override
  bool build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.randomContent;
  }

  Future<void> toggle(bool value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setRandomContent(value);
    ref.invalidateSelf();
  }
}

@riverpod
class LearnAheadLimit extends _$LearnAheadLimit {
  @override
  int build() {
    final service = ref.watch(preferenceServiceProvider);
    return service.learnAheadLimit;
  }

  Future<void> set(int value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setLearnAheadLimit(value);
    ref.invalidateSelf();
  }
}

@riverpod
class AutoSpeak extends _$AutoSpeak {
  @override
  bool build() {
    return ref.watch(preferenceServiceProvider).autoSpeak;
  }

  Future<void> toggle() async {
    final service = ref.read(preferenceServiceProvider);
    await service.setAutoSpeak(!state);
    ref.invalidateSelf();
  }
}

@riverpod
class ShowAnswerWait extends _$ShowAnswerWait {
  @override
  bool build() {
    return ref.watch(preferenceServiceProvider).showAnswerWait;
  }

  Future<void> toggle() async {
    final service = ref.read(preferenceServiceProvider);
    await service.setShowAnswerWait(!state);
    ref.invalidateSelf();
  }
}

@riverpod
class AnswerWaitDuration extends _$AnswerWaitDuration {
  @override
  double build() {
    return ref.watch(preferenceServiceProvider).answerWaitDuration;
  }

  Future<void> set(double value) async {
    final service = ref.read(preferenceServiceProvider);
    await service.setAnswerWaitDuration(value);
    ref.invalidateSelf();
  }

  Future<void> cycle() async {
    final current = state;
    double next;
    if (current < 1.0) {
      next = 1.0;
    } else if (current < 1.5) {
      next = 1.5;
    } else if (current < 2.0) {
      next = 2.0;
    } else if (current < 3.0) {
      next = 3.0;
    } else if (current < 5.0) {
      next = 5.0;
    } else {
      next = 1.0;
    }
    await set(next);
  }
}

@riverpod
class LeechThreshold extends _$LeechThreshold {
  @override
  int build() {
    return ref.watch(preferenceServiceProvider).leechThreshold;
  }

  Future<void> set(int value) async {
    await ref.read(preferenceServiceProvider).setLeechThreshold(value);
    ref.invalidateSelf();
  }
}

@riverpod
class LeechAction extends _$LeechAction {
  @override
  String build() {
    return ref.watch(preferenceServiceProvider).leechAction;
  }

  Future<void> set(String value) async {
    await ref.read(preferenceServiceProvider).setLeechAction(value);
    ref.invalidateSelf();
  }
}

@riverpod
class LearningSteps extends _$LearningSteps {
  @override
  String build() {
    return ref.watch(preferenceServiceProvider).learningSteps;
  }

  Future<void> set(String value) async {
    await ref.read(preferenceServiceProvider).setLearningSteps(value);
    ref.invalidateSelf();
  }
}

@riverpod
class RelearningSteps extends _$RelearningSteps {
  @override
  String build() {
    return ref.watch(preferenceServiceProvider).relearningSteps;
  }

  Future<void> set(String value) async {
    await ref.read(preferenceServiceProvider).setRelearningSteps(value);
    ref.invalidateSelf();
  }
}
