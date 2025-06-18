// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pet _$PetFromJson(Map<String, dynamic> json) {
  return _Pet.fromJson(json);
}

/// @nodoc
mixin _$Pet {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl =>
      throw _privateConstructorUsedError; // TODO: remove status
  String get status => throw _privateConstructorUsedError;
  bool get isVaccinated => throw _privateConstructorUsedError;
  User get owner => throw _privateConstructorUsedError;
  bool get neutered => throw _privateConstructorUsedError;
  PetCategory get petCategory => throw _privateConstructorUsedError;

  /// Serializes this Pet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetCopyWith<Pet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetCopyWith<$Res> {
  factory $PetCopyWith(Pet value, $Res Function(Pet) then) =
      _$PetCopyWithImpl<$Res, Pet>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? imageUrl,
      String status,
      bool isVaccinated,
      User owner,
      bool neutered,
      PetCategory petCategory});

  $UserCopyWith<$Res> get owner;
  $PetCategoryCopyWith<$Res> get petCategory;
}

/// @nodoc
class _$PetCopyWithImpl<$Res, $Val extends Pet> implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? status = null,
    Object? isVaccinated = null,
    Object? owner = null,
    Object? neutered = null,
    Object? petCategory = null,
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isVaccinated: null == isVaccinated
          ? _value.isVaccinated
          : isVaccinated // ignore: cast_nullable_to_non_nullable
              as bool,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      neutered: null == neutered
          ? _value.neutered
          : neutered // ignore: cast_nullable_to_non_nullable
              as bool,
      petCategory: null == petCategory
          ? _value.petCategory
          : petCategory // ignore: cast_nullable_to_non_nullable
              as PetCategory,
    ) as $Val);
  }

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get owner {
    return $UserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PetCategoryCopyWith<$Res> get petCategory {
    return $PetCategoryCopyWith<$Res>(_value.petCategory, (value) {
      return _then(_value.copyWith(petCategory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PetImplCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$$PetImplCopyWith(_$PetImpl value, $Res Function(_$PetImpl) then) =
      __$$PetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? imageUrl,
      String status,
      bool isVaccinated,
      User owner,
      bool neutered,
      PetCategory petCategory});

  @override
  $UserCopyWith<$Res> get owner;
  @override
  $PetCategoryCopyWith<$Res> get petCategory;
}

/// @nodoc
class __$$PetImplCopyWithImpl<$Res> extends _$PetCopyWithImpl<$Res, _$PetImpl>
    implements _$$PetImplCopyWith<$Res> {
  __$$PetImplCopyWithImpl(_$PetImpl _value, $Res Function(_$PetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? status = null,
    Object? isVaccinated = null,
    Object? owner = null,
    Object? neutered = null,
    Object? petCategory = null,
  }) {
    return _then(_$PetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isVaccinated: null == isVaccinated
          ? _value.isVaccinated
          : isVaccinated // ignore: cast_nullable_to_non_nullable
              as bool,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      neutered: null == neutered
          ? _value.neutered
          : neutered // ignore: cast_nullable_to_non_nullable
              as bool,
      petCategory: null == petCategory
          ? _value.petCategory
          : petCategory // ignore: cast_nullable_to_non_nullable
              as PetCategory,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PetImpl implements _Pet {
  const _$PetImpl(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.status,
      required this.isVaccinated,
      required this.owner,
      required this.neutered,
      required this.petCategory});

  factory _$PetImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? imageUrl;
// TODO: remove status
  @override
  final String status;
  @override
  final bool isVaccinated;
  @override
  final User owner;
  @override
  final bool neutered;
  @override
  final PetCategory petCategory;

  @override
  String toString() {
    return 'Pet(id: $id, name: $name, imageUrl: $imageUrl, status: $status, isVaccinated: $isVaccinated, owner: $owner, neutered: $neutered, petCategory: $petCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isVaccinated, isVaccinated) ||
                other.isVaccinated == isVaccinated) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.neutered, neutered) ||
                other.neutered == neutered) &&
            (identical(other.petCategory, petCategory) ||
                other.petCategory == petCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, imageUrl, status,
      isVaccinated, owner, neutered, petCategory);

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetImplCopyWith<_$PetImpl> get copyWith =>
      __$$PetImplCopyWithImpl<_$PetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetImplToJson(
      this,
    );
  }
}

abstract class _Pet implements Pet {
  const factory _Pet(
      {required final int id,
      required final String name,
      required final String? imageUrl,
      required final String status,
      required final bool isVaccinated,
      required final User owner,
      required final bool neutered,
      required final PetCategory petCategory}) = _$PetImpl;

  factory _Pet.fromJson(Map<String, dynamic> json) = _$PetImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get imageUrl; // TODO: remove status
  @override
  String get status;
  @override
  bool get isVaccinated;
  @override
  User get owner;
  @override
  bool get neutered;
  @override
  PetCategory get petCategory;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetImplCopyWith<_$PetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
