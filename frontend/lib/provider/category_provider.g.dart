// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vetSpecialtiesHash() => r'630c407c0bb6e9d0e0585d9479de2df8bbe1269f';

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

/// See also [vetSpecialties].
@ProviderFor(vetSpecialties)
const vetSpecialtiesProvider = VetSpecialtiesFamily();

/// See also [vetSpecialties].
class VetSpecialtiesFamily extends Family<AsyncValue<List<Lookup>>> {
  /// See also [vetSpecialties].
  const VetSpecialtiesFamily();

  /// See also [vetSpecialties].
  VetSpecialtiesProvider call(
    ICategoryRepository categoryRepo,
  ) {
    return VetSpecialtiesProvider(
      categoryRepo,
    );
  }

  @override
  VetSpecialtiesProvider getProviderOverride(
    covariant VetSpecialtiesProvider provider,
  ) {
    return call(
      provider.categoryRepo,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vetSpecialtiesProvider';
}

/// See also [vetSpecialties].
class VetSpecialtiesProvider extends AutoDisposeFutureProvider<List<Lookup>> {
  /// See also [vetSpecialties].
  VetSpecialtiesProvider(
    ICategoryRepository categoryRepo,
  ) : this._internal(
          (ref) => vetSpecialties(
            ref as VetSpecialtiesRef,
            categoryRepo,
          ),
          from: vetSpecialtiesProvider,
          name: r'vetSpecialtiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vetSpecialtiesHash,
          dependencies: VetSpecialtiesFamily._dependencies,
          allTransitiveDependencies:
              VetSpecialtiesFamily._allTransitiveDependencies,
          categoryRepo: categoryRepo,
        );

  VetSpecialtiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryRepo,
  }) : super.internal();

  final ICategoryRepository categoryRepo;

  @override
  Override overrideWith(
    FutureOr<List<Lookup>> Function(VetSpecialtiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VetSpecialtiesProvider._internal(
        (ref) => create(ref as VetSpecialtiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryRepo: categoryRepo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Lookup>> createElement() {
    return _VetSpecialtiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VetSpecialtiesProvider &&
        other.categoryRepo == categoryRepo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryRepo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VetSpecialtiesRef on AutoDisposeFutureProviderRef<List<Lookup>> {
  /// The parameter `categoryRepo` of this provider.
  ICategoryRepository get categoryRepo;
}

class _VetSpecialtiesProviderElement
    extends AutoDisposeFutureProviderElement<List<Lookup>>
    with VetSpecialtiesRef {
  _VetSpecialtiesProviderElement(super.provider);

  @override
  ICategoryRepository get categoryRepo =>
      (origin as VetSpecialtiesProvider).categoryRepo;
}

String _$speciesHash() => r'31c36e3a1581d703903624c7114eb254d52fefa1';

/// See also [species].
@ProviderFor(species)
const speciesProvider = SpeciesFamily();

/// See also [species].
class SpeciesFamily extends Family<AsyncValue<List<Lookup>>> {
  /// See also [species].
  const SpeciesFamily();

  /// See also [species].
  SpeciesProvider call(
    ICategoryRepository categoryRepo,
  ) {
    return SpeciesProvider(
      categoryRepo,
    );
  }

  @override
  SpeciesProvider getProviderOverride(
    covariant SpeciesProvider provider,
  ) {
    return call(
      provider.categoryRepo,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'speciesProvider';
}

/// See also [species].
class SpeciesProvider extends AutoDisposeFutureProvider<List<Lookup>> {
  /// See also [species].
  SpeciesProvider(
    ICategoryRepository categoryRepo,
  ) : this._internal(
          (ref) => species(
            ref as SpeciesRef,
            categoryRepo,
          ),
          from: speciesProvider,
          name: r'speciesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$speciesHash,
          dependencies: SpeciesFamily._dependencies,
          allTransitiveDependencies: SpeciesFamily._allTransitiveDependencies,
          categoryRepo: categoryRepo,
        );

  SpeciesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryRepo,
  }) : super.internal();

  final ICategoryRepository categoryRepo;

  @override
  Override overrideWith(
    FutureOr<List<Lookup>> Function(SpeciesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SpeciesProvider._internal(
        (ref) => create(ref as SpeciesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryRepo: categoryRepo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Lookup>> createElement() {
    return _SpeciesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpeciesProvider && other.categoryRepo == categoryRepo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryRepo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SpeciesRef on AutoDisposeFutureProviderRef<List<Lookup>> {
  /// The parameter `categoryRepo` of this provider.
  ICategoryRepository get categoryRepo;
}

class _SpeciesProviderElement
    extends AutoDisposeFutureProviderElement<List<Lookup>> with SpeciesRef {
  _SpeciesProviderElement(super.provider);

  @override
  ICategoryRepository get categoryRepo =>
      (origin as SpeciesProvider).categoryRepo;
}

String _$sizeCategoriesHash() => r'f6d717872c7df15ff15e603e7ade466b0ac95085';

/// See also [sizeCategories].
@ProviderFor(sizeCategories)
const sizeCategoriesProvider = SizeCategoriesFamily();

/// See also [sizeCategories].
class SizeCategoriesFamily extends Family<AsyncValue<List<SizeCategory>>> {
  /// See also [sizeCategories].
  const SizeCategoriesFamily();

  /// See also [sizeCategories].
  SizeCategoriesProvider call(
    ICategoryRepository categoryRepo,
  ) {
    return SizeCategoriesProvider(
      categoryRepo,
    );
  }

  @override
  SizeCategoriesProvider getProviderOverride(
    covariant SizeCategoriesProvider provider,
  ) {
    return call(
      provider.categoryRepo,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sizeCategoriesProvider';
}

/// See also [sizeCategories].
class SizeCategoriesProvider
    extends AutoDisposeFutureProvider<List<SizeCategory>> {
  /// See also [sizeCategories].
  SizeCategoriesProvider(
    ICategoryRepository categoryRepo,
  ) : this._internal(
          (ref) => sizeCategories(
            ref as SizeCategoriesRef,
            categoryRepo,
          ),
          from: sizeCategoriesProvider,
          name: r'sizeCategoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sizeCategoriesHash,
          dependencies: SizeCategoriesFamily._dependencies,
          allTransitiveDependencies:
              SizeCategoriesFamily._allTransitiveDependencies,
          categoryRepo: categoryRepo,
        );

  SizeCategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryRepo,
  }) : super.internal();

  final ICategoryRepository categoryRepo;

  @override
  Override overrideWith(
    FutureOr<List<SizeCategory>> Function(SizeCategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SizeCategoriesProvider._internal(
        (ref) => create(ref as SizeCategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryRepo: categoryRepo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SizeCategory>> createElement() {
    return _SizeCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SizeCategoriesProvider &&
        other.categoryRepo == categoryRepo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryRepo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SizeCategoriesRef on AutoDisposeFutureProviderRef<List<SizeCategory>> {
  /// The parameter `categoryRepo` of this provider.
  ICategoryRepository get categoryRepo;
}

class _SizeCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<SizeCategory>>
    with SizeCategoriesRef {
  _SizeCategoriesProviderElement(super.provider);

  @override
  ICategoryRepository get categoryRepo =>
      (origin as SizeCategoriesProvider).categoryRepo;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
