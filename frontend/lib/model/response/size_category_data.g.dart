// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SizeCategoryDataImpl _$$SizeCategoryDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SizeCategoryDataImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => SizeCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SizeCategoryDataImplToJson(
        _$SizeCategoryDataImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
