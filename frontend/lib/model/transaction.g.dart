// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      status: Lookup.fromJson(json['status'] as Map<String, dynamic>),
      petDaycare: PetDaycareDetails.fromJson(
          json['petDaycare'] as Map<String, dynamic>),
      bookedPet: (json['bookedPet'] as List<dynamic>)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      bookedSlot:
          BookingRequest.fromJson(json['bookedSlot'] as Map<String, dynamic>),
      addressInfo: json['addressInfo'] == null
          ? null
          : BookedSlotAddress.fromJson(
              json['addressInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'petDaycare': instance.petDaycare,
      'bookedPet': instance.bookedPet,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'bookedSlot': instance.bookedSlot,
      'addressInfo': instance.addressInfo,
    };
