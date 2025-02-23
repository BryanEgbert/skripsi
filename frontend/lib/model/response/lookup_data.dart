import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/lookup.dart';

part 'lookup_data.freezed.dart';

part 'lookup_data.g.dart';

@freezed
class LookupData with _$LookupData {
  const factory LookupData({
    required List<Lookup> data,
  }) = _LookupData;

  factory LookupData.fromJson(Map<String, dynamic> json) =>
      _$LookupDataFromJson(json);
}
