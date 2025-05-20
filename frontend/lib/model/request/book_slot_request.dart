import 'package:json_annotation/json_annotation.dart';

part 'book_slot_request.g.dart';

@JsonSerializable()
class BookSlotRequest {
  final List<int> petId;
  final bool usePickupService;
  final String startDate;
  final String endDate;
  final String? location;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? notes;

  BookSlotRequest({
    required this.petId,
    required this.usePickupService,
    required this.startDate,
    required this.endDate,
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
