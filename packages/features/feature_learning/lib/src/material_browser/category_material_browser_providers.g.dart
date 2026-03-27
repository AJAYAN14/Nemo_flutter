// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_material_browser_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryMaterialBrowserNotifierHash() =>
    r'd4e351ba7e9d8d38124b38342aed90e3faf91551';

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

abstract class _$CategoryMaterialBrowserNotifier
    extends BuildlessAutoDisposeNotifier<CategoryMaterialBrowserUiState> {
  late final String categoryId;

  CategoryMaterialBrowserUiState build(String categoryId);
}

/// See also [CategoryMaterialBrowserNotifier].
@ProviderFor(CategoryMaterialBrowserNotifier)
const categoryMaterialBrowserNotifierProvider =
    CategoryMaterialBrowserNotifierFamily();

/// See also [CategoryMaterialBrowserNotifier].
class CategoryMaterialBrowserNotifierFamily
    extends Family<CategoryMaterialBrowserUiState> {
  /// See also [CategoryMaterialBrowserNotifier].
  const CategoryMaterialBrowserNotifierFamily();

  /// See also [CategoryMaterialBrowserNotifier].
  CategoryMaterialBrowserNotifierProvider call(String categoryId) {
    return CategoryMaterialBrowserNotifierProvider(categoryId);
  }

  @override
  CategoryMaterialBrowserNotifierProvider getProviderOverride(
    covariant CategoryMaterialBrowserNotifierProvider provider,
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
  String? get name => r'categoryMaterialBrowserNotifierProvider';
}

/// See also [CategoryMaterialBrowserNotifier].
class CategoryMaterialBrowserNotifierProvider
    extends
        AutoDisposeNotifierProviderImpl<
          CategoryMaterialBrowserNotifier,
          CategoryMaterialBrowserUiState
        > {
  /// See also [CategoryMaterialBrowserNotifier].
  CategoryMaterialBrowserNotifierProvider(String categoryId)
    : this._internal(
        () => CategoryMaterialBrowserNotifier()..categoryId = categoryId,
        from: categoryMaterialBrowserNotifierProvider,
        name: r'categoryMaterialBrowserNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryMaterialBrowserNotifierHash,
        dependencies: CategoryMaterialBrowserNotifierFamily._dependencies,
        allTransitiveDependencies:
            CategoryMaterialBrowserNotifierFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryMaterialBrowserNotifierProvider._internal(
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
  CategoryMaterialBrowserUiState runNotifierBuild(
    covariant CategoryMaterialBrowserNotifier notifier,
  ) {
    return notifier.build(categoryId);
  }

  @override
  Override overrideWith(CategoryMaterialBrowserNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryMaterialBrowserNotifierProvider._internal(
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
    CategoryMaterialBrowserNotifier,
    CategoryMaterialBrowserUiState
  >
  createElement() {
    return _CategoryMaterialBrowserNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryMaterialBrowserNotifierProvider &&
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
mixin CategoryMaterialBrowserNotifierRef
    on AutoDisposeNotifierProviderRef<CategoryMaterialBrowserUiState> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryMaterialBrowserNotifierProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          CategoryMaterialBrowserNotifier,
          CategoryMaterialBrowserUiState
        >
    with CategoryMaterialBrowserNotifierRef {
  _CategoryMaterialBrowserNotifierProviderElement(super.provider);

  @override
  String get categoryId =>
      (origin as CategoryMaterialBrowserNotifierProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
