// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetCategoryImpl _$$PetCategoryImplFromJson(Map<String, dynamic> json) =>
    _$PetCategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sizeCategory:
          SizeCategory.fromJson(json['sizeCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PetCategoryImplToJson(_$PetCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sizeCategory': instance.sizeCategory,
    };
