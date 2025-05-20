// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$petDaycaresHash() => r'943e575868429b74ba71eb7568f3cb40947a4d99';

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
    int page = 1,
    int pageSize = 10,
    double minDistance = 0.0,
    double maxDistance = 0.0,
    List<String> facilities = const [],
    bool? mustBeVaccinated,
    int dailyWalks = 0,
    int dailyPlaytime = 0,
    double minPrice = 0.0,
    double maxPrice = 0.0,
    String? pricingType,
  ]) {
    return PetDaycaresProvider(
      lat,
      long,
      page,
      pageSize,
      minDistance,
      maxDistance,
      facilities,
      mustBeVaccinated,
      dailyWalks,
      dailyPlaytime,
      minPrice,
      maxPrice,
      pricingType,
    );
  }

  @override
  PetDaycaresProvider getProviderOverride(
    covariant PetDaycaresProvider provider,
  ) {
    return call(
      provider.lat,
      provider.long,
      provider.page,
      provider.pageSize,
      provider.minDistance,
      provider.maxDistance,
      provider.facilities,
      provider.mustBeVaccinated,
      provider.dailyWalks,
      provider.dailyPlaytime,
      provider.minPrice,
      provider.maxPrice,
      provider.pricingType,
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
    int page = 1,
    int pageSize = 10,
    double minDistance = 0.0,
    double maxDistance = 0.0,
    List<String> facilities = const [],
    bool? mustBeVaccinated,
    int dailyWalks = 0,
    int dailyPlaytime = 0,
    double minPrice = 0.0,
    double maxPrice = 0.0,
    String? pricingType,
  ]) : this._internal(
          (ref) => petDaycares(
            ref as PetDaycaresRef,
            lat,
            long,
            page,
            pageSize,
            minDistance,
            maxDistance,
            facilities,
            mustBeVaccinated,
            dailyWalks,
            dailyPlaytime,
            minPrice,
            maxPrice,
            pricingType,
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
          page: page,
          pageSize: pageSize,
          minDistance: minDistance,
          maxDistance: maxDistance,
          facilities: facilities,
          mustBeVaccinated: mustBeVaccinated,
          dailyWalks: dailyWalks,
          dailyPlaytime: dailyPlaytime,
          minPrice: minPrice,
          maxPrice: maxPrice,
          pricingType: pricingType,
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
    required this.page,
    required this.pageSize,
    required this.minDistance,
    required this.maxDistance,
    required this.facilities,
    required this.mustBeVaccinated,
    required this.dailyWalks,
    required this.dailyPlaytime,
    required this.minPrice,
    required this.maxPrice,
    required this.pricingType,
  }) : super.internal();

  final double? lat;
  final double? long;
  final int page;
  final int pageSize;
  final double minDistance;
  final double maxDistance;
  final List<String> facilities;
  final bool? mustBeVaccinated;
  final int dailyWalks;
  final int dailyPlaytime;
  final double minPrice;
  final double maxPrice;
  final String? pricingType;

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
        page: page,
        pageSize: pageSize,
        minDistance: minDistance,
        maxDistance: maxDistance,
        facilities: facilities,
        mustBeVaccinated: mustBeVaccinated,
        dailyWalks: dailyWalks,
        dailyPlaytime: dailyPlaytime,
        minPrice: minPrice,
        maxPrice: maxPrice,
        pricingType: pricingType,
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
        other.page == page &&
        other.pageSize == pageSize &&
        other.minDistance == minDistance &&
        other.maxDistance == maxDistance &&
        other.facilities == facilities &&
        other.mustBeVaccinated == mustBeVaccinated &&
        other.dailyWalks == dailyWalks &&
        other.dailyPlaytime == dailyPlaytime &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        other.pricingType == pricingType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, long.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);
    hash = _SystemHash.combine(hash, minDistance.hashCode);
    hash = _SystemHash.combine(hash, maxDistance.hashCode);
    hash = _SystemHash.combine(hash, facilities.hashCode);
    hash = _SystemHash.combine(hash, mustBeVaccinated.hashCode);
    hash = _SystemHash.combine(hash, dailyWalks.hashCode);
    hash = _SystemHash.combine(hash, dailyPlaytime.hashCode);
    hash = _SystemHash.combine(hash, minPrice.hashCode);
    hash = _SystemHash.combine(hash, maxPrice.hashCode);
    hash = _SystemHash.combine(hash, pricingType.hashCode);

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

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;

  /// The parameter `minDistance` of this provider.
  double get minDistance;

  /// The parameter `maxDistance` of this provider.
  double get maxDistance;

  /// The parameter `facilities` of this provider.
  List<String> get facilities;

  /// The parameter `mustBeVaccinated` of this provider.
  bool? get mustBeVaccinated;

  /// The parameter `dailyWalks` of this provider.
  int get dailyWalks;

  /// The parameter `dailyPlaytime` of this provider.
  int get dailyPlaytime;

  /// The parameter `minPrice` of this provider.
  double get minPrice;

  /// The parameter `maxPrice` of this provider.
  double get maxPrice;

  /// The parameter `pricingType` of this provider.
  String? get pricingType;
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
  int get page => (origin as PetDaycaresProvider).page;
  @override
  int get pageSize => (origin as PetDaycaresProvider).pageSize;
  @override
  double get minDistance => (origin as PetDaycaresProvider).minDistance;
  @override
  double get maxDistance => (origin as PetDaycaresProvider).maxDistance;
  @override
  List<String> get facilities => (origin as PetDaycaresProvider).facilities;
  @override
  bool? get mustBeVaccinated =>
      (origin as PetDaycaresProvider).mustBeVaccinated;
  @override
  int get dailyWalks => (origin as PetDaycaresProvider).dailyWalks;
  @override
  int get dailyPlaytime => (origin as PetDaycaresProvider).dailyPlaytime;
  @override
  double get minPrice => (origin as PetDaycaresProvider).minPrice;
  @override
  double get maxPrice => (origin as PetDaycaresProvider).maxPrice;
  @override
  String? get pricingType => (origin as PetDaycaresProvider).pricingType;
}

