// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$petDaycaresHash() => r'a842982c379670d32ff51a9a3401b37949605652';

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
    r'648d09192a5fea758195be96ff55deb2c9f12f52';

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
String _$getUserChatListHash() => r'd04b895be4294c5fccab5dee2f95e4672baee72d';

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
String _$getSlotsHash() => r'32f861e1169f77554d21d3a583123ac2e85745f3';

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

String _$reducedSlotsHash() => r'6cdaec271737b00acf473685a75f3c2952750675';

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

String _$petHash() => r'66eea8b69eb3995f93a82722d004ebe719782782';

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

String _$vaccineRecordsHash() => r'28dc9ef9fa5e4dcaae7a3609e123dca807e3a6d0';

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

String _$savedAddressHash() => r'a7836c88284762f3b752d9834489d18962a9ff72';

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

String _$savedAddressByIdHash() => r'ca69aeb849f3d0698103ceb821f9c38c88153cc8';

/// See also [savedAddressById].
@ProviderFor(savedAddressById)
const savedAddressByIdProvider = SavedAddressByIdFamily();

/// See also [savedAddressById].
class SavedAddressByIdFamily extends Family<AsyncValue<SavedAddress>> {
  /// See also [savedAddressById].
  const SavedAddressByIdFamily();

  /// See also [savedAddressById].
  SavedAddressByIdProvider call(
    int addressId,
  ) {
    return SavedAddressByIdProvider(
      addressId,
    );
  }

  @override
  SavedAddressByIdProvider getProviderOverride(
    covariant SavedAddressByIdProvider provider,
  ) {
    return call(
      provider.addressId,
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
  String? get name => r'savedAddressByIdProvider';
}

/// See also [savedAddressById].
class SavedAddressByIdProvider extends AutoDisposeFutureProvider<SavedAddress> {
  /// See also [savedAddressById].
  SavedAddressByIdProvider(
    int addressId,
  ) : this._internal(
          (ref) => savedAddressById(
            ref as SavedAddressByIdRef,
            addressId,
          ),
          from: savedAddressByIdProvider,
          name: r'savedAddressByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$savedAddressByIdHash,
          dependencies: SavedAddressByIdFamily._dependencies,
          allTransitiveDependencies:
              SavedAddressByIdFamily._allTransitiveDependencies,
          addressId: addressId,
        );

  SavedAddressByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.addressId,
  }) : super.internal();

  final int addressId;

