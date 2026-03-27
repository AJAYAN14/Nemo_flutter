// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeViewModelHash() => r'e836ce7edbe60bb0005f7cbd1ed30c5398ac9eed';

/// See also [homeViewModel].
@ProviderFor(homeViewModel)
final homeViewModelProvider = AutoDisposeFutureProvider<HomeViewModel>.internal(
  homeViewModel,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeViewModelRef = AutoDisposeFutureProviderRef<HomeViewModel>;
String _$learningModeNotifierHash() =>
    r'e61d9a464b7aff7a0851c648b535343c89659f8c';

/// See also [LearningModeNotifier].
@ProviderFor(LearningModeNotifier)
final learningModeNotifierProvider =
    AutoDisposeNotifierProvider<LearningModeNotifier, LearningMode>.internal(
      LearningModeNotifier.new,
      name: r'learningModeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$learningModeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LearningModeNotifier = AutoDisposeNotifier<LearningMode>;
String _$selectedLevelNotifierHash() =>
    r'712b34e0ac855451ca7bbb7500aa7939c0955374';

/// See also [SelectedLevelNotifier].
@ProviderFor(SelectedLevelNotifier)
final selectedLevelNotifierProvider =
    AutoDisposeNotifierProvider<SelectedLevelNotifier, String>.internal(
      SelectedLevelNotifier.new,
      name: r'selectedLevelNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedLevelNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedLevelNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
