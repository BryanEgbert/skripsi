// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String,
      roleId: (json['roleId'] as num).toInt(),
      vetSpecialties: (json['vetSpecialties'] as List<dynamic>)
          .map((e) => Lookup.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'roleId': instance.roleId,
      'vetSpecialties': instance.vetSpecialties,
      'createdAt': instance.createdAt,
    };
