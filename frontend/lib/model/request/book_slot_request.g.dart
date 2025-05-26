// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_slot_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSlotRequest _$BookSlotRequestFromJson(Map<String, dynamic> json) =>
    BookSlotRequest(
      petId: (json['petId'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      usePickupService: json['usePickupService'] as bool,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      addressId: (json['addressId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookSlotRequestToJson(BookSlotRequest instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'usePickupService': instance.usePickupService,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'addressId': instance.addressId,
    };
