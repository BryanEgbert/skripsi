// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_saved_address_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSavedAddressRequest _$CreateSavedAddressRequestFromJson(
        Map<String, dynamic> json) =>
    CreateSavedAddressRequest(
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreateSavedAddressRequestToJson(
        CreateSavedAddressRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
    };
