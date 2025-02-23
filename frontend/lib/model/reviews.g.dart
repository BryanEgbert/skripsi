// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewsImpl _$$ReviewsImplFromJson(Map<String, dynamic> json) =>
    _$ReviewsImpl(
      id: (json['id'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReviewsImplToJson(_$ReviewsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'title': instance.title,
      'description': instance.description,
      'user': instance.user,
    };