String _$getUnreadChatMessagesHash() =>
    r'c013cbf729ae629f9af718f46980382897c9c12e';

/// See also [getUnreadChatMessages].
@ProviderFor(getUnreadChatMessages)
final getUnreadChatMessagesProvider =
    AutoDisposeFutureProvider<ListData<ChatMessage>>.internal(
  getUnreadChatMessages,
  name: r'getUnreadChatMessagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUnreadChatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetUnreadChatMessagesRef
    = AutoDisposeFutureProviderRef<ListData<ChatMessage>>;
String _$getUserChatListHash() => r'6278a948e5c83ec912ea7f8815dd91772c57660d';

/// See also [getUserChatList].
@ProviderFor(getUserChatList)
final getUserChatListProvider =
    AutoDisposeFutureProvider<ListData<User>>.internal(
  getUserChatList,
  name: r'getUserChatListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserChatListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetUserChatListRef = AutoDisposeFutureProviderRef<ListData<User>>;
String _$getSlotsHash() => r'82529f18c957b7af727a2bdca1ea0b07b05db63b';

/// See also [getSlots].
@ProviderFor(getSlots)
const getSlotsProvider = GetSlotsFamily();

/// See also [getSlots].
class GetSlotsFamily extends Family<AsyncValue<ListData<Slot>>> {
  /// See also [getSlots].
  const GetSlotsFamily();

  /// See also [getSlots].
  GetSlotsProvider call(
    int petDaycareId,
    List<int> petCategoryIds,
  ) {
    return GetSlotsProvider(
      petDaycareId,
      petCategoryIds,
    );
  }

  @override
  GetSlotsProvider getProviderOverride(
    covariant GetSlotsProvider provider,
  ) {
    return call(
      provider.petDaycareId,
      provider.petCategoryIds,
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
  String? get name => r'getSlotsProvider';
}

/// See also [getSlots].
class GetSlotsProvider extends AutoDisposeFutureProvider<ListData<Slot>> {
  /// See also [getSlots].
  GetSlotsProvider(
    int petDaycareId,
    List<int> petCategoryIds,
  ) : this._internal(
          (ref) => getSlots(
            ref as GetSlotsRef,
            petDaycareId,
            petCategoryIds,
          ),
          from: getSlotsProvider,
          name: r'getSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSlotsHash,
          dependencies: GetSlotsFamily._dependencies,
          allTransitiveDependencies: GetSlotsFamily._allTransitiveDependencies,
          petDaycareId: petDaycareId,
          petCategoryIds: petCategoryIds,
        );

  GetSlotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.petDaycareId,
    required this.petCategoryIds,
  }) : super.internal();

  final int petDaycareId;
  final List<int> petCategoryIds;

  @override
  Override overrideWith(
    FutureOr<ListData<Slot>> Function(GetSlotsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSlotsProvider._internal(
        (ref) => create(ref as GetSlotsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        petDaycareId: petDaycareId,
        petCategoryIds: petCategoryIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<Slot>> createElement() {
    return _GetSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSlotsProvider &&
        other.petDaycareId == petDaycareId &&
        other.petCategoryIds == petCategoryIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, petDaycareId.hashCode);
    hash = _SystemHash.combine(hash, petCategoryIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSlotsRef on AutoDisposeFutureProviderRef<ListData<Slot>> {
  /// The parameter `petDaycareId` of this provider.
  int get petDaycareId;

  /// The parameter `petCategoryIds` of this provider.
  List<int> get petCategoryIds;
}

class _GetSlotsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<Slot>> with GetSlotsRef {
  _GetSlotsProviderElement(super.provider);

  @override
  int get petDaycareId => (origin as GetSlotsProvider).petDaycareId;
  @override
  List<int> get petCategoryIds => (origin as GetSlotsProvider).petCategoryIds;
}

String _$reducedSlotsHash() => r'7a7321901eb4ad089bb4adafb9dfc4f893b8e9d6';

/// See also [reducedSlots].
@ProviderFor(reducedSlots)
const reducedSlotsProvider = ReducedSlotsFamily();

/// See also [reducedSlots].
class ReducedSlotsFamily extends Family<AsyncValue<ListData<ReducedSlot>>> {
  /// See also [reducedSlots].
  const ReducedSlotsFamily();

  /// See also [reducedSlots].
  ReducedSlotsProvider call([
    int page = 1,
    int pageSize = 10,
  ]) {
    return ReducedSlotsProvider(
      page,
      pageSize,
    );
  }

  @override
  ReducedSlotsProvider getProviderOverride(
    covariant ReducedSlotsProvider provider,
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
  String? get name => r'reducedSlotsProvider';
}

/// See also [reducedSlots].
class ReducedSlotsProvider
    extends AutoDisposeFutureProvider<ListData<ReducedSlot>> {
  /// See also [reducedSlots].
  ReducedSlotsProvider([
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => reducedSlots(
            ref as ReducedSlotsRef,
            page,
            pageSize,
          ),
          from: reducedSlotsProvider,
          name: r'reducedSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reducedSlotsHash,
          dependencies: ReducedSlotsFamily._dependencies,
          allTransitiveDependencies:
              ReducedSlotsFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
        );

  ReducedSlotsProvider._internal(
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
    FutureOr<ListData<ReducedSlot>> Function(ReducedSlotsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReducedSlotsProvider._internal(
        (ref) => create(ref as ReducedSlotsRef),
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
  AutoDisposeFutureProviderElement<ListData<ReducedSlot>> createElement() {
    return _ReducedSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReducedSlotsProvider &&
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
mixin ReducedSlotsRef on AutoDisposeFutureProviderRef<ListData<ReducedSlot>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _ReducedSlotsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<ReducedSlot>>
    with ReducedSlotsRef {
  _ReducedSlotsProviderElement(super.provider);

  @override
  int get page => (origin as ReducedSlotsProvider).page;
  @override
  int get pageSize => (origin as ReducedSlotsProvider).pageSize;
}

String _$petHash() => r'bc89e0fff1d2594ebf58cb63ae4bcd25c6aa658b';

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

String _$vaccineRecordsHash() => r'2024613e7414b89645e35a04c5ba474ea3817dde';

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
    int page = 1,
    int pageSize = 10,
  ]) {
    return VaccineRecordsProvider(
      petId,
      page,
      pageSize,
    );
  }

  @override
  VaccineRecordsProvider getProviderOverride(
    covariant VaccineRecordsProvider provider,
  ) {
    return call(
      provider.petId,
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
  String? get name => r'vaccineRecordsProvider';
}

/// See also [vaccineRecords].
class VaccineRecordsProvider
    extends AutoDisposeFutureProvider<ListData<VaccineRecord>> {
  /// See also [vaccineRecords].
  VaccineRecordsProvider(
    int petId, [
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => vaccineRecords(
            ref as VaccineRecordsRef,
            petId,
            page,
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
          page: page,
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
    required this.page,
    required this.pageSize,
  }) : super.internal();

  final int petId;
  final int page;
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
        page: page,
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
        other.page == page &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, petId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
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

  /// The parameter `page` of this provider.
  int get page;

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
  int get page => (origin as VaccineRecordsProvider).page;
  @override
  int get pageSize => (origin as VaccineRecordsProvider).pageSize;
}

String _$savedAddressHash() => r'573a5fa950c23a824ed323bec23b61ef0d44b850';

/// See also [savedAddress].
@ProviderFor(savedAddress)
const savedAddressProvider = SavedAddressFamily();

/// See also [savedAddress].
class SavedAddressFamily extends Family<AsyncValue<ListData<SavedAddress>>> {
  /// See also [savedAddress].
  const SavedAddressFamily();

  /// See also [savedAddress].
  SavedAddressProvider call([
    int page = 1,
    int pageSize = 10,
  ]) {
    return SavedAddressProvider(
      page,
      pageSize,
    );
  }

  @override
  SavedAddressProvider getProviderOverride(
    covariant SavedAddressProvider provider,
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
  String? get name => r'savedAddressProvider';
}

/// See also [savedAddress].
class SavedAddressProvider
    extends AutoDisposeFutureProvider<ListData<SavedAddress>> {
  /// See also [savedAddress].
  SavedAddressProvider([
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => savedAddress(
            ref as SavedAddressRef,
            page,
            pageSize,
          ),
          from: savedAddressProvider,
          name: r'savedAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$savedAddressHash,
          dependencies: SavedAddressFamily._dependencies,
          allTransitiveDependencies:
              SavedAddressFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
        );

  SavedAddressProvider._internal(
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
    FutureOr<ListData<SavedAddress>> Function(SavedAddressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SavedAddressProvider._internal(
        (ref) => create(ref as SavedAddressRef),
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
  AutoDisposeFutureProviderElement<ListData<SavedAddress>> createElement() {
    return _SavedAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedAddressProvider &&
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
mixin SavedAddressRef on AutoDisposeFutureProviderRef<ListData<SavedAddress>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _SavedAddressProviderElement
    extends AutoDisposeFutureProviderElement<ListData<SavedAddress>>
    with SavedAddressRef {
  _SavedAddressProviderElement(super.provider);

  @override
  int get page => (origin as SavedAddressProvider).page;
  @override
  int get pageSize => (origin as SavedAddressProvider).pageSize;
}

String _$getVaccinationRecordByIdHash() =>
    r'1bfe653f122acc77e386e60ec08390d2e8d346e4';

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

String _$petListHash() => r'c409decdc18fbfa41dc5768f676016a784e2f1bf';

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

String _$bookedPetOwnerHash() => r'8196dbebfb3d7491392e1446d10da2e2b70484d3';

/// See also [bookedPetOwner].
@ProviderFor(bookedPetOwner)
const bookedPetOwnerProvider = BookedPetOwnerFamily();

/// See also [bookedPetOwner].
class BookedPetOwnerFamily extends Family<AsyncValue<ListData<User>>> {
  /// See also [bookedPetOwner].
  const BookedPetOwnerFamily();

  /// See also [bookedPetOwner].
  BookedPetOwnerProvider call([
    int page = 1,
    int pageSize = 10,
  ]) {
    return BookedPetOwnerProvider(
      page,
      pageSize,
    );
  }

  @override
  BookedPetOwnerProvider getProviderOverride(
    covariant BookedPetOwnerProvider provider,
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
  String? get name => r'bookedPetOwnerProvider';
}

/// See also [bookedPetOwner].
class BookedPetOwnerProvider extends AutoDisposeFutureProvider<ListData<User>> {
  /// See also [bookedPetOwner].
  BookedPetOwnerProvider([
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => bookedPetOwner(
            ref as BookedPetOwnerRef,
            page,
            pageSize,
          ),
          from: bookedPetOwnerProvider,
          name: r'bookedPetOwnerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookedPetOwnerHash,
          dependencies: BookedPetOwnerFamily._dependencies,
          allTransitiveDependencies:
              BookedPetOwnerFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
        );

  BookedPetOwnerProvider._internal(
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
    FutureOr<ListData<User>> Function(BookedPetOwnerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookedPetOwnerProvider._internal(
        (ref) => create(ref as BookedPetOwnerRef),
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
  AutoDisposeFutureProviderElement<ListData<User>> createElement() {
    return _BookedPetOwnerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookedPetOwnerProvider &&
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
mixin BookedPetOwnerRef on AutoDisposeFutureProviderRef<ListData<User>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _BookedPetOwnerProviderElement
    extends AutoDisposeFutureProviderElement<ListData<User>>
    with BookedPetOwnerRef {
  _BookedPetOwnerProviderElement(super.provider);

  @override
  int get page => (origin as BookedPetOwnerProvider).page;
  @override
  int get pageSize => (origin as BookedPetOwnerProvider).pageSize;
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

String _$chatMessagesHash() => r'0c96a5e10ecf7d9d598523b9159c967e4ed97704';

/// See also [chatMessages].
@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// See also [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<ListData<ChatMessage>>> {
  /// See also [chatMessages].
  const ChatMessagesFamily();

  /// See also [chatMessages].
  ChatMessagesProvider call(
    int receiverId,
  ) {
    return ChatMessagesProvider(
      receiverId,
    );
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(
      provider.receiverId,
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
  String? get name => r'chatMessagesProvider';
}

/// See also [chatMessages].
class ChatMessagesProvider
    extends AutoDisposeFutureProvider<ListData<ChatMessage>> {
  /// See also [chatMessages].
  ChatMessagesProvider(
    int receiverId,
  ) : this._internal(
          (ref) => chatMessages(
            ref as ChatMessagesRef,
            receiverId,
          ),
          from: chatMessagesProvider,
          name: r'chatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesHash,
          dependencies: ChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesFamily._allTransitiveDependencies,
          receiverId: receiverId,
        );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.receiverId,
  }) : super.internal();

  final int receiverId;

  @override
  Override overrideWith(
    FutureOr<ListData<ChatMessage>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        receiverId: receiverId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<ChatMessage>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.receiverId == receiverId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, receiverId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeFutureProviderRef<ListData<ChatMessage>> {
  /// The parameter `receiverId` of this provider.
  int get receiverId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeFutureProviderElement<ListData<ChatMessage>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  int get receiverId => (origin as ChatMessagesProvider).receiverId;
}

String _$getVetsHash() => r'58e957b0d8d95f6ee404623181fd4dfadd2b485c';

/// See also [getVets].
@ProviderFor(getVets)
const getVetsProvider = GetVetsFamily();

/// See also [getVets].
class GetVetsFamily extends Family<AsyncValue<ListData<User>>> {
  /// See also [getVets].
  const GetVetsFamily();

  /// See also [getVets].
  GetVetsProvider call([
    int lastId = 0,
    int pageSize = 10,
    int vetSpecialtyId = 0,
  ]) {
    return GetVetsProvider(
      lastId,
      pageSize,
      vetSpecialtyId,
    );
  }

  @override
  GetVetsProvider getProviderOverride(
    covariant GetVetsProvider provider,
  ) {
    return call(
      provider.lastId,
      provider.pageSize,
      provider.vetSpecialtyId,
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
  String? get name => r'getVetsProvider';
}

/// See also [getVets].
class GetVetsProvider extends AutoDisposeFutureProvider<ListData<User>> {
  /// See also [getVets].
  GetVetsProvider([
    int lastId = 0,
    int pageSize = 10,
    int vetSpecialtyId = 0,
  ]) : this._internal(
          (ref) => getVets(
            ref as GetVetsRef,
            lastId,
            pageSize,
            vetSpecialtyId,
          ),
          from: getVetsProvider,
          name: r'getVetsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getVetsHash,
          dependencies: GetVetsFamily._dependencies,
          allTransitiveDependencies: GetVetsFamily._allTransitiveDependencies,
          lastId: lastId,
          pageSize: pageSize,
          vetSpecialtyId: vetSpecialtyId,
        );

  GetVetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lastId,
    required this.pageSize,
    required this.vetSpecialtyId,
  }) : super.internal();

  final int lastId;
  final int pageSize;
  final int vetSpecialtyId;

  @override
  Override overrideWith(
    FutureOr<ListData<User>> Function(GetVetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVetsProvider._internal(
        (ref) => create(ref as GetVetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lastId: lastId,
        pageSize: pageSize,
        vetSpecialtyId: vetSpecialtyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ListData<User>> createElement() {
    return _GetVetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVetsProvider &&
        other.lastId == lastId &&
        other.pageSize == pageSize &&
        other.vetSpecialtyId == vetSpecialtyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lastId.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);
    hash = _SystemHash.combine(hash, vetSpecialtyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVetsRef on AutoDisposeFutureProviderRef<ListData<User>> {
  /// The parameter `lastId` of this provider.
  int get lastId;

  /// The parameter `pageSize` of this provider.
  int get pageSize;

  /// The parameter `vetSpecialtyId` of this provider.
  int get vetSpecialtyId;
}

class _GetVetsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<User>> with GetVetsRef {
  _GetVetsProviderElement(super.provider);

  @override
  int get lastId => (origin as GetVetsProvider).lastId;
  @override
  int get pageSize => (origin as GetVetsProvider).pageSize;
  @override
  int get vetSpecialtyId => (origin as GetVetsProvider).vetSpecialtyId;
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

String _$getBookingRequestsHash() =>
    r'f35d96cc499a4b716edebc0953d8a57d173d6052';

/// See also [getBookingRequests].
@ProviderFor(getBookingRequests)
const getBookingRequestsProvider = GetBookingRequestsFamily();

/// See also [getBookingRequests].
class GetBookingRequestsFamily
    extends Family<AsyncValue<ListData<BookingRequest>>> {
  /// See also [getBookingRequests].
  const GetBookingRequestsFamily();

  /// See also [getBookingRequests].
  GetBookingRequestsProvider call([
    int page = 1,
    int pageSize = 10,
  ]) {
    return GetBookingRequestsProvider(
      page,
      pageSize,
    );
  }

  @override
  GetBookingRequestsProvider getProviderOverride(
    covariant GetBookingRequestsProvider provider,
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
  String? get name => r'getBookingRequestsProvider';
}

/// See also [getBookingRequests].
class GetBookingRequestsProvider
    extends AutoDisposeFutureProvider<ListData<BookingRequest>> {
  /// See also [getBookingRequests].
  GetBookingRequestsProvider([
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => getBookingRequests(
            ref as GetBookingRequestsRef,
            page,
            pageSize,
          ),
          from: getBookingRequestsProvider,
          name: r'getBookingRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBookingRequestsHash,
          dependencies: GetBookingRequestsFamily._dependencies,
          allTransitiveDependencies:
              GetBookingRequestsFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
        );

  GetBookingRequestsProvider._internal(
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
    FutureOr<ListData<BookingRequest>> Function(GetBookingRequestsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBookingRequestsProvider._internal(
        (ref) => create(ref as GetBookingRequestsRef),
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
  AutoDisposeFutureProviderElement<ListData<BookingRequest>> createElement() {
    return _GetBookingRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBookingRequestsProvider &&
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
mixin GetBookingRequestsRef
    on AutoDisposeFutureProviderRef<ListData<BookingRequest>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _GetBookingRequestsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<BookingRequest>>
    with GetBookingRequestsRef {
  _GetBookingRequestsProviderElement(super.provider);

  @override
  int get page => (origin as GetBookingRequestsProvider).page;
  @override
  int get pageSize => (origin as GetBookingRequestsProvider).pageSize;
}

String _$getTransactionHash() => r'cc7a38272599754817ba4a9fddef7a9460054726';

/// See also [getTransaction].
@ProviderFor(getTransaction)
const getTransactionProvider = GetTransactionFamily();

/// See also [getTransaction].
class GetTransactionFamily extends Family<AsyncValue<Transaction>> {
  /// See also [getTransaction].
  const GetTransactionFamily();

  /// See also [getTransaction].
  GetTransactionProvider call(
    int transactionId,
  ) {
    return GetTransactionProvider(
      transactionId,
    );
  }

  @override
  GetTransactionProvider getProviderOverride(
    covariant GetTransactionProvider provider,
  ) {
    return call(
      provider.transactionId,
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
  String? get name => r'getTransactionProvider';
}

/// See also [getTransaction].
class GetTransactionProvider extends AutoDisposeFutureProvider<Transaction> {
  /// See also [getTransaction].
  GetTransactionProvider(
    int transactionId,
  ) : this._internal(
          (ref) => getTransaction(
            ref as GetTransactionRef,
            transactionId,
          ),
          from: getTransactionProvider,
          name: r'getTransactionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTransactionHash,
          dependencies: GetTransactionFamily._dependencies,
          allTransitiveDependencies:
              GetTransactionFamily._allTransitiveDependencies,
          transactionId: transactionId,
        );

  GetTransactionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transactionId,
  }) : super.internal();

  final int transactionId;

  @override
  Override overrideWith(
    FutureOr<Transaction> Function(GetTransactionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTransactionProvider._internal(
        (ref) => create(ref as GetTransactionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transactionId: transactionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Transaction> createElement() {
    return _GetTransactionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTransactionProvider &&
        other.transactionId == transactionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transactionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTransactionRef on AutoDisposeFutureProviderRef<Transaction> {
  /// The parameter `transactionId` of this provider.
  int get transactionId;
}

class _GetTransactionProviderElement
    extends AutoDisposeFutureProviderElement<Transaction>
    with GetTransactionRef {
  _GetTransactionProviderElement(super.provider);

  @override
  int get transactionId => (origin as GetTransactionProvider).transactionId;
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
