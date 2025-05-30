import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/reduce_slot_request.dart';
import 'package:frontend/model/request/update_pet_daycare_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/pet_daycare_service.dart';
import 'package:frontend/services/slot_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_daycare_provider.g.dart';

@riverpod
class PetDaycareState extends _$PetDaycareState {
  @override
  Future<int> build() {
    return Future.value(0);
  }

  Future<void> reset() async {
    state = AsyncData(0);
  }

  Future<void> updatePetDaycare(
      int petDaycareId, UpdatePetDaycareRequest req) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = PetDaycareService();
    final res =
        await service.updatePetDaycare(token.accessToken, petDaycareId, req);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(getMyPetDaycareProvider);
        ref.invalidate(getPetDaycareByIdProvider(petDaycareId, null, null));
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> deleteReduceSlot(int slotId) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = SlotService();
    final res = await service.deleteReduceSlot(
      token.accessToken,
      slotId,
    );

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> editSlotCount(String token, int petDaycareId, int reducedCount,
      String targetDate) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = PetDaycareService();
    final res = await service.editSlotCount(
      token.accessToken,
      petDaycareId,
      ReduceSlotRequest(reducedCount: reducedCount, targetDate: targetDate),
    );

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
