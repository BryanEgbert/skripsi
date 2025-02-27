// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reduce_slot_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReduceSlotRequest _$ReduceSlotRequestFromJson(Map<String, dynamic> json) =>
    ReduceSlotRequest(
      reducedCount: (json['reducedCount'] as num).toInt(),
      targetDate: json['targetDate'] as String,
    );

Map<String, dynamic> _$ReduceSlotRequestToJson(ReduceSlotRequest instance) =>
    <String, dynamic>{
      'reducedCount': instance.reducedCount,
      'targetDate': instance.targetDate,
    };
