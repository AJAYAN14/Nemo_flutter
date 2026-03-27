// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPrefsHash() => r'fed4dca864642604d0f2ec7cd1c0cdf906becb54';

/// See also [sharedPrefs].
@ProviderFor(sharedPrefs)
final sharedPrefsProvider = FutureProvider<SharedPreferences>.internal(
  sharedPrefs,
  name: r'sharedPrefsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPrefsRef = FutureProviderRef<SharedPreferences>;
String _$preferenceServiceHash() => r'e94d26fb7d972db07212058e3d56dcd447822e71';

/// See also [preferenceService].
@ProviderFor(preferenceService)
final preferenceServiceProvider = Provider<PreferenceService>.internal(
  preferenceService,
  name: r'preferenceServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$preferenceServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreferenceServiceRef = ProviderRef<PreferenceService>;
String _$wordGoalHash() => r'c280c8363722d4844cf624e9e6aeffec1cd40b86';

/// See also [WordGoal].
@ProviderFor(WordGoal)
final wordGoalProvider = AutoDisposeNotifierProvider<WordGoal, int>.internal(
  WordGoal.new,
  name: r'wordGoalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordGoalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WordGoal = AutoDisposeNotifier<int>;
String _$grammarGoalHash() => r'a0fa4344df0bf43f71d65e3da6e6af181027f9c3';

/// See also [GrammarGoal].
@ProviderFor(GrammarGoal)
final grammarGoalProvider =
    AutoDisposeNotifierProvider<GrammarGoal, int>.internal(
      GrammarGoal.new,
      name: r'grammarGoalProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$grammarGoalHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GrammarGoal = AutoDisposeNotifier<int>;
String _$jlptLevelHash() => r'1c3850c4912ac844d543194d63db239fa3fdd016';

/// See also [JlptLevel].
@ProviderFor(JlptLevel)
final jlptLevelProvider =
    AutoDisposeNotifierProvider<JlptLevel, String>.internal(
      JlptLevel.new,
      name: r'jlptLevelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$jlptLevelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JlptLevel = AutoDisposeNotifier<String>;
String _$darkModeHash() => r'16f8ba23b743f9fcf0c1df710e6f4c255c8ae3a1';

/// See also [DarkMode].
@ProviderFor(DarkMode)
final darkModeProvider = AutoDisposeNotifierProvider<DarkMode, int>.internal(
  DarkMode.new,
  name: r'darkModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$darkModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DarkMode = AutoDisposeNotifier<int>;
String _$autoSyncHash() => r'25c899bf6c5dc75fad88a083dcb4aa9e759b22f4';

/// See also [AutoSync].
@ProviderFor(AutoSync)
final autoSyncProvider = AutoDisposeNotifierProvider<AutoSync, bool>.internal(
  AutoSync.new,
  name: r'autoSyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoSync = AutoDisposeNotifier<bool>;
String _$resetHourHash() => r'832d8841dd35adf4382a095b1d953eaea57f23fa';

/// See also [ResetHour].
@ProviderFor(ResetHour)
final resetHourProvider = AutoDisposeNotifierProvider<ResetHour, int>.internal(
  ResetHour.new,
  name: r'resetHourProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetHourHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ResetHour = AutoDisposeNotifier<int>;
String _$randomContentHash() => r'd32bb054d8674c3b9064e506757fe306071f9740';

/// See also [RandomContent].
@ProviderFor(RandomContent)
final randomContentProvider =
    AutoDisposeNotifierProvider<RandomContent, bool>.internal(
      RandomContent.new,
      name: r'randomContentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$randomContentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RandomContent = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
