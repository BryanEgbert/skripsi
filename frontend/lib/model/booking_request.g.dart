// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetCategoryCountImpl _$$PetCategoryCountImplFromJson(
        Map<String, dynamic> json) =>
    _$PetCategoryCountImpl(
      petCategory:
          PetCategory.fromJson(json['petCategory'] as Map<String, dynamic>),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$PetCategoryCountImplToJson(
        _$PetCategoryCountImpl instance) =>
    <String, dynamic>{
      'petCategory': instance.petCategory,
      'total': instance.total,
    };

_$BookingRequestImpl _$$BookingRequestImplFromJson(Map<String, dynamic> json) =>
    _$BookingRequestImpl(
      id: (json['id'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      pickupRequired: json['pickupRequired'] as bool,
      petCount: (json['petCount'] as List<dynamic>)
          .map((e) => PetCategoryCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      addressInfo: BookedSlotAddress.fromJson(
          json['addressInfo'] as Map<String, dynamic>),
      bookedPet: (json['bookedPet'] as List<dynamic>)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BookingRequestImplToJson(
        _$BookingRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'pickupRequired': instance.pickupRequired,
      'petCount': instance.petCount,
      'addressInfo': instance.addressInfo,
      'bookedPet': instance.bookedPet,
    };
