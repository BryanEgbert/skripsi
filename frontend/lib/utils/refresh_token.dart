import 'dart:developer';

import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/database_service.dart';
import 'package:frontend/services/user_service.dart';

Future<TokenResponse> refreshToken() async {
  final dbService = DatabaseService();
  final authService = AuthService();
  final userService = UserService();

  log("refresh token");
  TokenResponse token = await dbService.getToken();

  if (token.expiryDate <= DateTime.now().millisecondsSinceEpoch / 1000) {
    final refreshRes = await authService.refreshToken(token.refreshToken);
    switch (refreshRes) {
      case Ok<TokenResponse>():
        token = refreshRes.value!;
        return token;
      case Error<TokenResponse>():
        log("session expired");
        return Future.error(jwtExpired);
    }
  } else {
    var user = await userService.getUser(token.accessToken, token.userId);
    switch (user) {
      case Ok():
        break;
      case Error():
        return Future.error(userDeleted);
    }
  }

  return token;
}
