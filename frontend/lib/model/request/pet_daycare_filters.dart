class PetDaycareFilters {
  final double minDistance;
  final double maxDistance;
  final String facilities;
  final bool mustBeVaccinated;
  final int dailyWalks;
  final int dailyPlaytime;
  final double minPrice;
  final double maxPrice;
  final String pricingType;

  PetDaycareFilters({
    this.minDistance = 0,
    this.maxDistance = 0,
    this.facilities = "",
    this.mustBeVaccinated = true,
    this.dailyWalks = 1,
    this.dailyPlaytime = 1,
    this.minPrice = 0,
    this.maxPrice = 0,
    this.pricingType = "day",
  });

  Map<String, String> toMap() {
    Map<String, String> map = {
      "min-distance": minDistance.toString(),
      "max-distance": maxDistance.toString(),
      "facilities": facilities,
      "min-price": minPrice.toString(),
      "max-price": maxPrice.toString(),
      "pricing-type": pricingType,
      "daily-walks": dailyWalks.toString(),
      "daily-playtime": dailyPlaytime.toString(),
      "vaccination-required": mustBeVaccinated.toString(),
    };

    return map;
  }
}
