import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/response/mapbox/types.dart';

part 'retrieve_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RetrieveResponse {
  final String type;
  final List<RetrieveDetails> features;
  final String attribution;

  RetrieveResponse(this.type, this.attribution, this.features);

  factory RetrieveResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RetrieveDetails {
  final String type;
  final Geometry geometry;
  final RetrieveProperty properties;

  RetrieveDetails(this.type, this.geometry, this.properties);

  factory RetrieveDetails.fromJson(Map<String, dynamic> json) =>
      _$RetrieveDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RetrieveProperty {
  final String name;
  final String? namePreferred;
  final String mapboxId;
  final String featureType;
  final String? address;
  final String? fullAddress;
  final String? placeFormatted;
  final AdministrativeUnitType context;
  final Coordinates coordinates;
  final String? language;

  RetrieveProperty(
      this.name,
      this.namePreferred,
      this.mapboxId,
      this.featureType,
      this.address,
      this.fullAddress,
      this.placeFormatted,
      this.context,
      this.coordinates,
      this.language);

  factory RetrieveProperty.fromJson(Map<String, dynamic> json) =>
      _$RetrievePropertyFromJson(json);

  Map<String, dynamic> toJson() => _$RetrievePropertyToJson(this);
}
