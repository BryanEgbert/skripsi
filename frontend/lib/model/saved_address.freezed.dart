// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SavedAddress _$SavedAddressFromJson(Map<String, dynamic> json) {
  return _SavedAddress.fromJson(json);
}

/// @nodoc
mixin _$SavedAddress {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SavedAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedAddressCopyWith<SavedAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedAddressCopyWith<$Res> {
  factory $SavedAddressCopyWith(
          SavedAddress value, $Res Function(SavedAddress) then) =
      _$SavedAddressCopyWithImpl<$Res, SavedAddress>;
  @useResult
  $Res call(
      {int id,
      String name,
      String address,
      double latitude,
      double longitude,
      String? notes});
}

/// @nodoc
class _$SavedAddressCopyWithImpl<$Res, $Val extends SavedAddress>
    implements $SavedAddressCopyWith<$Res> {
  _$SavedAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedAddressImplCopyWith<$Res>
    implements $SavedAddressCopyWith<$Res> {
  factory _$$SavedAddressImplCopyWith(
          _$SavedAddressImpl value, $Res Function(_$SavedAddressImpl) then) =
      __$$SavedAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String address,
      double latitude,
      double longitude,
      String? notes});
}

/// @nodoc
class __$$SavedAddressImplCopyWithImpl<$Res>
    extends _$SavedAddressCopyWithImpl<$Res, _$SavedAddressImpl>
    implements _$$SavedAddressImplCopyWith<$Res> {
  __$$SavedAddressImplCopyWithImpl(
      _$SavedAddressImpl _value, $Res Function(_$SavedAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? notes = freezed,
  }) {
    return _then(_$SavedAddressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedAddressImpl implements _SavedAddress {
  const _$SavedAddressImpl(
      {required this.id,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.notes});

  factory _$SavedAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedAddressImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SavedAddress(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, address, latitude, longitude, notes);

  /// Create a copy of SavedAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedAddressImplCopyWith<_$SavedAddressImpl> get copyWith =>
      __$$SavedAddressImplCopyWithImpl<_$SavedAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedAddressImplToJson(
      this,
    );
  }
}

abstract class _SavedAddress implements SavedAddress {
  const factory _SavedAddress(
      {required final int id,
      required final String name,
      required final String address,
      required final double latitude,
      required final double longitude,
      required final String? notes}) = _$SavedAddressImpl;

  factory _SavedAddress.fromJson(Map<String, dynamic> json) =
      _$SavedAddressImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get notes;

  /// Create a copy of SavedAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedAddressImplCopyWith<_$SavedAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
