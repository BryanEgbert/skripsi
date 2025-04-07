import 'package:freezed_annotation/freezed_annotation.dart';

part 'lookup.freezed.dart';

part 'lookup.g.dart';

@freezed
class Lookup with _$Lookup {
  const factory Lookup({
    required int id,
    required String name,
  }) = _Lookup;

  factory Lookup.fromJson(Map<String, dynamic> json) => _$LookupFromJson(json);

  @override
  String toString() {
    return "Lookup(id: $id, name: $name)";
  }
}
