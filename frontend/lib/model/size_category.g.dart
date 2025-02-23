// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SizeCategoryImpl _$$SizeCategoryImplFromJson(Map<String, dynamic> json) =>
    _$SizeCategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      minWeight: (json['minWeight'] as num).toDouble(),
      maxWeight: (json['maxWeight'] as num).toDouble(),
    );

Map<String, dynamic> _$$SizeCategoryImplToJson(_$SizeCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'minWeight': instance.minWeight,
      'maxWeight': instance.maxWeight,
    };
