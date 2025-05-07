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
      usePickupService: json['usePickupService'] as bool,
      location: json['location'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$BookSlotRequestToJson(BookSlotRequest instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'usePickupService': instance.usePickupService,
      'location': instance.location,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
    };
