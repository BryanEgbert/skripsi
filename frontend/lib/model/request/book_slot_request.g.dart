// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_slot_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSlotRequest _$BookSlotRequestFromJson(Map<String, dynamic> json) =>
    BookSlotRequest(
      petId: (json['petId'] as num).toInt(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$BookSlotRequestToJson(BookSlotRequest instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
