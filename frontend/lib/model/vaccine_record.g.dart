// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccine_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaccineRecordImpl _$$VaccineRecordImplFromJson(Map<String, dynamic> json) =>
    _$VaccineRecordImpl(
      id: (json['id'] as num).toInt(),
      dateAdministered: json['dateAdministered'] as String,
      nextDueDate: json['nextDueDate'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$VaccineRecordImplToJson(_$VaccineRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateAdministered': instance.dateAdministered,
      'nextDueDate': instance.nextDueDate,
      'imageUrl': instance.imageUrl,
    };
