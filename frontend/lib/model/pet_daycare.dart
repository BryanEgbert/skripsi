import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/user.dart';

part 'pet_daycare.freezed.dart';
part 'pet_daycare.g.dart';

@freezed
class PetDaycare with _$PetDaycare {
  const factory PetDaycare({
    required int id,
    required String name,
    // required String address,
    required double distance,
    required String locality,
    // required String location,
    // required String openingHour,
    // required String closingHour,
    required double averageRating,
    required int ratingCount,
    required int bookedNum,
    required List<Price> prices,
    required String thumbnail,
  }) = _PetDaycare;

  factory PetDaycare.fromJson(Map<String, dynamic> json) =>
      _$PetDaycareFromJson(json);
}

@freezed
class PetDaycareDetails with _$PetDaycareDetails {
  const factory PetDaycareDetails({
    required int id,
    required String name,
    required String address,
    required String locality,
    required String location,
    required double latitude,
    required double longitude,
    required String openingHour,
    required String closingHour,
    required double distance,
    required List<Price> pricings,
    required String description,
    required int bookedNum,
    required double averageRating,
    required int ratingCount,
    required bool hasPickupService,
    required bool mustBeVaccinated,
    required bool groomingAvailable,
    required bool foodProvided,
    required String foodBrand,
    required String createdAt,
    required User owner,
    required Lookup dailyWalks,
    required Lookup dailyPlaytime,
    required List<String> thumbnailUrls,
  }) = _PetDaycareDetails;

  factory PetDaycareDetails.fromJson(Map<String, dynamic> json) =>
      _$PetDaycareDetailsFromJson(json);
}

@freezed
class Price with _$Price {
  factory Price({
    required PetCategory petCategory,
    required double price,
    required Lookup pricingType,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}
