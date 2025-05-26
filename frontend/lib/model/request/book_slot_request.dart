import 'package:json_annotation/json_annotation.dart';

part 'book_slot_request.g.dart';

@JsonSerializable()
class BookSlotRequest {
  final List<int> petId;
  final bool usePickupService;
  final String startDate;
  final String endDate;
  final int? addressId;

  BookSlotRequest({
    required this.petId,
    required this.usePickupService,
    required this.startDate,
    required this.endDate,
    this.addressId,
  });

  factory BookSlotRequest.fromJson(Map<String, dynamic> json) =>
      _$BookSlotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookSlotRequestToJson(this);
}
