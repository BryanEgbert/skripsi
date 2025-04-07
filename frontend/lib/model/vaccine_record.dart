import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_record.freezed.dart';
part 'vaccine_record.g.dart';

@freezed
class VaccineRecord with _$VaccineRecord {
  const factory VaccineRecord({
    required int id,
    required String dateAdministered,
    required String nextDueDate,
    required String imageUrl,
  }) = _VaccineRecord;

  factory VaccineRecord.fromJson(Map<String, dynamic> json) =>
      _$VaccineRecordFromJson(json);

  @override
  String toString() {
    return "VaccineRecord(id: $id)";
  }
}
