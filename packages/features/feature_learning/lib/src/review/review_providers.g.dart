// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewNotifierHash() => r'8349a1c6f48797bccf7ec263ff9746147a2c836d';

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

abstract class _$ReviewNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ReviewSession> {
  late final String mode;

  FutureOr<ReviewSession> build(String mode);
}

/// See also [ReviewNotifier].
@ProviderFor(ReviewNotifier)
const reviewNotifierProvider = ReviewNotifierFamily();

/// See also [ReviewNotifier].
class ReviewNotifierFamily extends Family<AsyncValue<ReviewSession>> {
  /// See also [ReviewNotifier].
  const ReviewNotifierFamily();

  /// See also [ReviewNotifier].
  ReviewNotifierProvider call(String mode) {
    return ReviewNotifierProvider(mode);
  }

  @override
  ReviewNotifierProvider getProviderOverride(
    covariant ReviewNotifierProvider provider,
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
  String? get name => r'reviewNotifierProvider';
}

/// See also [ReviewNotifier].
class ReviewNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ReviewNotifier, ReviewSession> {
  /// See also [ReviewNotifier].
  ReviewNotifierProvider(String mode)
    : this._internal(
        () => ReviewNotifier()..mode = mode,
        from: reviewNotifierProvider,
        name: r'reviewNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$reviewNotifierHash,
        dependencies: ReviewNotifierFamily._dependencies,
        allTransitiveDependencies:
            ReviewNotifierFamily._allTransitiveDependencies,
        mode: mode,
      );

  ReviewNotifierProvider._internal(
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
  FutureOr<ReviewSession> runNotifierBuild(covariant ReviewNotifier notifier) {
    return notifier.build(mode);
  }

  @override
  Override overrideWith(ReviewNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReviewNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ReviewNotifier, ReviewSession>
  createElement() {
    return _ReviewNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewNotifierProvider && other.mode == mode;
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
mixin ReviewNotifierRef on AutoDisposeAsyncNotifierProviderRef<ReviewSession> {
  /// The parameter `mode` of this provider.
  String get mode;
}

class _ReviewNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ReviewNotifier, ReviewSession>
    with ReviewNotifierRef {
  _ReviewNotifierProviderElement(super.provider);

  @override
  String get mode => (origin as ReviewNotifierProvider).mode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
