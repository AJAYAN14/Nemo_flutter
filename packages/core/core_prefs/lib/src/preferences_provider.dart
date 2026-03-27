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
