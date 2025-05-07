// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reduced_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReducedSlotImpl _$$ReducedSlotImplFromJson(Map<String, dynamic> json) =>
    _$ReducedSlotImpl(
      id: (json['id'] as num).toInt(),
      slotId: (json['slotId'] as num).toInt(),
      daycareId: (json['daycareId'] as num).toInt(),
      reducedCount: (json['reducedCount'] as num).toInt(),
      targetDate: json['targetDate'] as String,
    );

Map<String, dynamic> _$$ReducedSlotImplToJson(_$ReducedSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slotId': instance.slotId,
      'daycareId': instance.daycareId,
      'reducedCount': instance.reducedCount,
      'targetDate': instance.targetDate,
    };
