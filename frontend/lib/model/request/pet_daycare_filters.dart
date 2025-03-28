class PetDaycareFilters {
  final double minDistance;
  final double maxDistance;
  final List<String> facilities;
  final bool? mustBeVaccinated;
  final int dailyWalks;
  final int dailyPlaytime;
  final double minPrice;
  final double maxPrice;
  final String? pricingType;

  PetDaycareFilters({
    this.minDistance = 0.0,
    this.maxDistance = 0.0,
    this.facilities = const [],
    this.mustBeVaccinated,
    this.dailyWalks = 0,
    this.dailyPlaytime = 0,
    this.minPrice = 0.0,
    this.maxPrice = 0.0,
    this.pricingType,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {
      "min-distance": minDistance.toString(),
      "max-distance": maxDistance.toString(),
      "facilities": facilities.join(","),
      "min-price": minPrice.toString(),
      "max-price": maxPrice.toString(),
      "daily-walks": dailyWalks.toString(),
      "daily-playtime": dailyPlaytime.toString(),
    };

    if (facilities.isNotEmpty) {
      map["facilities"] = facilities.join(",");
    }

    if (pricingType != null) {
      map["pricing-type"] = pricingType!;
    }

    if (mustBeVaccinated != null) {
      map["vaccination-required"] = mustBeVaccinated.toString();
    }

    return map;
  }
}
