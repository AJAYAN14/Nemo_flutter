// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordDetailHash() => r'c0db2e779be7cc6955599c2b38acd0f359de875d';

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

abstract class _$WordDetail
    extends BuildlessAutoDisposeNotifier<WordDetailState> {
  late final String wordId;

  WordDetailState build(String wordId);
}

/// See also [WordDetail].
@ProviderFor(WordDetail)
const wordDetailProvider = WordDetailFamily();

/// See also [WordDetail].
class WordDetailFamily extends Family<WordDetailState> {
  /// See also [WordDetail].
  const WordDetailFamily();

  /// See also [WordDetail].
  WordDetailProvider call(String wordId) {
    return WordDetailProvider(wordId);
  }

  @override
  WordDetailProvider getProviderOverride(
    covariant WordDetailProvider provider,
  ) {
    return call(provider.wordId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordDetailProvider';
}

/// See also [WordDetail].
class WordDetailProvider
    extends AutoDisposeNotifierProviderImpl<WordDetail, WordDetailState> {
  /// See also [WordDetail].
  WordDetailProvider(String wordId)
    : this._internal(
        () => WordDetail()..wordId = wordId,
        from: wordDetailProvider,
        name: r'wordDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wordDetailHash,
        dependencies: WordDetailFamily._dependencies,
        allTransitiveDependencies: WordDetailFamily._allTransitiveDependencies,
        wordId: wordId,
      );

  WordDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wordId,
  }) : super.internal();

  final String wordId;

  @override
  WordDetailState runNotifierBuild(covariant WordDetail notifier) {
    return notifier.build(wordId);
  }

  @override
  Override overrideWith(WordDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordDetailProvider._internal(
        () => create()..wordId = wordId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wordId: wordId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WordDetail, WordDetailState>
  createElement() {
    return _WordDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordDetailProvider && other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordDetailRef on AutoDisposeNotifierProviderRef<WordDetailState> {
  /// The parameter `wordId` of this provider.
  String get wordId;
}

class _WordDetailProviderElement
    extends AutoDisposeNotifierProviderElement<WordDetail, WordDetailState>
    with WordDetailRef {
  _WordDetailProviderElement(super.provider);

  @override
  String get wordId => (origin as WordDetailProvider).wordId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
