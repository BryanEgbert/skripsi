// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$petDaycaresHash() => r'72e6005b4064bcf8f542f477cd455b79c288f1a9';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
