import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/database_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<TokenResponse?> build() {
    return Future.value(null);
  }

  Future<void> reset() async {
    state = AsyncData(null);
  }

  Future<void> login(String email, String password) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    final authService = AuthService();

    final tokenRes = await authService.login(email, password);

    switch (tokenRes) {
      case Ok():
        dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
    }
  }

  Future<void> register(CreateUserRequest user) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    final authService = AuthService();

    final tokenRes = await authService.register(user);

    switch (tokenRes) {
      case Ok():
        dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
    }
  }

  Future<void> refreshToken(String token) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    var repo = AuthService();
    var tokenRes = await repo.refreshToken(token);

    switch (tokenRes) {
      case Ok():
        dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
    }
  }
}
