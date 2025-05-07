// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedAddressImpl _$$SavedAddressImplFromJson(Map<String, dynamic> json) =>
    _$SavedAddressImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$SavedAddressImplToJson(_$SavedAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
    };
