// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReviewRequest _$CreateReviewRequestFromJson(Map<String, dynamic> json) =>
    CreateReviewRequest(
      rating: (json['rating'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CreateReviewRequestToJson(
        CreateReviewRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'title': instance.title,
      'description': instance.description,
    };
