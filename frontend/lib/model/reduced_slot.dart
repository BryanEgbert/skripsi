import 'package:freezed_annotation/freezed_annotation.dart';

part 'reduced_slot.freezed.dart';
part 'reduced_slot.g.dart';

@freezed
class ReducedSlot with _$ReducedSlot {
  const factory ReducedSlot({
    required int id,
    required int slotId,
    required int daycareId,
    required int reducedCount,
    required String targetDate,
  }) = _ReducedSlot;

  factory ReducedSlot.fromJson(Map<String, dynamic> json) =>
      _$ReducedSlotFromJson(json);
}
