// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPrefsHash() => r'eb098372937031de179d783d77e5bfeb9825bc42';

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
String _$preferenceServiceHash() => r'e1e989f971ee763823ed0863ce56876147588ed9';

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
String _$wordGoalHash() => r'eb8c747cd22a689ab161098952f6a33bbb0b4d5d';

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
String _$grammarGoalHash() => r'aacef944848040d0ac738d7c602fc474ba6c93ba';

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
String _$wordLevelHash() => r'e18b07b156a22014011eaeb703db93892c6926f4';

/// See also [WordLevel].
@ProviderFor(WordLevel)
final wordLevelProvider =
    AutoDisposeNotifierProvider<WordLevel, String>.internal(
      WordLevel.new,
      name: r'wordLevelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wordLevelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WordLevel = AutoDisposeNotifier<String>;
String _$grammarLevelHash() => r'c7de99715f59fb654bab0a021435cdc226560fc3';

/// See also [GrammarLevel].
@ProviderFor(GrammarLevel)
final grammarLevelProvider =
    AutoDisposeNotifierProvider<GrammarLevel, String>.internal(
      GrammarLevel.new,
      name: r'grammarLevelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$grammarLevelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GrammarLevel = AutoDisposeNotifier<String>;
String _$lastLearningModeHash() => r'9bdcf56faa1fb236206e2195bb12d0fa7093649b';

/// See also [LastLearningMode].
@ProviderFor(LastLearningMode)
final lastLearningModeProvider =
    AutoDisposeNotifierProvider<LastLearningMode, String>.internal(
      LastLearningMode.new,
      name: r'lastLearningModeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lastLearningModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LastLearningMode = AutoDisposeNotifier<String>;
String _$darkModeHash() => r'63f6374eb264f023de860d29a7395a3645e155a4';

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
String _$autoSyncHash() => r'21c618e2f7c785c8ff15af2d074a0e965d325245';

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
String _$resetHourHash() => r'aaa334056b326b103c2c676fe28086b5f4e1428c';

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
String _$randomContentHash() => r'2e9b95c778acea16ea554b1996e69edf76546283';

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
String _$learnAheadLimitHash() => r'f6012792a0f2765c547fbde7c1a3440501dd9de3';

/// See also [LearnAheadLimit].
@ProviderFor(LearnAheadLimit)
final learnAheadLimitProvider =
    AutoDisposeNotifierProvider<LearnAheadLimit, int>.internal(
      LearnAheadLimit.new,
      name: r'learnAheadLimitProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learnAheadLimitHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LearnAheadLimit = AutoDisposeNotifier<int>;
String _$autoSpeakHash() => r'45d56005c911fd93b24ea4c275a8bda0e34c5923';

/// See also [AutoSpeak].
@ProviderFor(AutoSpeak)
final autoSpeakProvider = AutoDisposeNotifierProvider<AutoSpeak, bool>.internal(
  AutoSpeak.new,
  name: r'autoSpeakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoSpeakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoSpeak = AutoDisposeNotifier<bool>;
String _$showAnswerWaitHash() => r'5d3efbc1e117ad69c01a8ad42ebcf50abd427ece';

/// See also [ShowAnswerWait].
@ProviderFor(ShowAnswerWait)
final showAnswerWaitProvider =
    AutoDisposeNotifierProvider<ShowAnswerWait, bool>.internal(
      ShowAnswerWait.new,
      name: r'showAnswerWaitProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$showAnswerWaitHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ShowAnswerWait = AutoDisposeNotifier<bool>;
String _$answerWaitDurationHash() =>
    r'26d11fd80b5e60fcdf4119a3ea9ac12b7e3ff794';

/// See also [AnswerWaitDuration].
@ProviderFor(AnswerWaitDuration)
final answerWaitDurationProvider =
    AutoDisposeNotifierProvider<AnswerWaitDuration, double>.internal(
      AnswerWaitDuration.new,
      name: r'answerWaitDurationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$answerWaitDurationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnswerWaitDuration = AutoDisposeNotifier<double>;
String _$leechThresholdHash() => r'fd0a5427cd2a6a368ec004b212869f206e87a51a';

/// See also [LeechThreshold].
@ProviderFor(LeechThreshold)
final leechThresholdProvider =
    AutoDisposeNotifierProvider<LeechThreshold, int>.internal(
      LeechThreshold.new,
      name: r'leechThresholdProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$leechThresholdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LeechThreshold = AutoDisposeNotifier<int>;
String _$leechActionHash() => r'6fc7dbfd4b71221ecad412591a7e0f71616c6b8e';

/// See also [LeechAction].
@ProviderFor(LeechAction)
final leechActionProvider =
    AutoDisposeNotifierProvider<LeechAction, String>.internal(
      LeechAction.new,
      name: r'leechActionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$leechActionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LeechAction = AutoDisposeNotifier<String>;
String _$learningStepsHash() => r'026659ce1faffad99e7e8d83121d0aeac9eac6f0';

/// See also [LearningSteps].
@ProviderFor(LearningSteps)
final learningStepsProvider =
    AutoDisposeNotifierProvider<LearningSteps, String>.internal(
      LearningSteps.new,
      name: r'learningStepsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningStepsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LearningSteps = AutoDisposeNotifier<String>;
String _$relearningStepsHash() => r'c68850abd91e411abd0b60228fac9acf8403d5fb';

/// See also [RelearningSteps].
@ProviderFor(RelearningSteps)
final relearningStepsProvider =
    AutoDisposeNotifierProvider<RelearningSteps, String>.internal(
      RelearningSteps.new,
      name: r'relearningStepsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$relearningStepsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RelearningSteps = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
