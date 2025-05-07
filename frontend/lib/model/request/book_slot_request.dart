import 'package:json_annotation/json_annotation.dart';

part 'book_slot_request.g.dart';

@JsonSerializable()
class BookSlotRequest {
  final int petId;
  final String startDate;
  final String endDate;
  final bool usePickupService;
  final String? location;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? notes;

  BookSlotRequest({
    required this.petId,
    required this.startDate,
    required this.endDate,
    required this.usePickupService,
    this.location,
    this.address,
    this.latitude,
    this.longitude,
    this.notes,
  });

  factory BookSlotRequest.fromJson(Map<String, dynamic> json) =>
      _$BookSlotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookSlotRequestToJson(this);
}
