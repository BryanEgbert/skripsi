// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_slot_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookedSlotAddressImpl _$$BookedSlotAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$BookedSlotAddressImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$BookedSlotAddressImplToJson(
        _$BookedSlotAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
    };
