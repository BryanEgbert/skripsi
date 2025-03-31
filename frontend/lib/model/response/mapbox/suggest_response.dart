import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/response/mapbox/types.dart';

part 'suggest_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SuggestResponse {
  final List<SuggestionDetailsResponse> suggestions;
  final String attribution;

  SuggestResponse(this.suggestions, this.attribution);

  factory SuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SuggestionDetailsResponse {
  final String name;
  final String mapboxId;
  final String featureType;
  final String? address;
  final String? fullAddress;
  final String placeFormatted;
  final AdministrativeUnitType context;

  SuggestionDetailsResponse(this.name, this.mapboxId, this.featureType,
      this.address, this.fullAddress, this.placeFormatted, this.context);

  factory SuggestionDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestionDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionDetailsResponseToJson(this);
}
