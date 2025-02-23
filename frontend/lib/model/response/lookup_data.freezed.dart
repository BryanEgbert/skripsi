// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lookup_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LookupData _$LookupDataFromJson(Map<String, dynamic> json) {
  return _LookupData.fromJson(json);
}

/// @nodoc
mixin _$LookupData {
  List<Lookup> get data => throw _privateConstructorUsedError;

  /// Serializes this LookupData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LookupData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LookupDataCopyWith<LookupData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LookupDataCopyWith<$Res> {
  factory $LookupDataCopyWith(
          LookupData value, $Res Function(LookupData) then) =
      _$LookupDataCopyWithImpl<$Res, LookupData>;
  @useResult
  $Res call({List<Lookup> data});
}

/// @nodoc
class _$LookupDataCopyWithImpl<$Res, $Val extends LookupData>
    implements $LookupDataCopyWith<$Res> {
  _$LookupDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LookupData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Lookup>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LookupDataImplCopyWith<$Res>
    implements $LookupDataCopyWith<$Res> {
  factory _$$LookupDataImplCopyWith(
          _$LookupDataImpl value, $Res Function(_$LookupDataImpl) then) =
      __$$LookupDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Lookup> data});
}

/// @nodoc
class __$$LookupDataImplCopyWithImpl<$Res>
    extends _$LookupDataCopyWithImpl<$Res, _$LookupDataImpl>
    implements _$$LookupDataImplCopyWith<$Res> {
  __$$LookupDataImplCopyWithImpl(
      _$LookupDataImpl _value, $Res Function(_$LookupDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LookupData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LookupDataImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Lookup>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LookupDataImpl implements _LookupData {
  const _$LookupDataImpl({required final List<Lookup> data}) : _data = data;

  factory _$LookupDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LookupDataImplFromJson(json);

  final List<Lookup> _data;
  @override
  List<Lookup> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'LookupData(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LookupDataImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of LookupData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LookupDataImplCopyWith<_$LookupDataImpl> get copyWith =>
      __$$LookupDataImplCopyWithImpl<_$LookupDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LookupDataImplToJson(
      this,
    );
  }
}

abstract class _LookupData implements LookupData {
  const factory _LookupData({required final List<Lookup> data}) =
      _$LookupDataImpl;

  factory _LookupData.fromJson(Map<String, dynamic> json) =
      _$LookupDataImpl.fromJson;

  @override
  List<Lookup> get data;

  /// Create a copy of LookupData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LookupDataImplCopyWith<_$LookupDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
