import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {
  final String accessToken, refreshToken;
  final int userId, roleId;

  @JsonKey(name: "exp")
  final int expiryDate;

  TokenResponse({
    required this.userId,
    required this.roleId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiryDate,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  String toString() {
    return "TokenResponse(userId: $userId, roleId: $roleId, accessToken: $accessToken, refreshToken: $refreshToken)";
  }
}
