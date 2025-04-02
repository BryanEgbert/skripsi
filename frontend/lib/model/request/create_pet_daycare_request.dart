import 'dart:io';

class CreatePetDaycareRequest {
  String petDaycareName;
  String address;
  String locality;
  double latitude;
  double longitude;
  String? description;
  List<double> price;
  List<String> pricingType;
  bool hasPickupService;
  bool mustBeVaccinated;
  bool groomingAvailable;
  bool foodProvided;
  String? foodBrand;
  int dailyWalksId;
  int dailyPlaytimeId;
  List<File> thumbnails;
  List<int> petCategoryId;
  List<int> maxNumber;

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
      'longitude': longitude,
      "latitude": latitude,
      'price[]': price.map((e) => e.toString()).toList(),
      'pricingType[]': pricingType,
      'hasPickupService': hasPickupService.toString(),
      'mustBeVaccinated': mustBeVaccinated.toString(),
      'groomingAvailable': groomingAvailable.toString(),
      'foodProvided': foodProvided.toString(),
      'foodBrand': foodBrand,
      'dailyWalksId': dailyWalksId.toString(),
      'dailyPlaytimeId': dailyPlaytimeId.toString(),
      'petCategoryId[]': petCategoryId.map((e) => e.toString()).toList(),
      'maxNumber[]': maxNumber.map((e) => e.toString()).toList(),
    };

    return map;
  }

  @override
  String toString() {
    return """CreatePetDaycareRequest(
    petDaycareName: $petDaycareName, 
    address: $address, 
    locality: $locality, 
    latitude: $latitude, 
    longitude: $longitude, 
    description: $description, 
    price: $price, 
    pricingType: $pricingType, 
    hasPickupService: $hasPickupService, 
    mustBeVaccinated: $mustBeVaccinated, 
    groomingAvailable: $groomingAvailable, 
    foodProvided: $foodProvided, 
    foodBrand: $foodBrand, 
    dailyWalksId: $dailyWalksId, 
    dailyPlaytimeId: $dailyPlaytimeId, 
    thumbnails: $thumbnails, 
    petCategoryId: $petCategoryId, 
    maxNumber: $maxNumber
  )""";
  }
}
