// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdministrativeUnitType _$AdministrativeUnitTypeFromJson(
        Map<String, dynamic> json) =>
    AdministrativeUnitType(
      json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      json['region'],
      json['postcode'] == null
          ? null
          : LookupStr.fromJson(json['postcode'] as Map<String, dynamic>),
      json['district'] == null
          ? null
          : LookupStr.fromJson(json['district'] as Map<String, dynamic>),
      json['place'] == null
          ? null
          : LookupStr.fromJson(json['place'] as Map<String, dynamic>),
      json['locality'] == null
          ? null
          : LookupStr.fromJson(json['locality'] as Map<String, dynamic>),
      json['neighborhood'] == null
          ? null
          : LookupStr.fromJson(json['neighborhood'] as Map<String, dynamic>),
      json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      json['street'] == null
          ? null
          : LookupStr.fromJson(json['street'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdministrativeUnitTypeToJson(
        AdministrativeUnitType instance) =>
    <String, dynamic>{
      if (instance.country case final value?) 'country': value,
      if (instance.region case final value?) 'region': value,
      if (instance.postcode case final value?) 'postcode': value,
      if (instance.district case final value?) 'district': value,
      if (instance.place case final value?) 'place': value,
      if (instance.locality case final value?) 'locality': value,
      if (instance.neighborhood case final value?) 'neighborhood': value,
      if (instance.address case final value?) 'address': value,
      if (instance.street case final value?) 'street': value,
    };

LookupStr _$LookupStrFromJson(Map<String, dynamic> json) => LookupStr(
      json['id'] as String?,
      json['name'] as String,
    );

Map<String, dynamic> _$LookupStrToJson(LookupStr instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'name': instance.name,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      json['type'] as String,
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'coordinates': instance.coordinates,
      'type': instance.type,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      json['id'] as String?,
      json['name'] as String?,
      json['country_code'] as String?,
      json['country_code_alpha_3'] as String?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.countryCode case final value?) 'country_code': value,
      if (instance.countryCodeAlpha3 case final value?)
        'country_code_alpha_3': value,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      json['id'] as String?,
      json['name'] as String?,
      json['address_number'] as String?,
      json['street_name'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.addressNumber case final value?) 'address_number': value,
      if (instance.streetName case final value?) 'street_name': value,
    };
