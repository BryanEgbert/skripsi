import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/user.dart';

part 'booking_request.freezed.dart';

part 'booking_request.g.dart';

@freezed
class PetCategoryCount with _$PetCategoryCount {
  factory PetCategoryCount({
    required PetCategory petCategory,
    required int total,
  }) = _PetCategoryCount;

  factory PetCategoryCount.fromJson(Map<String, dynamic> json) =>
      _$PetCategoryCountFromJson(json);
}

@freezed
class BookingRequest with _$BookingRequest {
  factory BookingRequest({
    required int id,
    required User user,
    required String startDate,
    required String endDate,
    required bool pickupRequired,
    required List<PetCategoryCount> petCount,
  }) = _BookingRequest;

  factory BookingRequest.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestFromJson(json);
}
