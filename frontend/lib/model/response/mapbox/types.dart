import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AdministrativeUnitType {
  final Country? country;
  final Object? region;
  final LookupStr? postcode;
  final LookupStr? district;
  final LookupStr? place;
  final LookupStr? locality;
  final LookupStr? neighborhood;
  final Address? address;
  final LookupStr? street;

  AdministrativeUnitType(
    this.country,
    this.region,
    this.postcode,
    this.district,
    this.place,
    this.locality,
    this.neighborhood,
    this.address,
    this.street,
  );

  factory AdministrativeUnitType.fromJson(Map<String, dynamic> json) =>
      _$AdministrativeUnitTypeFromJson(json);

  Map<String, dynamic> toJson() => _$AdministrativeUnitTypeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LookupStr {
  final String? id;
  final String name;

  LookupStr(this.id, this.name);

  factory LookupStr.fromJson(Map<String, dynamic> json) =>
      _$LookupStrFromJson(json);

  Map<String, dynamic> toJson() => _$LookupStrToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates(this.longitude, this.latitude);

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Geometry {
  final List<double> coordinates;
  final String type;

  Geometry(this.coordinates, this.type);

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Country {
  final String? id;
  final String name;
  final String countryCode;
  @JsonKey(name: "country_code_alpha_3")
  final String countryCodeAlpha3;

  Country(this.id, this.name, this.countryCode, this.countryCodeAlpha3);

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Address {
  final String? id;
  final String name;
  final String addressNumber;
  final String streetName;

  Address(this.id, this.name, this.addressNumber, this.streetName);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
