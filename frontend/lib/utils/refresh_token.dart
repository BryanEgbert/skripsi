import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/database_service.dart';
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/services/user_service.dart';

Future<TokenResponse> refreshAccessToken() async {
  final dbService = DatabaseService();
  final authService = AuthService();
  final userService = UserService();

  TokenResponse token = await dbService.getToken();

  if (token.expiryDate <= DateTime.now().millisecondsSinceEpoch / 1000) {
    final refreshRes = await authService.refreshToken(token.refreshToken);
    switch (refreshRes) {
      case Ok<TokenResponse>():
        await dbService.insert(token);
        token = refreshRes.value!;
        return token;
      case Error<TokenResponse>():
        return Future.error(LocalizationService().jwtExpired);
    }
  } else {
    var user = await userService.getUser(token.accessToken, token.userId);
    switch (user) {
      case Ok():
        break;
      case NotFoundError():
        return Future.error(LocalizationService().userDeleted);
      case Error():
        return Future.error(LocalizationService().somethingWrong);
    }
  }

  return token;
}
