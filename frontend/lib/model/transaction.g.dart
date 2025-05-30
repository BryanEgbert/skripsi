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
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      bookedSlot:
          BookingRequest.fromJson(json['bookedSlot'] as Map<String, dynamic>),
      addressInfo: json['addressInfo'] == null
          ? null
          : BookedSlotAddress.fromJson(
              json['addressInfo'] as Map<String, dynamic>),
      isReviewed: json['isReviewed'] as bool,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'petDaycare': instance.petDaycare,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'bookedSlot': instance.bookedSlot,
      'addressInfo': instance.addressInfo,
      'isReviewed': instance.isReviewed,
    };
