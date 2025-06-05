class PetDaycareFilters {
  double minDistance;
  double maxDistance;
  List<String> facilities;
  bool? mustBeVaccinated;
  int dailyWalks;
  int dailyPlaytime;
  double minPrice;
  double maxPrice;
  int? pricingType;
  List<int> petCategoryIds;

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
    this.petCategoryIds = const [],
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "min-distance": minDistance.toString(),
      "max-distance": maxDistance.toString(),
      // "facilities": facilities.join(","),
      "min-price": minPrice.toString(),
      "max-price": maxPrice.toString(),
      "daily-walks": dailyWalks.toString(),
      "daily-playtime": dailyPlaytime.toString(),
    };

    if (facilities.isNotEmpty) {
      map["facilities"] = facilities.join(",");
    }

    if (petCategoryIds.isNotEmpty) {
      map["pet-categories"] = petCategoryIds.join(",");
    }

    if (pricingType != null) {
      map["pricing-type"] = pricingType;
    }

    if (mustBeVaccinated != null) {
      map["vaccination-required"] = mustBeVaccinated.toString();
    }

    return map;
  }

  @override
  String toString() {
    return "PetDaycareFilters(minDistance: $minDistance, maxDistance: $maxDistance, facilities: $facilities, minPrice: $minPrice, maxPrice: $maxPrice, dailyWalks: $dailyWalks, dailyPlaytime: $dailyPlaytime, mustBeVaccinated: $mustBeVaccinated)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PetDaycareFilters &&
        other.minDistance == minDistance &&
        other.maxDistance == maxDistance &&
        _listEquals(other.facilities, facilities) &&
        other.mustBeVaccinated == mustBeVaccinated &&
        other.dailyWalks == dailyWalks &&
        other.dailyPlaytime == dailyPlaytime &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        other.pricingType == pricingType;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      minDistance,
      maxDistance,
      dailyWalks,
      dailyPlaytime,
      minPrice,
      maxPrice,
      mustBeVaccinated,
      pricingType,
      facilities.join(','), // deterministic hash from list contents
    ]);
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
