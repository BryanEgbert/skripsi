import 'dart:io';

class CreatePetDaycareRequest {
  final String petDaycareName;
  final String address;
  final String locality;
  final double latitude;
  final double longitude;
  final String? description;
  final List<double> price;
  final List<String> pricingType;
  final bool hasPickupService;
  final bool mustBeVaccinated;
  final bool groomingAvailable;
  final bool foodProvided;
  final String? foodBrand;
  final int dailyWalksId;
  final int dailyPlaytimeId;
  final List<File> thumbnails;
  final List<int> petCategoryId;
  final List<int> maxNumber;

  CreatePetDaycareRequest({
    required this.petDaycareName,
    required this.address,
    required this.locality,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.price,
    required this.pricingType,
    required this.hasPickupService,
    required this.mustBeVaccinated,
    required this.groomingAvailable,
    required this.foodProvided,
    this.foodBrand,
    required this.dailyWalksId,
    required this.dailyPlaytimeId,
    required this.thumbnails,
    required this.petCategoryId,
    required this.maxNumber,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'petDaycareName': petDaycareName,
      'address': address,
      'locality': locality,
      'description': description,
      'price[]': price.map((e) => e.toString()).toList(),
      'pricingType[]': pricingType,
      'hasPickupService': hasPickupService.toString(),
      'mustBeVaccinated': mustBeVaccinated.toString(),
      'groomingAvailable': groomingAvailable.toString(),
      'foodProvided': foodProvided.toString(),
      'foodBrand': foodBrand,
      'dailyWalksId': dailyWalksId.toString(),
      'dailyPlaytimeId': dailyPlaytimeId.toString(),
      // 'thumbnails[]': thumbnails.map((path) => MultipartFile.fromFileSync(path)).toList(),
      'petCategoryId[]': petCategoryId.map((e) => e.toString()).toList(),
      'maxNumber[]': maxNumber.map((e) => e.toString()).toList(),
    };

    return map;
  }
}
