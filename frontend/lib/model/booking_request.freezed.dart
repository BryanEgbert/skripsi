// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PetCategoryCount _$PetCategoryCountFromJson(Map<String, dynamic> json) {
  return _PetCategoryCount.fromJson(json);
}

/// @nodoc
mixin _$PetCategoryCount {
  PetCategory get petCategory => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this PetCategoryCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetCategoryCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetCategoryCountCopyWith<PetCategoryCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetCategoryCountCopyWith<$Res> {
  factory $PetCategoryCountCopyWith(
          PetCategoryCount value, $Res Function(PetCategoryCount) then) =
      _$PetCategoryCountCopyWithImpl<$Res, PetCategoryCount>;
  @useResult
  $Res call({PetCategory petCategory, int total});

  $PetCategoryCopyWith<$Res> get petCategory;
}

/// @nodoc
class _$PetCategoryCountCopyWithImpl<$Res, $Val extends PetCategoryCount>
    implements $PetCategoryCountCopyWith<$Res> {
  _$PetCategoryCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetCategoryCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petCategory = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      petCategory: null == petCategory
          ? _value.petCategory
          : petCategory // ignore: cast_nullable_to_non_nullable
              as PetCategory,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PetCategoryCount
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
abstract class _$$PetCategoryCountImplCopyWith<$Res>
    implements $PetCategoryCountCopyWith<$Res> {
  factory _$$PetCategoryCountImplCopyWith(_$PetCategoryCountImpl value,
          $Res Function(_$PetCategoryCountImpl) then) =
      __$$PetCategoryCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PetCategory petCategory, int total});

  @override
  $PetCategoryCopyWith<$Res> get petCategory;
}

/// @nodoc
class __$$PetCategoryCountImplCopyWithImpl<$Res>
    extends _$PetCategoryCountCopyWithImpl<$Res, _$PetCategoryCountImpl>
    implements _$$PetCategoryCountImplCopyWith<$Res> {
  __$$PetCategoryCountImplCopyWithImpl(_$PetCategoryCountImpl _value,
      $Res Function(_$PetCategoryCountImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetCategoryCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petCategory = null,
    Object? total = null,
  }) {
    return _then(_$PetCategoryCountImpl(
      petCategory: null == petCategory
          ? _value.petCategory
          : petCategory // ignore: cast_nullable_to_non_nullable
              as PetCategory,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PetCategoryCountImpl implements _PetCategoryCount {
  _$PetCategoryCountImpl({required this.petCategory, required this.total});

  factory _$PetCategoryCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetCategoryCountImplFromJson(json);

  @override
  final PetCategory petCategory;
  @override
  final int total;

  @override
  String toString() {
    return 'PetCategoryCount(petCategory: $petCategory, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetCategoryCountImpl &&
            (identical(other.petCategory, petCategory) ||
                other.petCategory == petCategory) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, petCategory, total);

  /// Create a copy of PetCategoryCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetCategoryCountImplCopyWith<_$PetCategoryCountImpl> get copyWith =>
      __$$PetCategoryCountImplCopyWithImpl<_$PetCategoryCountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetCategoryCountImplToJson(
      this,
    );
  }
}

abstract class _PetCategoryCount implements PetCategoryCount {
  factory _PetCategoryCount(
      {required final PetCategory petCategory,
      required final int total}) = _$PetCategoryCountImpl;

  factory _PetCategoryCount.fromJson(Map<String, dynamic> json) =
      _$PetCategoryCountImpl.fromJson;

  @override
  PetCategory get petCategory;
  @override
  int get total;

  /// Create a copy of PetCategoryCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetCategoryCountImplCopyWith<_$PetCategoryCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) {
  return _BookingRequest.fromJson(json);
}

/// @nodoc
mixin _$BookingRequest {
  int get id => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  bool get pickupRequired => throw _privateConstructorUsedError;
  List<PetCategoryCount> get petCount => throw _privateConstructorUsedError;
  BookedSlotAddress? get addressInfo => throw _privateConstructorUsedError;
  List<Pet> get bookedPet => throw _privateConstructorUsedError;

  /// Serializes this BookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingRequestCopyWith<BookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingRequestCopyWith<$Res> {
  factory $BookingRequestCopyWith(
          BookingRequest value, $Res Function(BookingRequest) then) =
      _$BookingRequestCopyWithImpl<$Res, BookingRequest>;
  @useResult
  $Res call(
      {int id,
      User user,
      String startDate,
      String endDate,
      bool pickupRequired,
      List<PetCategoryCount> petCount,
      BookedSlotAddress? addressInfo,
      List<Pet> bookedPet});

  $UserCopyWith<$Res> get user;
  $BookedSlotAddressCopyWith<$Res>? get addressInfo;
}

/// @nodoc
class _$BookingRequestCopyWithImpl<$Res, $Val extends BookingRequest>
    implements $BookingRequestCopyWith<$Res> {
  _$BookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? pickupRequired = null,
    Object? petCount = null,
    Object? addressInfo = freezed,
    Object? bookedPet = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      pickupRequired: null == pickupRequired
          ? _value.pickupRequired
          : pickupRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      petCount: null == petCount
          ? _value.petCount
          : petCount // ignore: cast_nullable_to_non_nullable
              as List<PetCategoryCount>,
      addressInfo: freezed == addressInfo
          ? _value.addressInfo
          : addressInfo // ignore: cast_nullable_to_non_nullable
              as BookedSlotAddress?,
      bookedPet: null == bookedPet
          ? _value.bookedPet
          : bookedPet // ignore: cast_nullable_to_non_nullable
              as List<Pet>,
    ) as $Val);
  }

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of BookingRequest
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
abstract class _$$BookingRequestImplCopyWith<$Res>
    implements $BookingRequestCopyWith<$Res> {
  factory _$$BookingRequestImplCopyWith(_$BookingRequestImpl value,
          $Res Function(_$BookingRequestImpl) then) =
      __$$BookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      User user,
      String startDate,
      String endDate,
      bool pickupRequired,
      List<PetCategoryCount> petCount,
      BookedSlotAddress? addressInfo,
      List<Pet> bookedPet});

  @override
  $UserCopyWith<$Res> get user;
  @override
  $BookedSlotAddressCopyWith<$Res>? get addressInfo;
}

