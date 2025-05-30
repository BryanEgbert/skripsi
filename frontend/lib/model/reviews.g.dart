// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewsImpl _$$ReviewsImplFromJson(Map<String, dynamic> json) =>
    _$ReviewsImpl(
      id: (json['id'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      description: json['description'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$ReviewsImplToJson(_$ReviewsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'description': instance.description,
      'user': instance.user,
      'createdAt': instance.createdAt,
    };
