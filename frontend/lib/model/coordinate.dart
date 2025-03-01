class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});

  Map<String, String> toMap() {
    Map<String, String> map = {
      "lat": latitude.toString(),
      "long": longitude.toString(),
    };

    return map;
  }
}
