// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$learnAheadLimitHash() => r'df59433ca0004a409388df04c00ef22501aebda6';

/// See also [learnAheadLimit].
@ProviderFor(learnAheadLimit)
final learnAheadLimitProvider = AutoDisposeProvider<Duration>.internal(
  learnAheadLimit,
  name: r'learnAheadLimitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$learnAheadLimitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LearnAheadLimitRef = AutoDisposeProviderRef<Duration>;
String _$learningNotifierHash() => r'14058a45b3fad05c4d159f8235689e78c2fdd395';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LearningNotifier
    extends BuildlessAutoDisposeAsyncNotifier<LearningUiModel> {
  late final String mode;

  FutureOr<LearningUiModel> build(String mode);
}

/// See also [LearningNotifier].
@ProviderFor(LearningNotifier)
const learningNotifierProvider = LearningNotifierFamily();

/// See also [LearningNotifier].
class LearningNotifierFamily extends Family<AsyncValue<LearningUiModel>> {
  /// See also [LearningNotifier].
  const LearningNotifierFamily();

  /// See also [LearningNotifier].
  LearningNotifierProvider call(String mode) {
    return LearningNotifierProvider(mode);
  }

  @override
  LearningNotifierProvider getProviderOverride(
    covariant LearningNotifierProvider provider,
  ) {
    return call(provider.mode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'learningNotifierProvider';
}

/// See also [LearningNotifier].
class LearningNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          LearningNotifier,
          LearningUiModel
        > {
  /// See also [LearningNotifier].
  LearningNotifierProvider(String mode)
    : this._internal(
        () => LearningNotifier()..mode = mode,
        from: learningNotifierProvider,
        name: r'learningNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$learningNotifierHash,
        dependencies: LearningNotifierFamily._dependencies,
        allTransitiveDependencies:
            LearningNotifierFamily._allTransitiveDependencies,
        mode: mode,
      );

  LearningNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mode,
  }) : super.internal();

  final String mode;

  @override
  FutureOr<LearningUiModel> runNotifierBuild(
    covariant LearningNotifier notifier,
  ) {
    return notifier.build(mode);
  }

  @override
  Override overrideWith(LearningNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: LearningNotifierProvider._internal(
        () => create()..mode = mode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mode: mode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LearningNotifier, LearningUiModel>
  createElement() {
    return _LearningNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LearningNotifierProvider && other.mode == mode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LearningNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<LearningUiModel> {
  /// The parameter `mode` of this provider.
  String get mode;
}

class _LearningNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          LearningNotifier,
          LearningUiModel
        >
    with LearningNotifierRef {
  _LearningNotifierProviderElement(super.provider);

  @override
  String get mode => (origin as LearningNotifierProvider).mode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
