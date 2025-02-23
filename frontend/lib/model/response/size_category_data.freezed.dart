// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_category_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SizeCategoryData _$SizeCategoryDataFromJson(Map<String, dynamic> json) {
  return _SizeCategoryData.fromJson(json);
}

/// @nodoc
mixin _$SizeCategoryData {
  List<SizeCategory> get data => throw _privateConstructorUsedError;

  /// Serializes this SizeCategoryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SizeCategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SizeCategoryDataCopyWith<SizeCategoryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SizeCategoryDataCopyWith<$Res> {
  factory $SizeCategoryDataCopyWith(
          SizeCategoryData value, $Res Function(SizeCategoryData) then) =
      _$SizeCategoryDataCopyWithImpl<$Res, SizeCategoryData>;
  @useResult
  $Res call({List<SizeCategory> data});
}

/// @nodoc
class _$SizeCategoryDataCopyWithImpl<$Res, $Val extends SizeCategoryData>
    implements $SizeCategoryDataCopyWith<$Res> {
  _$SizeCategoryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SizeCategoryData
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
              as List<SizeCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SizeCategoryDataImplCopyWith<$Res>
    implements $SizeCategoryDataCopyWith<$Res> {
  factory _$$SizeCategoryDataImplCopyWith(_$SizeCategoryDataImpl value,
          $Res Function(_$SizeCategoryDataImpl) then) =
      __$$SizeCategoryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SizeCategory> data});
}

/// @nodoc
class __$$SizeCategoryDataImplCopyWithImpl<$Res>
    extends _$SizeCategoryDataCopyWithImpl<$Res, _$SizeCategoryDataImpl>
    implements _$$SizeCategoryDataImplCopyWith<$Res> {
  __$$SizeCategoryDataImplCopyWithImpl(_$SizeCategoryDataImpl _value,
      $Res Function(_$SizeCategoryDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SizeCategoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SizeCategoryDataImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<SizeCategory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SizeCategoryDataImpl implements _SizeCategoryData {
  const _$SizeCategoryDataImpl({required final List<SizeCategory> data})
      : _data = data;

  factory _$SizeCategoryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SizeCategoryDataImplFromJson(json);

  final List<SizeCategory> _data;
  @override
  List<SizeCategory> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'SizeCategoryData(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SizeCategoryDataImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of SizeCategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SizeCategoryDataImplCopyWith<_$SizeCategoryDataImpl> get copyWith =>
      __$$SizeCategoryDataImplCopyWithImpl<_$SizeCategoryDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SizeCategoryDataImplToJson(
      this,
    );
  }
}

abstract class _SizeCategoryData implements SizeCategoryData {
  const factory _SizeCategoryData({required final List<SizeCategory> data}) =
      _$SizeCategoryDataImpl;

  factory _SizeCategoryData.fromJson(Map<String, dynamic> json) =
      _$SizeCategoryDataImpl.fromJson;

  @override
  List<SizeCategory> get data;

  /// Create a copy of SizeCategoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SizeCategoryDataImplCopyWith<_$SizeCategoryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
