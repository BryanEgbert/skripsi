// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LookupDataImpl _$$LookupDataImplFromJson(Map<String, dynamic> json) =>
    _$LookupDataImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => Lookup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LookupDataImplToJson(_$LookupDataImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
