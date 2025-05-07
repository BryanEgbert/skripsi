// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reduced_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReducedSlot _$ReducedSlotFromJson(Map<String, dynamic> json) {
  return _ReducedSlot.fromJson(json);
}

/// @nodoc
mixin _$ReducedSlot {
  int get id => throw _privateConstructorUsedError;
  int get slotId => throw _privateConstructorUsedError;
  int get daycareId => throw _privateConstructorUsedError;
  int get reducedCount => throw _privateConstructorUsedError;
  String get targetDate => throw _privateConstructorUsedError;

  /// Serializes this ReducedSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReducedSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReducedSlotCopyWith<ReducedSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReducedSlotCopyWith<$Res> {
  factory $ReducedSlotCopyWith(
          ReducedSlot value, $Res Function(ReducedSlot) then) =
      _$ReducedSlotCopyWithImpl<$Res, ReducedSlot>;
  @useResult
  $Res call(
      {int id, int slotId, int daycareId, int reducedCount, String targetDate});
}

/// @nodoc
class _$ReducedSlotCopyWithImpl<$Res, $Val extends ReducedSlot>
    implements $ReducedSlotCopyWith<$Res> {
  _$ReducedSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReducedSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slotId = null,
    Object? daycareId = null,
    Object? reducedCount = null,
    Object? targetDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as int,
      daycareId: null == daycareId
          ? _value.daycareId
          : daycareId // ignore: cast_nullable_to_non_nullable
              as int,
      reducedCount: null == reducedCount
          ? _value.reducedCount
          : reducedCount // ignore: cast_nullable_to_non_nullable
              as int,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReducedSlotImplCopyWith<$Res>
    implements $ReducedSlotCopyWith<$Res> {
  factory _$$ReducedSlotImplCopyWith(
          _$ReducedSlotImpl value, $Res Function(_$ReducedSlotImpl) then) =
      __$$ReducedSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, int slotId, int daycareId, int reducedCount, String targetDate});
}

/// @nodoc
class __$$ReducedSlotImplCopyWithImpl<$Res>
    extends _$ReducedSlotCopyWithImpl<$Res, _$ReducedSlotImpl>
    implements _$$ReducedSlotImplCopyWith<$Res> {
  __$$ReducedSlotImplCopyWithImpl(
      _$ReducedSlotImpl _value, $Res Function(_$ReducedSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReducedSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slotId = null,
    Object? daycareId = null,
    Object? reducedCount = null,
    Object? targetDate = null,
  }) {
    return _then(_$ReducedSlotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as int,
      daycareId: null == daycareId
          ? _value.daycareId
          : daycareId // ignore: cast_nullable_to_non_nullable
              as int,
      reducedCount: null == reducedCount
          ? _value.reducedCount
          : reducedCount // ignore: cast_nullable_to_non_nullable
              as int,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReducedSlotImpl implements _ReducedSlot {
  const _$ReducedSlotImpl(
      {required this.id,
      required this.slotId,
      required this.daycareId,
      required this.reducedCount,
      required this.targetDate});

  factory _$ReducedSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReducedSlotImplFromJson(json);

  @override
  final int id;
  @override
  final int slotId;
  @override
  final int daycareId;
  @override
  final int reducedCount;
  @override
  final String targetDate;

  @override
  String toString() {
    return 'ReducedSlot(id: $id, slotId: $slotId, daycareId: $daycareId, reducedCount: $reducedCount, targetDate: $targetDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReducedSlotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.daycareId, daycareId) ||
                other.daycareId == daycareId) &&
            (identical(other.reducedCount, reducedCount) ||
                other.reducedCount == reducedCount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, slotId, daycareId, reducedCount, targetDate);

  /// Create a copy of ReducedSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReducedSlotImplCopyWith<_$ReducedSlotImpl> get copyWith =>
      __$$ReducedSlotImplCopyWithImpl<_$ReducedSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReducedSlotImplToJson(
      this,
    );
  }
}

abstract class _ReducedSlot implements ReducedSlot {
  const factory _ReducedSlot(
      {required final int id,
      required final int slotId,
      required final int daycareId,
      required final int reducedCount,
      required final String targetDate}) = _$ReducedSlotImpl;

  factory _ReducedSlot.fromJson(Map<String, dynamic> json) =
      _$ReducedSlotImpl.fromJson;

  @override
  int get id;
  @override
  int get slotId;
  @override
  int get daycareId;
  @override
  int get reducedCount;
  @override
  String get targetDate;

  /// Create a copy of ReducedSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReducedSlotImplCopyWith<_$ReducedSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
