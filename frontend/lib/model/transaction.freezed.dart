// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  Lookup get status => throw _privateConstructorUsedError;
  PetDaycareDetails get petDaycare =>
      throw _privateConstructorUsedError; // required List<Pet> bookedPet,
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  BookingRequest get bookedSlot => throw _privateConstructorUsedError;
  BookedSlotAddress? get addressInfo => throw _privateConstructorUsedError;
  bool get isReviewed => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {int id,
      Lookup status,
      PetDaycareDetails petDaycare,
      String startDate,
      String endDate,
      BookingRequest bookedSlot,
      BookedSlotAddress? addressInfo,
      bool isReviewed});

  $LookupCopyWith<$Res> get status;
  $PetDaycareDetailsCopyWith<$Res> get petDaycare;
  $BookingRequestCopyWith<$Res> get bookedSlot;
  $BookedSlotAddressCopyWith<$Res>? get addressInfo;
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? petDaycare = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? bookedSlot = null,
    Object? addressInfo = freezed,
    Object? isReviewed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Lookup,
      petDaycare: null == petDaycare
          ? _value.petDaycare
          : petDaycare // ignore: cast_nullable_to_non_nullable
              as PetDaycareDetails,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      bookedSlot: null == bookedSlot
          ? _value.bookedSlot
          : bookedSlot // ignore: cast_nullable_to_non_nullable
              as BookingRequest,
      addressInfo: freezed == addressInfo
          ? _value.addressInfo
          : addressInfo // ignore: cast_nullable_to_non_nullable
              as BookedSlotAddress?,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LookupCopyWith<$Res> get status {
    return $LookupCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PetDaycareDetailsCopyWith<$Res> get petDaycare {
    return $PetDaycareDetailsCopyWith<$Res>(_value.petDaycare, (value) {
      return _then(_value.copyWith(petDaycare: value) as $Val);
    });
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingRequestCopyWith<$Res> get bookedSlot {
    return $BookingRequestCopyWith<$Res>(_value.bookedSlot, (value) {
      return _then(_value.copyWith(bookedSlot: value) as $Val);
    });
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookedSlotAddressCopyWith<$Res>? get addressInfo {
    if (_value.addressInfo == null) {
      return null;
    }

    return $BookedSlotAddressCopyWith<$Res>(_value.addressInfo!, (value) {
      return _then(_value.copyWith(addressInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      Lookup status,
      PetDaycareDetails petDaycare,
      String startDate,
      String endDate,
      BookingRequest bookedSlot,
      BookedSlotAddress? addressInfo,
      bool isReviewed});

  @override
  $LookupCopyWith<$Res> get status;
  @override
  $PetDaycareDetailsCopyWith<$Res> get petDaycare;
  @override
  $BookingRequestCopyWith<$Res> get bookedSlot;
  @override
  $BookedSlotAddressCopyWith<$Res>? get addressInfo;
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? petDaycare = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? bookedSlot = null,
    Object? addressInfo = freezed,
    Object? isReviewed = null,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Lookup,
      petDaycare: null == petDaycare
          ? _value.petDaycare
          : petDaycare // ignore: cast_nullable_to_non_nullable
              as PetDaycareDetails,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      bookedSlot: null == bookedSlot
          ? _value.bookedSlot
          : bookedSlot // ignore: cast_nullable_to_non_nullable
              as BookingRequest,
      addressInfo: freezed == addressInfo
          ? _value.addressInfo
          : addressInfo // ignore: cast_nullable_to_non_nullable
              as BookedSlotAddress?,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  _$TransactionImpl(
      {required this.id,
      required this.status,
      required this.petDaycare,
      required this.startDate,
      required this.endDate,
      required this.bookedSlot,
      required this.addressInfo,
      required this.isReviewed});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final int id;
  @override
  final Lookup status;
  @override
  final PetDaycareDetails petDaycare;
// required List<Pet> bookedPet,
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final BookingRequest bookedSlot;
  @override
  final BookedSlotAddress? addressInfo;
  @override
  final bool isReviewed;

  @override
  String toString() {
    return 'Transaction(id: $id, status: $status, petDaycare: $petDaycare, startDate: $startDate, endDate: $endDate, bookedSlot: $bookedSlot, addressInfo: $addressInfo, isReviewed: $isReviewed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.petDaycare, petDaycare) ||
                other.petDaycare == petDaycare) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.bookedSlot, bookedSlot) ||
                other.bookedSlot == bookedSlot) &&
            (identical(other.addressInfo, addressInfo) ||
                other.addressInfo == addressInfo) &&
            (identical(other.isReviewed, isReviewed) ||
                other.isReviewed == isReviewed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, petDaycare,
      startDate, endDate, bookedSlot, addressInfo, isReviewed);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  factory _Transaction(
      {required final int id,
      required final Lookup status,
      required final PetDaycareDetails petDaycare,
      required final String startDate,
      required final String endDate,
      required final BookingRequest bookedSlot,
      required final BookedSlotAddress? addressInfo,
      required final bool isReviewed}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  Lookup get status;
  @override
  PetDaycareDetails get petDaycare; // required List<Pet> bookedPet,
  @override
  String get startDate;
  @override
  String get endDate;
  @override
  BookingRequest get bookedSlot;
  @override
  BookedSlotAddress? get addressInfo;
  @override
  bool get isReviewed;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
