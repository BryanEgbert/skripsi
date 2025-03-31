// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestResponse _$SuggestResponseFromJson(Map<String, dynamic> json) =>
    SuggestResponse(
      (json['suggestions'] as List<dynamic>)
          .map((e) =>
              SuggestionDetailsResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['attribution'] as String,
    );

Map<String, dynamic> _$SuggestResponseToJson(SuggestResponse instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
      'attribution': instance.attribution,
    };

SuggestionDetailsResponse _$SuggestionDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    SuggestionDetailsResponse(
      json['name'] as String,
      json['mapbox_id'] as String,
      json['feature_type'] as String,
      json['address'] as String?,
      json['full_address'] as String?,
      json['place_formatted'] as String,
      AdministrativeUnitType.fromJson(json['context'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SuggestionDetailsResponseToJson(
        SuggestionDetailsResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mapbox_id': instance.mapboxId,
      'feature_type': instance.featureType,
      'address': instance.address,
      'full_address': instance.fullAddress,
      'place_formatted': instance.placeFormatted,
      'context': instance.context,
    };
