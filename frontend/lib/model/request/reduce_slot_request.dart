import 'package:json_annotation/json_annotation.dart';

part 'reduce_slot_request.g.dart';

@JsonSerializable()
class ReduceSlotRequest {
  final int reducedCount;
  final String targetDate;

  ReduceSlotRequest({required this.reducedCount, required this.targetDate});

  factory ReduceSlotRequest.fromJson(Map<String, dynamic> json) =>
      _$ReduceSlotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReduceSlotRequestToJson(this);
}
