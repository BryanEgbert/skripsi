// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booked_slot_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookedSlotAddress _$BookedSlotAddressFromJson(Map<String, dynamic> json) {
  return _BookedSlotAddress.fromJson(json);
}

/// @nodoc
mixin _$BookedSlotAddress {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this BookedSlotAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookedSlotAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookedSlotAddressCopyWith<BookedSlotAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookedSlotAddressCopyWith<$Res> {
  factory $BookedSlotAddressCopyWith(
          BookedSlotAddress value, $Res Function(BookedSlotAddress) then) =
      _$BookedSlotAddressCopyWithImpl<$Res, BookedSlotAddress>;
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
class _$BookedSlotAddressCopyWithImpl<$Res, $Val extends BookedSlotAddress>
    implements $BookedSlotAddressCopyWith<$Res> {
  _$BookedSlotAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookedSlotAddress
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
abstract class _$$BookedSlotAddressImplCopyWith<$Res>
    implements $BookedSlotAddressCopyWith<$Res> {
  factory _$$BookedSlotAddressImplCopyWith(_$BookedSlotAddressImpl value,
          $Res Function(_$BookedSlotAddressImpl) then) =
      __$$BookedSlotAddressImplCopyWithImpl<$Res>;
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
class __$$BookedSlotAddressImplCopyWithImpl<$Res>
    extends _$BookedSlotAddressCopyWithImpl<$Res, _$BookedSlotAddressImpl>
    implements _$$BookedSlotAddressImplCopyWith<$Res> {
  __$$BookedSlotAddressImplCopyWithImpl(_$BookedSlotAddressImpl _value,
      $Res Function(_$BookedSlotAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookedSlotAddress
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
    return _then(_$BookedSlotAddressImpl(
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
class _$BookedSlotAddressImpl implements _BookedSlotAddress {
  _$BookedSlotAddressImpl(
      {required this.id,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.notes});

  factory _$BookedSlotAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookedSlotAddressImplFromJson(json);

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
    return 'BookedSlotAddress(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookedSlotAddressImpl &&
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

  /// Create a copy of BookedSlotAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookedSlotAddressImplCopyWith<_$BookedSlotAddressImpl> get copyWith =>
      __$$BookedSlotAddressImplCopyWithImpl<_$BookedSlotAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookedSlotAddressImplToJson(
      this,
    );
  }
}

abstract class _BookedSlotAddress implements BookedSlotAddress {
  factory _BookedSlotAddress(
      {required final int id,
      required final String name,
      required final String address,
      required final double latitude,
      required final double longitude,
      required final String? notes}) = _$BookedSlotAddressImpl;

  factory _BookedSlotAddress.fromJson(Map<String, dynamic> json) =
      _$BookedSlotAddressImpl.fromJson;

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

  /// Create a copy of BookedSlotAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookedSlotAddressImplCopyWith<_$BookedSlotAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