/// @nodoc
class __$$BookingRequestImplCopyWithImpl<$Res>
    extends _$BookingRequestCopyWithImpl<$Res, _$BookingRequestImpl>
    implements _$$BookingRequestImplCopyWith<$Res> {
  __$$BookingRequestImplCopyWithImpl(
      _$BookingRequestImpl _value, $Res Function(_$BookingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? pickupRequired = null,
    Object? petCount = null,
    Object? addressInfo = freezed,
    Object? bookedPet = null,
  }) {
    return _then(_$BookingRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      pickupRequired: null == pickupRequired
          ? _value.pickupRequired
          : pickupRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      petCount: null == petCount
          ? _value._petCount
          : petCount // ignore: cast_nullable_to_non_nullable
              as List<PetCategoryCount>,
      addressInfo: freezed == addressInfo
          ? _value.addressInfo
          : addressInfo // ignore: cast_nullable_to_non_nullable
              as BookedSlotAddress?,
      bookedPet: null == bookedPet
          ? _value._bookedPet
          : bookedPet // ignore: cast_nullable_to_non_nullable
              as List<Pet>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingRequestImpl implements _BookingRequest {
  _$BookingRequestImpl(
      {required this.id,
      required this.user,
      required this.startDate,
      required this.endDate,
      required this.pickupRequired,
      required final List<PetCategoryCount> petCount,
      required this.addressInfo,
      required final List<Pet> bookedPet})
      : _petCount = petCount,
        _bookedPet = bookedPet;

  factory _$BookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingRequestImplFromJson(json);

  @override
  final int id;
  @override
  final User user;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final bool pickupRequired;
  final List<PetCategoryCount> _petCount;
  @override
  List<PetCategoryCount> get petCount {
    if (_petCount is EqualUnmodifiableListView) return _petCount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_petCount);
  }

  @override
  final BookedSlotAddress? addressInfo;
  final List<Pet> _bookedPet;
  @override
  List<Pet> get bookedPet {
    if (_bookedPet is EqualUnmodifiableListView) return _bookedPet;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookedPet);
  }

  @override
  String toString() {
    return 'BookingRequest(id: $id, user: $user, startDate: $startDate, endDate: $endDate, pickupRequired: $pickupRequired, petCount: $petCount, addressInfo: $addressInfo, bookedPet: $bookedPet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.pickupRequired, pickupRequired) ||
                other.pickupRequired == pickupRequired) &&
            const DeepCollectionEquality().equals(other._petCount, _petCount) &&
            (identical(other.addressInfo, addressInfo) ||
                other.addressInfo == addressInfo) &&
            const DeepCollectionEquality()
                .equals(other._bookedPet, _bookedPet));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user,
      startDate,
      endDate,
      pickupRequired,
      const DeepCollectionEquality().hash(_petCount),
      addressInfo,
      const DeepCollectionEquality().hash(_bookedPet));

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingRequestImplCopyWith<_$BookingRequestImpl> get copyWith =>
      __$$BookingRequestImplCopyWithImpl<_$BookingRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingRequestImplToJson(
      this,
    );
  }
}

abstract class _BookingRequest implements BookingRequest {
  factory _BookingRequest(
      {required final int id,
      required final User user,
      required final String startDate,
      required final String endDate,
      required final bool pickupRequired,
      required final List<PetCategoryCount> petCount,
      required final BookedSlotAddress? addressInfo,
      required final List<Pet> bookedPet}) = _$BookingRequestImpl;

  factory _BookingRequest.fromJson(Map<String, dynamic> json) =
      _$BookingRequestImpl.fromJson;

  @override
  int get id;
  @override
  User get user;
  @override
  String get startDate;
  @override
  String get endDate;
  @override
  bool get pickupRequired;
  @override
  List<PetCategoryCount> get petCount;
  @override
  BookedSlotAddress? get addressInfo;
  @override
  List<Pet> get bookedPet;

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingRequestImplCopyWith<_$BookingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
