// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srs_study_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$srsStudyNotifierHash() => r'c87aca3d0e33bd92e9f33e68f56bb281bb98e068';

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

abstract class _$SrsStudyNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SrsStudyUiModel> {
  late final String mode;

  FutureOr<SrsStudyUiModel> build(String mode);
}

/// See also [SrsStudyNotifier].
@ProviderFor(SrsStudyNotifier)
const srsStudyNotifierProvider = SrsStudyNotifierFamily();

/// See also [SrsStudyNotifier].
class SrsStudyNotifierFamily extends Family<AsyncValue<SrsStudyUiModel>> {
  /// See also [SrsStudyNotifier].
  const SrsStudyNotifierFamily();

  /// See also [SrsStudyNotifier].
  SrsStudyNotifierProvider call(String mode) {
    return SrsStudyNotifierProvider(mode);
  }

  @override
  SrsStudyNotifierProvider getProviderOverride(
    covariant SrsStudyNotifierProvider provider,
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
  String? get name => r'srsStudyNotifierProvider';
}

/// See also [SrsStudyNotifier].
class SrsStudyNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SrsStudyNotifier,
          SrsStudyUiModel
        > {
  /// See also [SrsStudyNotifier].
  SrsStudyNotifierProvider(String mode)
    : this._internal(
        () => SrsStudyNotifier()..mode = mode,
        from: srsStudyNotifierProvider,
        name: r'srsStudyNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$srsStudyNotifierHash,
        dependencies: SrsStudyNotifierFamily._dependencies,
        allTransitiveDependencies:
            SrsStudyNotifierFamily._allTransitiveDependencies,
        mode: mode,
      );

  SrsStudyNotifierProvider._internal(
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
  FutureOr<SrsStudyUiModel> runNotifierBuild(
    covariant SrsStudyNotifier notifier,
  ) {
    return notifier.build(mode);
  }

  @override
  Override overrideWith(SrsStudyNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SrsStudyNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SrsStudyNotifier, SrsStudyUiModel>
  createElement() {
    return _SrsStudyNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SrsStudyNotifierProvider && other.mode == mode;
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
mixin SrsStudyNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SrsStudyUiModel> {
  /// The parameter `mode` of this provider.
  String get mode;
}

class _SrsStudyNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SrsStudyNotifier,
          SrsStudyUiModel
        >
    with SrsStudyNotifierRef {
  _SrsStudyNotifierProviderElement(super.provider);

  @override
  String get mode => (origin as SrsStudyNotifierProvider).mode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
