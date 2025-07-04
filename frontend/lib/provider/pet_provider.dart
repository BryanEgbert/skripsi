import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_provider.g.dart';

@riverpod
class PetState extends _$PetState {
  @override
  Future<int?> build() async {
    return null;
  }

  void reset() {
    state = const AsyncData(null); // Reset to clean state
  }

  Future<void> deletePet(int petId) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

    final petService = PetService();
    final res = await petService.deletePet(token.accessToken, petId);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> editPet(int petId, PetRequest req) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

    final petService = PetService();
    final res = await petService.updatePet(token.accessToken, petId, req);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(petProvider(petId));
        ref.invalidate(petListProvider);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> addPet(
      PetRequest petReq, VaccinationRecordRequest? vaccineReq) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

    final petService = PetService();
    final res =
        await petService.createPet(token.accessToken, petReq, vaccineReq);

    switch (res) {
      case Ok<void>():
        state = AsyncData(201);
        ref.invalidate(petListProvider);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
