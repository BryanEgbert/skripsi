import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_address.freezed.dart';

part 'saved_address.g.dart';

@freezed
class SavedAddress with _$SavedAddress {
  const factory SavedAddress({
    required int id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String? notes,
  }) = _SavedAddress;

  factory SavedAddress.fromJson(Map<String, dynamic> json) =>
      _$SavedAddressFromJson(json);
}
