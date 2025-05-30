// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReviewRequest _$CreateReviewRequestFromJson(Map<String, dynamic> json) =>
    CreateReviewRequest(
      rating: (json['rating'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$CreateReviewRequestToJson(
        CreateReviewRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'description': instance.description,
    };
