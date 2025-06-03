class UpdatePetDaycareRequest {
  String petDaycareName;
  String address;
  String locality;
  String location;
  double latitude;
  double longitude;
  String? description;
  String openingHour;
  String closingHour;
  List<double> price;
  int pricingType;
  bool hasPickupService;
  bool mustBeVaccinated;
  bool groomingAvailable;
  bool foodProvided;
  String? foodBrand;
  int dailyWalksId;
  int dailyPlaytimeId;
  List<String> thumbnails;
  List<int> petCategoryId;
  List<int> maxNumber;

  UpdatePetDaycareRequest({
    required this.petDaycareName,
    required this.address,
    required this.location,
    required this.locality,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.openingHour,
    required this.closingHour,
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
      'location': location,
      'locality': locality,
      'description': description,
      "openingHour": openingHour,
      "closingHour": closingHour,
      'longitude': longitude,
      "latitude": latitude,
      'price[]': price.map((e) => e.toString()).toList(),
      'pricingType': pricingType,
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
    return """UpdatePetDaycareRequest(
    petDaycareName: $petDaycareName, 
    address: $address, 
    locality: $locality, 
    location: $location,
    latitude: $latitude, 
    longitude: $longitude, 
    description: $description, 
    openingHour: $openingHour,
    closingHour: $closingHour,
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
    maxNumber: $maxNumber,
  )""";
  }
}
