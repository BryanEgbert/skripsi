import 'package:json_annotation/json_annotation.dart';

part 'create_saved_address_request.g.dart';

@JsonSerializable()
class CreateSavedAddressRequest {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  CreateSavedAddressRequest({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory CreateSavedAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSavedAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSavedAddressRequestToJson(this);
}
