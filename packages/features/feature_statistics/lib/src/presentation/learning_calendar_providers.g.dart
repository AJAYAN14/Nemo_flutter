// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_calendar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayItemsHash() => r'a33d08a675e9d684949bedcd249817a06a42ca8f';

/// See also [todayItems].
@ProviderFor(todayItems)
final todayItemsProvider =
    AutoDisposeFutureProvider<List<StudyItemWithStatus>>.internal(
      todayItems,
      name: r'todayItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayItemsRef = AutoDisposeFutureProviderRef<List<StudyItemWithStatus>>;
String _$learningCalendarNotifierHash() =>
    r'2f1b093e4e4e770a6736d100670829aca5add76d';

/// See also [LearningCalendarNotifier].
@ProviderFor(LearningCalendarNotifier)
final learningCalendarNotifierProvider =
    AutoDisposeNotifierProvider<
      LearningCalendarNotifier,
      LearningCalendarUiState
    >.internal(
      LearningCalendarNotifier.new,
      name: r'learningCalendarNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningCalendarNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LearningCalendarNotifier =
    AutoDisposeNotifier<LearningCalendarUiState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