  @override
  Override overrideWith(
    FutureOr<SavedAddress> Function(SavedAddressByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SavedAddressByIdProvider._internal(
        (ref) => create(ref as SavedAddressByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        addressId: addressId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SavedAddress> createElement() {
    return _SavedAddressByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedAddressByIdProvider && other.addressId == addressId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, addressId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SavedAddressByIdRef on AutoDisposeFutureProviderRef<SavedAddress> {
  /// The parameter `addressId` of this provider.
  int get addressId;
}

class _SavedAddressByIdProviderElement
    extends AutoDisposeFutureProviderElement<SavedAddress>
    with SavedAddressByIdRef {
  _SavedAddressByIdProviderElement(super.provider);

  @override
  int get addressId => (origin as SavedAddressByIdProvider).addressId;
}

String _$getVaccinationRecordByIdHash() =>
    r'0586beadc028eb8712a5a82f0cce0062226ea630';

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

String _$initWebsocketHash() => r'20afbf14789ee588889418f904c72110443a6db9';

/// See also [initWebsocket].
@ProviderFor(initWebsocket)
final initWebsocketProvider = AutoDisposeFutureProvider<void>.internal(
  initWebsocket,
  name: r'initWebsocketProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initWebsocketHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitWebsocketRef = AutoDisposeFutureProviderRef<void>;
String _$chatWebsocketStreamHash() =>
    r'6a1dcf4ed3735bcde3eaba853a0a302e69cdb06f';

/// See also [chatWebsocketStream].
@ProviderFor(chatWebsocketStream)
final chatWebsocketStreamProvider = AutoDisposeStreamProvider<dynamic>.internal(
  chatWebsocketStream,
  name: r'chatWebsocketStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatWebsocketStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatWebsocketStreamRef = AutoDisposeStreamProviderRef<dynamic>;
String _$petListHash() => r'bd0f797936fc9abe01539d4c4c2b64fc620d351f';

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

String _$bookedPetOwnerHash() => r'caf0edc993c879dde11ded5dcccd0ced5d59f75a';

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

String _$bookedPetsHash() => r'b2d7866c85bb0b9b42ad77859debb909cbdc3d60';

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

String _$getPetByIdHash() => r'4e1146cb4cb7cf11d1bbcb1ab411cdc1ea04713e';

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

String _$getUserByIdHash() => r'bd746b43a715ccae13766d24e35c64d82ea53d60';

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

String _$chatMessagesHash() => r'7f18bf1709e210d39a4ed14083905ac72326b057';

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

String _$getVetsHash() => r'7b84dbf5ac948ff19160d4c03e2a1905dda89654';

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

String _$getMyUserHash() => r'93e012e3b376f1f022bf5f83cd655c7c6ba3a0cb';

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
String _$getMyPetDaycareHash() => r'b65293add35e99503a53311f9b213df0f320299a';

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
String _$getPetDaycareByIdHash() => r'46071d24a830a1b8771af4c2288d28432cc0a99c';

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
    r'8cb374d0189bc35539f0f424cbc1e67a2e1242b5';

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

String _$getBookedSlotHash() => r'bf6ec13636a86e2266fb9d4c9f278ec704edb5f7';

/// See also [getBookedSlot].
@ProviderFor(getBookedSlot)
const getBookedSlotProvider = GetBookedSlotFamily();

/// See also [getBookedSlot].
class GetBookedSlotFamily extends Family<AsyncValue<Transaction>> {
  /// See also [getBookedSlot].
  const GetBookedSlotFamily();

  /// See also [getBookedSlot].
  GetBookedSlotProvider call(
    int transactionId,
  ) {
    return GetBookedSlotProvider(
      transactionId,
    );
  }

  @override
  GetBookedSlotProvider getProviderOverride(
    covariant GetBookedSlotProvider provider,
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
  String? get name => r'getBookedSlotProvider';
}

/// See also [getBookedSlot].
class GetBookedSlotProvider extends AutoDisposeFutureProvider<Transaction> {
  /// See also [getBookedSlot].
  GetBookedSlotProvider(
    int transactionId,
  ) : this._internal(
          (ref) => getBookedSlot(
            ref as GetBookedSlotRef,
            transactionId,
          ),
          from: getBookedSlotProvider,
          name: r'getBookedSlotProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBookedSlotHash,
          dependencies: GetBookedSlotFamily._dependencies,
          allTransitiveDependencies:
              GetBookedSlotFamily._allTransitiveDependencies,
          transactionId: transactionId,
        );

  GetBookedSlotProvider._internal(
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
    FutureOr<Transaction> Function(GetBookedSlotRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBookedSlotProvider._internal(
        (ref) => create(ref as GetBookedSlotRef),
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
    return _GetBookedSlotProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBookedSlotProvider &&
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
mixin GetBookedSlotRef on AutoDisposeFutureProviderRef<Transaction> {
  /// The parameter `transactionId` of this provider.
  int get transactionId;
}

class _GetBookedSlotProviderElement
    extends AutoDisposeFutureProviderElement<Transaction>
    with GetBookedSlotRef {
  _GetBookedSlotProviderElement(super.provider);

  @override
  int get transactionId => (origin as GetBookedSlotProvider).transactionId;
}

String _$getBookedSlotsHash() => r'402648c810d14116bd6adefd9bafa783a24bcf86';

/// See also [getBookedSlots].
@ProviderFor(getBookedSlots)
const getBookedSlotsProvider = GetBookedSlotsFamily();

/// See also [getBookedSlots].
class GetBookedSlotsFamily extends Family<AsyncValue<ListData<Transaction>>> {
  /// See also [getBookedSlots].
  const GetBookedSlotsFamily();

  /// See also [getBookedSlots].
  GetBookedSlotsProvider call([
    int page = 1,
    int pageSize = 10,
  ]) {
    return GetBookedSlotsProvider(
      page,
      pageSize,
    );
  }

  @override
  GetBookedSlotsProvider getProviderOverride(
    covariant GetBookedSlotsProvider provider,
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
  String? get name => r'getBookedSlotsProvider';
}

/// See also [getBookedSlots].
class GetBookedSlotsProvider
    extends AutoDisposeFutureProvider<ListData<Transaction>> {
  /// See also [getBookedSlots].
  GetBookedSlotsProvider([
    int page = 1,
    int pageSize = 10,
  ]) : this._internal(
          (ref) => getBookedSlots(
            ref as GetBookedSlotsRef,
            page,
            pageSize,
          ),
          from: getBookedSlotsProvider,
          name: r'getBookedSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBookedSlotsHash,
          dependencies: GetBookedSlotsFamily._dependencies,
          allTransitiveDependencies:
              GetBookedSlotsFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
        );

  GetBookedSlotsProvider._internal(
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
    FutureOr<ListData<Transaction>> Function(GetBookedSlotsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBookedSlotsProvider._internal(
        (ref) => create(ref as GetBookedSlotsRef),
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
    return _GetBookedSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBookedSlotsProvider &&
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
mixin GetBookedSlotsRef on AutoDisposeFutureProviderRef<ListData<Transaction>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;
}

class _GetBookedSlotsProviderElement
    extends AutoDisposeFutureProviderElement<ListData<Transaction>>
    with GetBookedSlotsRef {
  _GetBookedSlotsProviderElement(super.provider);

  @override
  int get page => (origin as GetBookedSlotsProvider).page;
  @override
  int get pageSize => (origin as GetBookedSlotsProvider).pageSize;
}

String _$getReviewsHash() => r'0ea724d6b9cdceea013d1ccbd778f7edabdf1892';

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
