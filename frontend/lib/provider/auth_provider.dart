import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
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

  Future<void> login(String email, String password) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    final authService = AuthService();

    final tokenRes = await authService.login(email, password);

    switch (tokenRes) {
      case Ok():
        await dbService.insert(tokenRes.value!);
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
        await dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
    }
  }

  Future<void> createPetOwner(CreateUserRequest user, PetRequest petReq,
      VaccinationRecordRequest vaccineReq) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    final authService = AuthService();

    final tokenRes = await authService.createPetOwner(user, petReq, vaccineReq);

    switch (tokenRes) {
      case Ok():
        await dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
    }
  }

  Future<void> createPetDaycareProvider(
      CreateUserRequest userReq, CreatePetDaycareRequest petDaycareReq) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    final authService = AuthService();

    final tokenRes =
        await authService.createPetDaycareProvider(userReq, petDaycareReq);

    switch (tokenRes) {
      case Ok():
        await dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
        break;
    }
  }

  Future<void> logOut() async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    await dbService.delete();

    state = AsyncData(null);
  }

  Future<void> refreshToken(String refreshToken) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    var repo = AuthService();
    var tokenRes = await repo.refreshToken(refreshToken);

    switch (tokenRes) {
      case Ok():
        await dbService.insert(tokenRes.value!);
        state = AsyncData(tokenRes.value);
        break;
      case Error():
        state = AsyncError(tokenRes.error, StackTrace.current);
        break;
    }
  }
}
