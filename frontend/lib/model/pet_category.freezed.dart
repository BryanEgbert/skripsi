// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PetCategory _$PetCategoryFromJson(Map<String, dynamic> json) {
  return _PetCategory.fromJson(json);
}

/// @nodoc
mixin _$PetCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  SizeCategory get sizeCategory => throw _privateConstructorUsedError;

  /// Serializes this PetCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetCategoryCopyWith<PetCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetCategoryCopyWith<$Res> {
  factory $PetCategoryCopyWith(
          PetCategory value, $Res Function(PetCategory) then) =
      _$PetCategoryCopyWithImpl<$Res, PetCategory>;
  @useResult
  $Res call({int id, String name, SizeCategory sizeCategory});

  $SizeCategoryCopyWith<$Res> get sizeCategory;
}

/// @nodoc
class _$PetCategoryCopyWithImpl<$Res, $Val extends PetCategory>
    implements $PetCategoryCopyWith<$Res> {
  _$PetCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sizeCategory = null,
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
      sizeCategory: null == sizeCategory
          ? _value.sizeCategory
          : sizeCategory // ignore: cast_nullable_to_non_nullable
              as SizeCategory,
    ) as $Val);
  }

  /// Create a copy of PetCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SizeCategoryCopyWith<$Res> get sizeCategory {
    return $SizeCategoryCopyWith<$Res>(_value.sizeCategory, (value) {
      return _then(_value.copyWith(sizeCategory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PetCategoryImplCopyWith<$Res>
    implements $PetCategoryCopyWith<$Res> {
  factory _$$PetCategoryImplCopyWith(
          _$PetCategoryImpl value, $Res Function(_$PetCategoryImpl) then) =
      __$$PetCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, SizeCategory sizeCategory});

  @override
  $SizeCategoryCopyWith<$Res> get sizeCategory;
}

/// @nodoc
class __$$PetCategoryImplCopyWithImpl<$Res>
    extends _$PetCategoryCopyWithImpl<$Res, _$PetCategoryImpl>
    implements _$$PetCategoryImplCopyWith<$Res> {
  __$$PetCategoryImplCopyWithImpl(
      _$PetCategoryImpl _value, $Res Function(_$PetCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sizeCategory = null,
  }) {
    return _then(_$PetCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sizeCategory: null == sizeCategory
          ? _value.sizeCategory
          : sizeCategory // ignore: cast_nullable_to_non_nullable
              as SizeCategory,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PetCategoryImpl implements _PetCategory {
  _$PetCategoryImpl(
      {required this.id, required this.name, required this.sizeCategory});

  factory _$PetCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final SizeCategory sizeCategory;

  @override
  String toString() {
    return 'PetCategory(id: $id, name: $name, sizeCategory: $sizeCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sizeCategory, sizeCategory) ||
                other.sizeCategory == sizeCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, sizeCategory);

  /// Create a copy of PetCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetCategoryImplCopyWith<_$PetCategoryImpl> get copyWith =>
      __$$PetCategoryImplCopyWithImpl<_$PetCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetCategoryImplToJson(
      this,
    );
  }
}

abstract class _PetCategory implements PetCategory {
  factory _PetCategory(
      {required final int id,
      required final String name,
      required final SizeCategory sizeCategory}) = _$PetCategoryImpl;

  factory _PetCategory.fromJson(Map<String, dynamic> json) =
      _$PetCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  SizeCategory get sizeCategory;

  /// Create a copy of PetCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetCategoryImplCopyWith<_$PetCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
