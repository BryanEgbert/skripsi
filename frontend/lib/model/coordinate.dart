class Coordinate {
  final double? latitude;
  final double? longitude;

  Coordinate({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (latitude != null) {
      map["lat"] = latitude;
    }

    if (longitude != null) {
      map["long"] = longitude;
    }

    return map;
  }
}
