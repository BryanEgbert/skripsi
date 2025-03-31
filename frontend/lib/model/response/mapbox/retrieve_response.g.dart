// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveResponse _$RetrieveResponseFromJson(Map<String, dynamic> json) =>
    RetrieveResponse(
      json['type'] as String,
      json['attribution'] as String,
      (json['features'] as List<dynamic>)
          .map((e) => RetrieveDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveResponseToJson(RetrieveResponse instance) =>
    <String, dynamic>{
      'type': instance.type,
      'features': instance.features,
      'attribution': instance.attribution,
    };

RetrieveDetails _$RetrieveDetailsFromJson(Map<String, dynamic> json) =>
    RetrieveDetails(
      json['type'] as String,
      Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      RetrieveProperty.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RetrieveDetailsToJson(RetrieveDetails instance) =>
    <String, dynamic>{
      'type': instance.type,
      'geometry': instance.geometry,
      'properties': instance.properties,
    };

RetrieveProperty _$RetrievePropertyFromJson(Map<String, dynamic> json) =>
    RetrieveProperty(
      json['name'] as String,
      json['name_preferred'] as String?,
      json['mapbox_id'] as String,
      json['feature_type'] as String,
      json['address'] as String?,
      json['full_address'] as String?,
      json['place_formatted'] as String?,
      AdministrativeUnitType.fromJson(json['context'] as Map<String, dynamic>),
      Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
      json['language'] as String?,
    );

Map<String, dynamic> _$RetrievePropertyToJson(RetrieveProperty instance) =>
    <String, dynamic>{
      'name': instance.name,
      'name_preferred': instance.namePreferred,
      'mapbox_id': instance.mapboxId,
      'feature_type': instance.featureType,
      'address': instance.address,
      'full_address': instance.fullAddress,
      'place_formatted': instance.placeFormatted,
      'context': instance.context,
      'coordinates': instance.coordinates,
      'language': instance.language,
    };
