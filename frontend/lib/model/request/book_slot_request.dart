import 'package:json_annotation/json_annotation.dart';

part 'book_slot_request.g.dart';

@JsonSerializable()
class BookSlotRequest {
  final int petId;
  final String startDate;
  final String endDate;

  BookSlotRequest(
      {required this.petId, required this.startDate, required this.endDate});

  factory BookSlotRequest.fromJson(Map<String, dynamic> json) =>
      _$BookSlotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookSlotRequestToJson(this);
}
