// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$petDaycaresHash() => r'71a6fabd29c72907f62d2ad299831470c9c5dd91';

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

/// See also [petDaycares].
@ProviderFor(petDaycares)
const petDaycaresProvider = PetDaycaresFamily();

/// See also [petDaycares].
class PetDaycaresFamily extends Family<AsyncValue<ListData<PetDaycare>>> {
  /// See also [petDaycares].
  const PetDaycaresFamily();

  /// See also [petDaycares].
  PetDaycaresProvider call(
    double lat,
    double long,
  ) {
    return PetDaycaresProvider(
      lat,
      long,
    );
  }

  @override
  PetDaycaresProvider getProviderOverride(
    covariant PetDaycaresProvider provider,
  ) {
    return call(
      provider.lat,
      provider.long,
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
  String? get name => r'petDaycaresProvider';
}

/// See also [petDaycares].
class PetDaycaresProvider
    extends AutoDisposeFutureProvider<ListData<PetDaycare>> {
  /// See also [petDaycares].
  PetDaycaresProvider(
    double lat,
    double long,
  ) : this._internal(
          (ref) => petDaycares(
            ref as PetDaycaresRef,
            lat,
            long,
          ),
          from: petDaycaresProvider,
          name: r'petDaycaresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$petDaycaresHash,
          dependencies: PetDaycaresFamily._dependencies,
          allTransitiveDependencies:
              PetDaycaresFamily._allTransitiveDependencies,
          lat: lat,
          long: long,
        );

  PetDaycaresProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lat,
    required this.long,
  }) : super.internal();

  final double lat;
  final double long;

  @override
  Override overrideWith(
    FutureOr<ListData<PetDaycare>> Function(PetDaycaresRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PetDaycaresProvider._internal(
        (ref) => create(ref as PetDaycaresRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lat: lat,
        long: long,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<PetDaycare>> createElement() {
    return _PetDaycaresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PetDaycaresProvider &&
        other.lat == lat &&
        other.long == long;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, long.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PetDaycaresRef on AutoDisposeFutureProviderRef<ListData<PetDaycare>> {
  /// The parameter `lat` of this provider.
  double get lat;

  /// The parameter `long` of this provider.
  double get long;
}

class _PetDaycaresProviderElement
    extends AutoDisposeFutureProviderElement<ListData<PetDaycare>>
    with PetDaycaresRef {
  _PetDaycaresProviderElement(super.provider);

  @override
  double get lat => (origin as PetDaycaresProvider).lat;
  @override
  double get long => (origin as PetDaycaresProvider).long;
}

String _$petHash() => r'ceb5e30816e037b58eb54fd89596c1f0cb8744a5';

/// See also [pet].
@ProviderFor(pet)
const petProvider = PetFamily();

/// See also [pet].
class PetFamily extends Family<AsyncValue<Pet>> {
  /// See also [pet].
  const PetFamily();

  /// See also [pet].
  PetProvider call(
    int petId,
  ) {
    return PetProvider(
      petId,
    );
  }

  @override
  PetProvider getProviderOverride(
    covariant PetProvider provider,
  ) {
    return call(
      provider.petId,
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
  String? get name => r'petProvider';
}

/// See also [pet].
class PetProvider extends AutoDisposeFutureProvider<Pet> {
  /// See also [pet].
  PetProvider(
    int petId,
  ) : this._internal(
          (ref) => pet(
            ref as PetRef,
            petId,
          ),
          from: petProvider,
          name: r'petProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$petHash,
          dependencies: PetFamily._dependencies,
          allTransitiveDependencies: PetFamily._allTransitiveDependencies,
          petId: petId,
        );

  PetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.petId,
  }) : super.internal();

  final int petId;

  @override
  Override overrideWith(
    FutureOr<Pet> Function(PetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PetProvider._internal(
        (ref) => create(ref as PetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        petId: petId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Pet> createElement() {
    return _PetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PetProvider && other.petId == petId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, petId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PetRef on AutoDisposeFutureProviderRef<Pet> {
  /// The parameter `petId` of this provider.
  int get petId;
}

class _PetProviderElement extends AutoDisposeFutureProviderElement<Pet>
    with PetRef {
  _PetProviderElement(super.provider);

  @override
  int get petId => (origin as PetProvider).petId;
}

String _$vaccineRecordsHash() => r'22d6ba0b3852eb9e838dbf12c691fe5fa63db8d4';

/// See also [vaccineRecords].
@ProviderFor(vaccineRecords)
const vaccineRecordsProvider = VaccineRecordsFamily();

/// See also [vaccineRecords].
class VaccineRecordsFamily
    extends Family<AsyncValue<ListData<VaccineRecord?>>> {
  /// See also [vaccineRecords].
  const VaccineRecordsFamily();

  /// See also [vaccineRecords].
  VaccineRecordsProvider call(
    int petId, [
    int lastId = 0,
    int pageSize = 10,
  ]) {
    return VaccineRecordsProvider(
      petId,
      lastId,
      pageSize,
    );
  }

  @override
  VaccineRecordsProvider getProviderOverride(
    covariant VaccineRecordsProvider provider,
  ) {
    return call(
      provider.petId,
      provider.lastId,
      provider.pageSize,
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
  String? get name => r'vaccineRecordsProvider';
}

/// See also [vaccineRecords].
class VaccineRecordsProvider
    extends AutoDisposeFutureProvider<ListData<VaccineRecord?>> {
  /// See also [vaccineRecords].
  VaccineRecordsProvider(
    int petId, [
    int lastId = 0,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => vaccineRecords(
            ref as VaccineRecordsRef,
            petId,
            lastId,
            pageSize,
          ),
          from: vaccineRecordsProvider,
          name: r'vaccineRecordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vaccineRecordsHash,
          dependencies: VaccineRecordsFamily._dependencies,
          allTransitiveDependencies:
              VaccineRecordsFamily._allTransitiveDependencies,
          petId: petId,
          lastId: lastId,
          pageSize: pageSize,
        );

  VaccineRecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.petId,
    required this.lastId,
    required this.pageSize,
  }) : super.internal();

  final int petId;
  final int lastId;
  final int pageSize;

  @override
  Override overrideWith(
    FutureOr<ListData<VaccineRecord?>> Function(VaccineRecordsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VaccineRecordsProvider._internal(
        (ref) => create(ref as VaccineRecordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        petId: petId,
        lastId: lastId,
        pageSize: pageSize,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<VaccineRecord?>> createElement() {
    return _VaccineRecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VaccineRecordsProvider &&
        other.petId == petId &&
        other.lastId == lastId &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, petId.hashCode);
    hash = _SystemHash.combine(hash, lastId.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VaccineRecordsRef
    on AutoDisposeFutureProviderRef<ListData<VaccineRecord?>> {
  /// The parameter `petId` of this provider.
  int get petId;

  /// The parameter `lastId` of this provider.
  int get lastId;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _VaccineRecordsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<VaccineRecord?>>
    with VaccineRecordsRef {
  _VaccineRecordsProviderElement(super.provider);

  @override
  int get petId => (origin as VaccineRecordsProvider).petId;
  @override
  int get lastId => (origin as VaccineRecordsProvider).lastId;
  @override
  int get pageSize => (origin as VaccineRecordsProvider).pageSize;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
