import 'package:freezed_annotation/freezed_annotation.dart';

part 'booked_slot_address.freezed.dart';

part 'booked_slot_address.g.dart';

@freezed
class BookedSlotAddress with _$BookedSlotAddress {
  factory BookedSlotAddress({
    required int id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String? notes,
  }) = _BookedSlotAddress;

  factory BookedSlotAddress.fromJson(Map<String, dynamic> json) =>
      _$BookedSlotAddressFromJson(json);
}
