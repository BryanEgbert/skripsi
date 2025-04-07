// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lookup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lookup _$LookupFromJson(Map<String, dynamic> json) {
  return _Lookup.fromJson(json);
}

/// @nodoc
mixin _$Lookup {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this Lookup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lookup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LookupCopyWith<Lookup> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LookupCopyWith<$Res> {
  factory $LookupCopyWith(Lookup value, $Res Function(Lookup) then) =
      _$LookupCopyWithImpl<$Res, Lookup>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$LookupCopyWithImpl<$Res, $Val extends Lookup>
    implements $LookupCopyWith<$Res> {
  _$LookupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lookup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LookupImplCopyWith<$Res> implements $LookupCopyWith<$Res> {
  factory _$$LookupImplCopyWith(
          _$LookupImpl value, $Res Function(_$LookupImpl) then) =
      __$$LookupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$LookupImplCopyWithImpl<$Res>
    extends _$LookupCopyWithImpl<$Res, _$LookupImpl>
    implements _$$LookupImplCopyWith<$Res> {
  __$$LookupImplCopyWithImpl(
      _$LookupImpl _value, $Res Function(_$LookupImpl) _then)
      : super(_value, _then);

  /// Create a copy of Lookup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$LookupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LookupImpl implements _Lookup {
  const _$LookupImpl({required this.id, required this.name});

  factory _$LookupImpl.fromJson(Map<String, dynamic> json) =>
      _$$LookupImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LookupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of Lookup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LookupImplCopyWith<_$LookupImpl> get copyWith =>
      __$$LookupImplCopyWithImpl<_$LookupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LookupImplToJson(
      this,
    );
  }
}

abstract class _Lookup implements Lookup {
  const factory _Lookup({required final int id, required final String name}) =
      _$LookupImpl;

  factory _Lookup.fromJson(Map<String, dynamic> json) = _$LookupImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of Lookup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LookupImplCopyWith<_$LookupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
