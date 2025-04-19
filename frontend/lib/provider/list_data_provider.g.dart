// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$petDaycaresHash() => r'30b1dcfe3ee92e41cc5afa832fecc59a792c3706';

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
    double? lat,
    double? long, [
    int lastId = 0,
    int pageSize = 10,
  ]) {
    return PetDaycaresProvider(
      lat,
      long,
      lastId,
      pageSize,
    );
  }

  @override
  PetDaycaresProvider getProviderOverride(
    covariant PetDaycaresProvider provider,
  ) {
    return call(
      provider.lat,
      provider.long,
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
  String? get name => r'petDaycaresProvider';
}

/// See also [petDaycares].
class PetDaycaresProvider
    extends AutoDisposeFutureProvider<ListData<PetDaycare>> {
  /// See also [petDaycares].
  PetDaycaresProvider(
    double? lat,
    double? long, [
    int lastId = 0,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => petDaycares(
            ref as PetDaycaresRef,
            lat,
            long,
            lastId,
            pageSize,
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
          lastId: lastId,
          pageSize: pageSize,
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
    required this.lastId,
    required this.pageSize,
  }) : super.internal();

  final double? lat;
  final double? long;
  final int lastId;
  final int pageSize;

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
        lastId: lastId,
        pageSize: pageSize,
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
        other.long == long &&
        other.lastId == lastId &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, long.hashCode);
    hash = _SystemHash.combine(hash, lastId.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PetDaycaresRef on AutoDisposeFutureProviderRef<ListData<PetDaycare>> {
  /// The parameter `lat` of this provider.
  double? get lat;

  /// The parameter `long` of this provider.
  double? get long;

  /// The parameter `lastId` of this provider.
  int get lastId;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _PetDaycaresProviderElement
    extends AutoDisposeFutureProviderElement<ListData<PetDaycare>>
    with PetDaycaresRef {
  _PetDaycaresProviderElement(super.provider);

  @override
  double? get lat => (origin as PetDaycaresProvider).lat;
  @override
  double? get long => (origin as PetDaycaresProvider).long;
  @override
  int get lastId => (origin as PetDaycaresProvider).lastId;
  @override
  int get pageSize => (origin as PetDaycaresProvider).pageSize;
}

String _$petHash() => r'22b5b29c565c6573a7e66d793447120ae3a3e1a7';

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

String _$vaccineRecordsHash() => r'ff3765e02161b848476fdad216a06c77897dc4b4';

/// See also [vaccineRecords].
@ProviderFor(vaccineRecords)
const vaccineRecordsProvider = VaccineRecordsFamily();

/// See also [vaccineRecords].
class VaccineRecordsFamily extends Family<AsyncValue<ListData<VaccineRecord>>> {
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
    extends AutoDisposeFutureProvider<ListData<VaccineRecord>> {
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
    FutureOr<ListData<VaccineRecord>> Function(VaccineRecordsRef provider)
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
  AutoDisposeFutureProviderElement<ListData<VaccineRecord>> createElement() {
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
    on AutoDisposeFutureProviderRef<ListData<VaccineRecord>> {
  /// The parameter `petId` of this provider.
  int get petId;

  /// The parameter `lastId` of this provider.
  int get lastId;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _VaccineRecordsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<VaccineRecord>>
    with VaccineRecordsRef {
  _VaccineRecordsProviderElement(super.provider);

  @override
  int get petId => (origin as VaccineRecordsProvider).petId;
  @override
  int get lastId => (origin as VaccineRecordsProvider).lastId;
  @override
  int get pageSize => (origin as VaccineRecordsProvider).pageSize;
}

String _$getVaccinationRecordByIdHash() =>
    r'9a64e1b44a30b7f9488f527ed936cbb40a596d21';

/// See also [getVaccinationRecordById].
@ProviderFor(getVaccinationRecordById)
const getVaccinationRecordByIdProvider = GetVaccinationRecordByIdFamily();

/// See also [getVaccinationRecordById].
class GetVaccinationRecordByIdFamily extends Family<AsyncValue<VaccineRecord>> {
  /// See also [getVaccinationRecordById].
  const GetVaccinationRecordByIdFamily();

  /// See also [getVaccinationRecordById].
  GetVaccinationRecordByIdProvider call(
    int vaccinationRecordId,
  ) {
    return GetVaccinationRecordByIdProvider(
      vaccinationRecordId,
    );
  }

  @override
  GetVaccinationRecordByIdProvider getProviderOverride(
    covariant GetVaccinationRecordByIdProvider provider,
  ) {
    return call(
      provider.vaccinationRecordId,
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
  String? get name => r'getVaccinationRecordByIdProvider';
}

/// See also [getVaccinationRecordById].
class GetVaccinationRecordByIdProvider
    extends AutoDisposeFutureProvider<VaccineRecord> {
  /// See also [getVaccinationRecordById].
  GetVaccinationRecordByIdProvider(
    int vaccinationRecordId,
  ) : this._internal(
          (ref) => getVaccinationRecordById(
            ref as GetVaccinationRecordByIdRef,
            vaccinationRecordId,
          ),
          from: getVaccinationRecordByIdProvider,
          name: r'getVaccinationRecordByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getVaccinationRecordByIdHash,
          dependencies: GetVaccinationRecordByIdFamily._dependencies,
          allTransitiveDependencies:
              GetVaccinationRecordByIdFamily._allTransitiveDependencies,
          vaccinationRecordId: vaccinationRecordId,
        );

  GetVaccinationRecordByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vaccinationRecordId,
  }) : super.internal();

  final int vaccinationRecordId;

  @override
  Override overrideWith(
    FutureOr<VaccineRecord> Function(GetVaccinationRecordByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVaccinationRecordByIdProvider._internal(
        (ref) => create(ref as GetVaccinationRecordByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vaccinationRecordId: vaccinationRecordId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<VaccineRecord> createElement() {
    return _GetVaccinationRecordByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVaccinationRecordByIdProvider &&
        other.vaccinationRecordId == vaccinationRecordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vaccinationRecordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVaccinationRecordByIdRef
    on AutoDisposeFutureProviderRef<VaccineRecord> {
  /// The parameter `vaccinationRecordId` of this provider.
  int get vaccinationRecordId;
}

class _GetVaccinationRecordByIdProviderElement
    extends AutoDisposeFutureProviderElement<VaccineRecord>
    with GetVaccinationRecordByIdRef {
  _GetVaccinationRecordByIdProviderElement(super.provider);

  @override
  int get vaccinationRecordId =>
      (origin as GetVaccinationRecordByIdProvider).vaccinationRecordId;
}

String _$petListHash() => r'56289e788b65c7a183054041972b43691aa1334d';

/// See also [petList].
@ProviderFor(petList)
const petListProvider = PetListFamily();

/// See also [petList].
class PetListFamily extends Family<AsyncValue<ListData<Pet>>> {
  /// See also [petList].
  const PetListFamily();

  /// See also [petList].
  PetListProvider call([
    int lastId = 0,
    int pageSize = 10,
  ]) {
    return PetListProvider(
      lastId,
      pageSize,
    );
  }

  @override
  PetListProvider getProviderOverride(
    covariant PetListProvider provider,
  ) {
    return call(
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
  String? get name => r'petListProvider';
}

/// See also [petList].
class PetListProvider extends AutoDisposeFutureProvider<ListData<Pet>> {
  /// See also [petList].
  PetListProvider([
    int lastId = 0,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => petList(
            ref as PetListRef,
            lastId,
            pageSize,
          ),
          from: petListProvider,
          name: r'petListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$petListHash,
          dependencies: PetListFamily._dependencies,
          allTransitiveDependencies: PetListFamily._allTransitiveDependencies,
          lastId: lastId,
          pageSize: pageSize,
        );

  PetListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lastId,
    required this.pageSize,
  }) : super.internal();

  final int lastId;
  final int pageSize;

  @override
  Override overrideWith(
    FutureOr<ListData<Pet>> Function(PetListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PetListProvider._internal(
        (ref) => create(ref as PetListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lastId: lastId,
        pageSize: pageSize,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<Pet>> createElement() {
    return _PetListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PetListProvider &&
        other.lastId == lastId &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lastId.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PetListRef on AutoDisposeFutureProviderRef<ListData<Pet>> {
  /// The parameter `lastId` of this provider.
  int get lastId;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _PetListProviderElement
    extends AutoDisposeFutureProviderElement<ListData<Pet>> with PetListRef {
  _PetListProviderElement(super.provider);

  @override
  int get lastId => (origin as PetListProvider).lastId;
  @override
  int get pageSize => (origin as PetListProvider).pageSize;
}

String _$bookedPetsHash() => r'a5ef662fb9b10fd7180cd670dc460a4487551dae';

/// See also [bookedPets].
@ProviderFor(bookedPets)
const bookedPetsProvider = BookedPetsFamily();

/// See also [bookedPets].
class BookedPetsFamily extends Family<AsyncValue<ListData<Pet>>> {
  /// See also [bookedPets].
  const BookedPetsFamily();

  /// See also [bookedPets].
  BookedPetsProvider call([
    int lastId = 0,
    int pageSize = 10,
  ]) {
    return BookedPetsProvider(
      lastId,
      pageSize,
    );
  }

  @override
  BookedPetsProvider getProviderOverride(
    covariant BookedPetsProvider provider,
  ) {
    return call(
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
  String? get name => r'bookedPetsProvider';
}

/// See also [bookedPets].
class BookedPetsProvider extends AutoDisposeFutureProvider<ListData<Pet>> {
  /// See also [bookedPets].
  BookedPetsProvider([
    int lastId = 0,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => bookedPets(
            ref as BookedPetsRef,
            lastId,
            pageSize,
          ),
          from: bookedPetsProvider,
          name: r'bookedPetsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookedPetsHash,
          dependencies: BookedPetsFamily._dependencies,
          allTransitiveDependencies:
              BookedPetsFamily._allTransitiveDependencies,
          lastId: lastId,
          pageSize: pageSize,
        );

  BookedPetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lastId,
    required this.pageSize,
  }) : super.internal();

  final int lastId;
  final int pageSize;

  @override
  Override overrideWith(
    FutureOr<ListData<Pet>> Function(BookedPetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookedPetsProvider._internal(
        (ref) => create(ref as BookedPetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lastId: lastId,
        pageSize: pageSize,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<Pet>> createElement() {
    return _BookedPetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookedPetsProvider &&
        other.lastId == lastId &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lastId.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookedPetsRef on AutoDisposeFutureProviderRef<ListData<Pet>> {
  /// The parameter `lastId` of this provider.
  int get lastId;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _BookedPetsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<Pet>> with BookedPetsRef {
  _BookedPetsProviderElement(super.provider);

  @override
  int get lastId => (origin as BookedPetsProvider).lastId;
  @override
  int get pageSize => (origin as BookedPetsProvider).pageSize;
}

String _$getPetByIdHash() => r'c66c990b58143c75e3fec67ace1a7874237e3d56';

/// See also [getPetById].
@ProviderFor(getPetById)
const getPetByIdProvider = GetPetByIdFamily();

/// See also [getPetById].
class GetPetByIdFamily extends Family<AsyncValue<Pet?>> {
  /// See also [getPetById].
  const GetPetByIdFamily();

  /// See also [getPetById].
  GetPetByIdProvider call(
    int petId,
  ) {
    return GetPetByIdProvider(
      petId,
    );
  }

  @override
  GetPetByIdProvider getProviderOverride(
    covariant GetPetByIdProvider provider,
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
  String? get name => r'getPetByIdProvider';
}

/// See also [getPetById].
class GetPetByIdProvider extends AutoDisposeFutureProvider<Pet?> {
  /// See also [getPetById].
  GetPetByIdProvider(
    int petId,
  ) : this._internal(
          (ref) => getPetById(
            ref as GetPetByIdRef,
            petId,
          ),
          from: getPetByIdProvider,
          name: r'getPetByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPetByIdHash,
          dependencies: GetPetByIdFamily._dependencies,
          allTransitiveDependencies:
              GetPetByIdFamily._allTransitiveDependencies,
          petId: petId,
        );

  GetPetByIdProvider._internal(
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
    FutureOr<Pet?> Function(GetPetByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPetByIdProvider._internal(
        (ref) => create(ref as GetPetByIdRef),
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
  AutoDisposeFutureProviderElement<Pet?> createElement() {
    return _GetPetByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPetByIdProvider && other.petId == petId;
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
mixin GetPetByIdRef on AutoDisposeFutureProviderRef<Pet?> {
  /// The parameter `petId` of this provider.
  int get petId;
}

class _GetPetByIdProviderElement extends AutoDisposeFutureProviderElement<Pet?>
    with GetPetByIdRef {
  _GetPetByIdProviderElement(super.provider);

  @override
  int get petId => (origin as GetPetByIdProvider).petId;
}

String _$getUserByIdHash() => r'c7126e164b7cc2b5ae5ac7bfc57825e39b1f972c';

/// See also [getUserById].
@ProviderFor(getUserById)
const getUserByIdProvider = GetUserByIdFamily();

/// See also [getUserById].
class GetUserByIdFamily extends Family<AsyncValue<User>> {
  /// See also [getUserById].
  const GetUserByIdFamily();

  /// See also [getUserById].
  GetUserByIdProvider call(
    int userId,
  ) {
    return GetUserByIdProvider(
      userId,
    );
  }

  @override
  GetUserByIdProvider getProviderOverride(
    covariant GetUserByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'getUserByIdProvider';
}

/// See also [getUserById].
class GetUserByIdProvider extends AutoDisposeFutureProvider<User> {
  /// See also [getUserById].
  GetUserByIdProvider(
    int userId,
  ) : this._internal(
          (ref) => getUserById(
            ref as GetUserByIdRef,
            userId,
          ),
          from: getUserByIdProvider,
          name: r'getUserByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserByIdHash,
          dependencies: GetUserByIdFamily._dependencies,
          allTransitiveDependencies:
              GetUserByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  GetUserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<User> Function(GetUserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserByIdProvider._internal(
        (ref) => create(ref as GetUserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _GetUserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetUserByIdRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _GetUserByIdProviderElement extends AutoDisposeFutureProviderElement<User>
    with GetUserByIdRef {
  _GetUserByIdProviderElement(super.provider);

  @override
  int get userId => (origin as GetUserByIdProvider).userId;
}

String _$getMyUserHash() => r'61ed52eea89f0f0d871eeab344a47711508ae9fc';

/// See also [getMyUser].
@ProviderFor(getMyUser)
final getMyUserProvider = AutoDisposeFutureProvider<User>.internal(
  getMyUser,
  name: r'getMyUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getMyUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMyUserRef = AutoDisposeFutureProviderRef<User>;
String _$getMyPetDaycareHash() => r'c35f53c843801732554fc581588ea1154513bd95';

/// See also [getMyPetDaycare].
@ProviderFor(getMyPetDaycare)
final getMyPetDaycareProvider =
    AutoDisposeFutureProvider<PetDaycareDetails>.internal(
  getMyPetDaycare,
  name: r'getMyPetDaycareProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMyPetDaycareHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMyPetDaycareRef = AutoDisposeFutureProviderRef<PetDaycareDetails>;
String _$getPetDaycareByIdHash() => r'b10f16a89dfcf94c4853f80471005bc0fca752bf';

/// See also [getPetDaycareById].
@ProviderFor(getPetDaycareById)
const getPetDaycareByIdProvider = GetPetDaycareByIdFamily();

/// See also [getPetDaycareById].
class GetPetDaycareByIdFamily extends Family<AsyncValue<PetDaycareDetails>> {
  /// See also [getPetDaycareById].
  const GetPetDaycareByIdFamily();

  /// See also [getPetDaycareById].
  GetPetDaycareByIdProvider call(
    int petDaycareId,
    double? lat,
    double? long,
  ) {
    return GetPetDaycareByIdProvider(
      petDaycareId,
      lat,
      long,
    );
  }

  @override
  GetPetDaycareByIdProvider getProviderOverride(
    covariant GetPetDaycareByIdProvider provider,
  ) {
    return call(
      provider.petDaycareId,
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
  String? get name => r'getPetDaycareByIdProvider';
}

/// See also [getPetDaycareById].
class GetPetDaycareByIdProvider
    extends AutoDisposeFutureProvider<PetDaycareDetails> {
  /// See also [getPetDaycareById].
  GetPetDaycareByIdProvider(
    int petDaycareId,
    double? lat,
    double? long,
  ) : this._internal(
          (ref) => getPetDaycareById(
            ref as GetPetDaycareByIdRef,
            petDaycareId,
            lat,
            long,
          ),
          from: getPetDaycareByIdProvider,
          name: r'getPetDaycareByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPetDaycareByIdHash,
          dependencies: GetPetDaycareByIdFamily._dependencies,
          allTransitiveDependencies:
              GetPetDaycareByIdFamily._allTransitiveDependencies,
          petDaycareId: petDaycareId,
          lat: lat,
          long: long,
        );

  GetPetDaycareByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.petDaycareId,
    required this.lat,
    required this.long,
  }) : super.internal();

  final int petDaycareId;
  final double? lat;
  final double? long;

  @override
  Override overrideWith(
    FutureOr<PetDaycareDetails> Function(GetPetDaycareByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPetDaycareByIdProvider._internal(
        (ref) => create(ref as GetPetDaycareByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        petDaycareId: petDaycareId,
        lat: lat,
        long: long,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PetDaycareDetails> createElement() {
    return _GetPetDaycareByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPetDaycareByIdProvider &&
        other.petDaycareId == petDaycareId &&
        other.lat == lat &&
        other.long == long;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, petDaycareId.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, long.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPetDaycareByIdRef on AutoDisposeFutureProviderRef<PetDaycareDetails> {
  /// The parameter `petDaycareId` of this provider.
  int get petDaycareId;

  /// The parameter `lat` of this provider.
  double? get lat;

  /// The parameter `long` of this provider.
  double? get long;
}

class _GetPetDaycareByIdProviderElement
    extends AutoDisposeFutureProviderElement<PetDaycareDetails>
    with GetPetDaycareByIdRef {
  _GetPetDaycareByIdProviderElement(super.provider);

  @override
  int get petDaycareId => (origin as GetPetDaycareByIdProvider).petDaycareId;
  @override
  double? get lat => (origin as GetPetDaycareByIdProvider).lat;
  @override
  double? get long => (origin as GetPetDaycareByIdProvider).long;
}

String _$getTransactionsHash() => r'ee85aa24056cade231802008cfb7860591666a63';

/// See also [getTransactions].
@ProviderFor(getTransactions)
const getTransactionsProvider = GetTransactionsFamily();

/// See also [getTransactions].
class GetTransactionsFamily extends Family<AsyncValue<ListData<Transaction>>> {
  /// See also [getTransactions].
  const GetTransactionsFamily();

  /// See also [getTransactions].
  GetTransactionsProvider call([
    int page = 1,
    int pageSize = 10,
  ]) {
    return GetTransactionsProvider(
      page,
      pageSize,
    );
  }

  @override
  GetTransactionsProvider getProviderOverride(
    covariant GetTransactionsProvider provider,
  ) {
    return call(
      provider.page,
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
  String? get name => r'getTransactionsProvider';
}

/// See also [getTransactions].
class GetTransactionsProvider
    extends AutoDisposeFutureProvider<ListData<Transaction>> {
  /// See also [getTransactions].
  GetTransactionsProvider([
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => getTransactions(
            ref as GetTransactionsRef,
            page,
            pageSize,
          ),
          from: getTransactionsProvider,
          name: r'getTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTransactionsHash,
          dependencies: GetTransactionsFamily._dependencies,
          allTransitiveDependencies:
              GetTransactionsFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
        );

  GetTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.pageSize,
  }) : super.internal();

  final int page;
  final int pageSize;

  @override
  Override overrideWith(
    FutureOr<ListData<Transaction>> Function(GetTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTransactionsProvider._internal(
        (ref) => create(ref as GetTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<Transaction>> createElement() {
    return _GetTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTransactionsProvider &&
        other.page == page &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTransactionsRef
    on AutoDisposeFutureProviderRef<ListData<Transaction>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _GetTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<Transaction>>
    with GetTransactionsRef {
  _GetTransactionsProviderElement(super.provider);

  @override
  int get page => (origin as GetTransactionsProvider).page;
  @override
  int get pageSize => (origin as GetTransactionsProvider).pageSize;
}

String _$getReviewsHash() => r'f6d29a64904bd53c9f9a180228baad59a023828c';

/// See also [getReviews].
@ProviderFor(getReviews)
const getReviewsProvider = GetReviewsFamily();

/// See also [getReviews].
class GetReviewsFamily extends Family<AsyncValue<ListData<Reviews>>> {
  /// See also [getReviews].
  const GetReviewsFamily();

  /// See also [getReviews].
  GetReviewsProvider call(
    int petDaycareId, [
    int page = 1,
    int pageSize = 10,
  ]) {
    return GetReviewsProvider(
      petDaycareId,
      page,
      pageSize,
    );
  }

  @override
  GetReviewsProvider getProviderOverride(
    covariant GetReviewsProvider provider,
  ) {
    return call(
      provider.petDaycareId,
      provider.page,
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
  String? get name => r'getReviewsProvider';
}

/// See also [getReviews].
class GetReviewsProvider extends AutoDisposeFutureProvider<ListData<Reviews>> {
  /// See also [getReviews].
  GetReviewsProvider(
    int petDaycareId, [
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => getReviews(
            ref as GetReviewsRef,
            petDaycareId,
            page,
            pageSize,
          ),
          from: getReviewsProvider,
          name: r'getReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getReviewsHash,
          dependencies: GetReviewsFamily._dependencies,
          allTransitiveDependencies:
              GetReviewsFamily._allTransitiveDependencies,
          petDaycareId: petDaycareId,
          page: page,
          pageSize: pageSize,
        );

  GetReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.petDaycareId,
    required this.page,
    required this.pageSize,
  }) : super.internal();

  final int petDaycareId;
  final int page;
  final int pageSize;

  @override
  Override overrideWith(
    FutureOr<ListData<Reviews>> Function(GetReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetReviewsProvider._internal(
        (ref) => create(ref as GetReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        petDaycareId: petDaycareId,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<Reviews>> createElement() {
    return _GetReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReviewsProvider &&
        other.petDaycareId == petDaycareId &&
        other.page == page &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, petDaycareId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetReviewsRef on AutoDisposeFutureProviderRef<ListData<Reviews>> {
  /// The parameter `petDaycareId` of this provider.
  int get petDaycareId;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _GetReviewsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<Reviews>>
    with GetReviewsRef {
  _GetReviewsProviderElement(super.provider);

  @override
  int get petDaycareId => (origin as GetReviewsProvider).petDaycareId;
  @override
  int get page => (origin as GetReviewsProvider).page;
  @override
  int get pageSize => (origin as GetReviewsProvider).pageSize;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
