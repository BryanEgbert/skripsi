import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserState extends _$UserState {
  @override
  Future<int> build() {
    return Future.value(0);
  }

  Future<void> editUser(UpdateUserRequest req) async {
    state = AsyncLoading();

    TokenResponse token = await refreshToken();

    final userService = UserService();
    final res = await userService.updateUser(token.accessToken, req);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(getUserByIdProvider(token.userId));
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
