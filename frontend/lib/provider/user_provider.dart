import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/localization_service.dart';
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

  Future<void> reset() async {
    state = AsyncData(0);
  }

  Future<void> editUser(UpdateUserRequest req) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
      ref.invalidate(getMyUserProvider);
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

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

  Future<void> updateDeviceToken() async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }
    final deviceToken = await FirebaseMessaging.instance.getToken();

    final userService = UserService();
    final res =
        await userService.updateDeviceToken(token.accessToken, deviceToken);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);

      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
