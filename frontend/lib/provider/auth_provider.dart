import 'package:frontend/model/token_response.dart';
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
    try {
      var tokenRes = await repo.login(email, password);

      state = AsyncData(tokenRes);
    } catch (e) {
      rethrow;
    }
  }
}
