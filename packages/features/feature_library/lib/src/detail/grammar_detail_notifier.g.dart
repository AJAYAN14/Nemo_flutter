// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$grammarDetailHash() => r'8c16f789e349af218ef677b29b9edc6e8407ee73';

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

abstract class _$GrammarDetail
    extends BuildlessAutoDisposeAsyncNotifier<Grammar?> {
  late final int grammarId;

  FutureOr<Grammar?> build(int grammarId);
}

/// See also [GrammarDetail].
@ProviderFor(GrammarDetail)
const grammarDetailProvider = GrammarDetailFamily();

/// See also [GrammarDetail].
class GrammarDetailFamily extends Family<AsyncValue<Grammar?>> {
  /// See also [GrammarDetail].
  const GrammarDetailFamily();

  /// See also [GrammarDetail].
  GrammarDetailProvider call(int grammarId) {
    return GrammarDetailProvider(grammarId);
  }

  @override
  GrammarDetailProvider getProviderOverride(
    covariant GrammarDetailProvider provider,
  ) {
    return call(provider.grammarId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'grammarDetailProvider';
}

/// See also [GrammarDetail].
class GrammarDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GrammarDetail, Grammar?> {
  /// See also [GrammarDetail].
  GrammarDetailProvider(int grammarId)
    : this._internal(
        () => GrammarDetail()..grammarId = grammarId,
        from: grammarDetailProvider,
        name: r'grammarDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$grammarDetailHash,
        dependencies: GrammarDetailFamily._dependencies,
        allTransitiveDependencies:
            GrammarDetailFamily._allTransitiveDependencies,
        grammarId: grammarId,
      );

  GrammarDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.grammarId,
  }) : super.internal();

  final int grammarId;

  @override
  FutureOr<Grammar?> runNotifierBuild(covariant GrammarDetail notifier) {
    return notifier.build(grammarId);
  }

  @override
  Override overrideWith(GrammarDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: GrammarDetailProvider._internal(
        () => create()..grammarId = grammarId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        grammarId: grammarId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GrammarDetail, Grammar?>
  createElement() {
    return _GrammarDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GrammarDetailProvider && other.grammarId == grammarId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, grammarId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GrammarDetailRef on AutoDisposeAsyncNotifierProviderRef<Grammar?> {
  /// The parameter `grammarId` of this provider.
  int get grammarId;
}

class _GrammarDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GrammarDetail, Grammar?>
    with GrammarDetailRef {
  _GrammarDetailProviderElement(super.provider);

  @override
  int get grammarId => (origin as GrammarDetailProvider).grammarId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
