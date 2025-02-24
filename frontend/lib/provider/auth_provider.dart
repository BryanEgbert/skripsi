import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<TokenResponse?> build() {
    return Future.value(null);
  }

  Future<void> login(String email, String password) async {
    var repo = AuthRepository();
    var tokenRes = await repo.login(email, password);

    switch (tokenRes) {
      case Ok():
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        return Future.error(tokenRes.error);
    }

    Future<void> register(CreateUserRequest user) async {
      var repo = AuthRepository();
      var tokenRes = await repo.register(user);

      switch (tokenRes) {
        case Ok():
          state = AsyncData(tokenRes.value);
          break;
        case Error():
          return Future.error(tokenRes.error);
      }
    }

    Future<void> refreshToken(String token) async {
      var repo = AuthRepository();
      var tokenRes = await repo.refreshToken(token);

      switch (tokenRes) {
        case Ok():
          state = AsyncData(tokenRes.value);
          break;
        case Error():
          return Future.error(tokenRes.error);
      }
    }
  }
}
