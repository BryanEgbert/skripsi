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
      role: Lookup.fromJson(json['role'] as Map<String, dynamic>),
      vetSpecialties: (json['vetSpecialties'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Lookup.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'role': instance.role,
      'vetSpecialties': instance.vetSpecialties,
      'createdAt': instance.createdAt,
    };
