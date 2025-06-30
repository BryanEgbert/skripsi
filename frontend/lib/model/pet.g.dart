// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      isVaccinated: json['isVaccinated'] as bool,
      isBooked: json['isBooked'] as bool,
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      neutered: json['neutered'] as bool,
      petCategory:
          PetCategory.fromJson(json['petCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'isVaccinated': instance.isVaccinated,
      'isBooked': instance.isBooked,
      'owner': instance.owner,
      'neutered': instance.neutered,
      'petCategory': instance.petCategory,
    };
