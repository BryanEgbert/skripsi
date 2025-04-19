// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SizeCategory _$SizeCategoryFromJson(Map<String, dynamic> json) {
  return _SizeCategory.fromJson(json);
}

/// @nodoc
mixin _$SizeCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get minWeight => throw _privateConstructorUsedError;
  double? get maxWeight => throw _privateConstructorUsedError;

  /// Serializes this SizeCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SizeCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SizeCategoryCopyWith<SizeCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SizeCategoryCopyWith<$Res> {
  factory $SizeCategoryCopyWith(
          SizeCategory value, $Res Function(SizeCategory) then) =
      _$SizeCategoryCopyWithImpl<$Res, SizeCategory>;
  @useResult
  $Res call({int id, String name, double minWeight, double? maxWeight});
}

/// @nodoc
class _$SizeCategoryCopyWithImpl<$Res, $Val extends SizeCategory>
    implements $SizeCategoryCopyWith<$Res> {
  _$SizeCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SizeCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? minWeight = null,
    Object? maxWeight = freezed,
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
      minWeight: null == minWeight
          ? _value.minWeight
          : minWeight // ignore: cast_nullable_to_non_nullable
              as double,
      maxWeight: freezed == maxWeight
          ? _value.maxWeight
          : maxWeight // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SizeCategoryImplCopyWith<$Res>
    implements $SizeCategoryCopyWith<$Res> {
  factory _$$SizeCategoryImplCopyWith(
          _$SizeCategoryImpl value, $Res Function(_$SizeCategoryImpl) then) =
      __$$SizeCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, double minWeight, double? maxWeight});
}

/// @nodoc
class __$$SizeCategoryImplCopyWithImpl<$Res>
    extends _$SizeCategoryCopyWithImpl<$Res, _$SizeCategoryImpl>
    implements _$$SizeCategoryImplCopyWith<$Res> {
  __$$SizeCategoryImplCopyWithImpl(
      _$SizeCategoryImpl _value, $Res Function(_$SizeCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SizeCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? minWeight = null,
    Object? maxWeight = freezed,
  }) {
    return _then(_$SizeCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minWeight: null == minWeight
          ? _value.minWeight
          : minWeight // ignore: cast_nullable_to_non_nullable
              as double,
      maxWeight: freezed == maxWeight
          ? _value.maxWeight
          : maxWeight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SizeCategoryImpl implements _SizeCategory {
  const _$SizeCategoryImpl(
      {required this.id,
      required this.name,
      required this.minWeight,
      required this.maxWeight});

  factory _$SizeCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SizeCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final double minWeight;
  @override
  final double? maxWeight;

  @override
  String toString() {
    return 'SizeCategory(id: $id, name: $name, minWeight: $minWeight, maxWeight: $maxWeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SizeCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.minWeight, minWeight) ||
                other.minWeight == minWeight) &&
            (identical(other.maxWeight, maxWeight) ||
                other.maxWeight == maxWeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, minWeight, maxWeight);

  /// Create a copy of SizeCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SizeCategoryImplCopyWith<_$SizeCategoryImpl> get copyWith =>
      __$$SizeCategoryImplCopyWithImpl<_$SizeCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SizeCategoryImplToJson(
      this,
    );
  }
}

abstract class _SizeCategory implements SizeCategory {
  const factory _SizeCategory(
      {required final int id,
      required final String name,
      required final double minWeight,
      required final double? maxWeight}) = _$SizeCategoryImpl;

  factory _SizeCategory.fromJson(Map<String, dynamic> json) =
      _$SizeCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  double get minWeight;
  @override
  double? get maxWeight;

  /// Create a copy of SizeCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SizeCategoryImplCopyWith<_$SizeCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
