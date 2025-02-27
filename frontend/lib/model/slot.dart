import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';

part 'slot.g.dart';

@freezed
class Slot with _$Slot {
  const factory Slot({
    required int slotAmount,
    required String date,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}
