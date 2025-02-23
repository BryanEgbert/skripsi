// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String,
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      species: Lookup.fromJson(json['species'] as Map<String, dynamic>),
      sizeCategory:
          SizeCategory.fromJson(json['sizeCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'owner': instance.owner,
      'species': instance.species,
      'sizeCategory': instance.sizeCategory,
    };
