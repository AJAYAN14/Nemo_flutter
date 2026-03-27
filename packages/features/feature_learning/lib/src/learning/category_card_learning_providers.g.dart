// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_card_learning_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryCardLearningNotifierHash() =>
    r'6a7725d95a119158346fa60c5e4b1b49bb96fee6';

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

abstract class _$CategoryCardLearningNotifier
    extends BuildlessAutoDisposeNotifier<CategoryCardLearningUiState> {
  late final String categoryId;

  CategoryCardLearningUiState build(String categoryId);
}

/// See also [CategoryCardLearningNotifier].
@ProviderFor(CategoryCardLearningNotifier)
const categoryCardLearningNotifierProvider =
    CategoryCardLearningNotifierFamily();

/// See also [CategoryCardLearningNotifier].
class CategoryCardLearningNotifierFamily
    extends Family<CategoryCardLearningUiState> {
  /// See also [CategoryCardLearningNotifier].
  const CategoryCardLearningNotifierFamily();

  /// See also [CategoryCardLearningNotifier].
  CategoryCardLearningNotifierProvider call(String categoryId) {
    return CategoryCardLearningNotifierProvider(categoryId);
  }

  @override
  CategoryCardLearningNotifierProvider getProviderOverride(
    covariant CategoryCardLearningNotifierProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryCardLearningNotifierProvider';
}

/// See also [CategoryCardLearningNotifier].
class CategoryCardLearningNotifierProvider
    extends
        AutoDisposeNotifierProviderImpl<
          CategoryCardLearningNotifier,
          CategoryCardLearningUiState
        > {
  /// See also [CategoryCardLearningNotifier].
  CategoryCardLearningNotifierProvider(String categoryId)
    : this._internal(
        () => CategoryCardLearningNotifier()..categoryId = categoryId,
        from: categoryCardLearningNotifierProvider,
        name: r'categoryCardLearningNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryCardLearningNotifierHash,
        dependencies: CategoryCardLearningNotifierFamily._dependencies,
        allTransitiveDependencies:
            CategoryCardLearningNotifierFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryCardLearningNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  CategoryCardLearningUiState runNotifierBuild(
    covariant CategoryCardLearningNotifier notifier,
  ) {
    return notifier.build(categoryId);
  }

  @override
  Override overrideWith(CategoryCardLearningNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryCardLearningNotifierProvider._internal(
        () => create()..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    CategoryCardLearningNotifier,
    CategoryCardLearningUiState
  >
  createElement() {
    return _CategoryCardLearningNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryCardLearningNotifierProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryCardLearningNotifierRef
    on AutoDisposeNotifierProviderRef<CategoryCardLearningUiState> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryCardLearningNotifierProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          CategoryCardLearningNotifier,
          CategoryCardLearningUiState
        >
    with CategoryCardLearningNotifierRef {
  _CategoryCardLearningNotifierProviderElement(super.provider);

  @override
  String get categoryId =>
      (origin as CategoryCardLearningNotifierProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
