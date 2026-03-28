// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srs_review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$srsReviewNotifierHash() => r'1353ce1427ef17da33c8e09414b8ddae8727346a';

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

abstract class _$SrsReviewNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SrsStudyUiModel> {
  late final String mode;

  FutureOr<SrsStudyUiModel> build(String mode);
}

/// See also [SrsReviewNotifier].
@ProviderFor(SrsReviewNotifier)
const srsReviewNotifierProvider = SrsReviewNotifierFamily();

/// See also [SrsReviewNotifier].
class SrsReviewNotifierFamily extends Family<AsyncValue<SrsStudyUiModel>> {
  /// See also [SrsReviewNotifier].
  const SrsReviewNotifierFamily();

  /// See also [SrsReviewNotifier].
  SrsReviewNotifierProvider call(String mode) {
    return SrsReviewNotifierProvider(mode);
  }

  @override
  SrsReviewNotifierProvider getProviderOverride(
    covariant SrsReviewNotifierProvider provider,
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
  String? get name => r'srsReviewNotifierProvider';
}

/// See also [SrsReviewNotifier].
class SrsReviewNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SrsReviewNotifier,
          SrsStudyUiModel
        > {
  /// See also [SrsReviewNotifier].
  SrsReviewNotifierProvider(String mode)
    : this._internal(
        () => SrsReviewNotifier()..mode = mode,
        from: srsReviewNotifierProvider,
        name: r'srsReviewNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$srsReviewNotifierHash,
        dependencies: SrsReviewNotifierFamily._dependencies,
        allTransitiveDependencies:
            SrsReviewNotifierFamily._allTransitiveDependencies,
        mode: mode,
      );

  SrsReviewNotifierProvider._internal(
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
    covariant SrsReviewNotifier notifier,
  ) {
    return notifier.build(mode);
  }

  @override
  Override overrideWith(SrsReviewNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SrsReviewNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SrsReviewNotifier, SrsStudyUiModel>
  createElement() {
    return _SrsReviewNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SrsReviewNotifierProvider && other.mode == mode;
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
mixin SrsReviewNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SrsStudyUiModel> {
  /// The parameter `mode` of this provider.
  String get mode;
}

class _SrsReviewNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SrsReviewNotifier,
          SrsStudyUiModel
        >
    with SrsReviewNotifierRef {
  _SrsReviewNotifierProviderElement(super.provider);

  @override
  String get mode => (origin as SrsReviewNotifierProvider).mode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
