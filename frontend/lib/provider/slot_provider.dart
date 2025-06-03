import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/slot_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'slot_provider.g.dart';

@riverpod
class SlotState extends _$SlotState {
  @override
  Future<int> build() {
    return Future.value(0);
  }

  Future<void> acceptSlot(int slotId) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = SlotService();
    final res = await service.acceptSlot(token.accessToken, slotId);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(getBookingRequestsProvider());
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> reset() async {
    state = AsyncData(0);
  }

  Future<void> rejectSlot(int slotId) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = SlotService();
    final res = await service.rejectSlot(token.accessToken, slotId);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(getBookingRequestsProvider(token.userId));

      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> cancelSlot(int slotId) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = SlotService();
    final res = await service.cancelSlot(token.accessToken, slotId);

    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(getBookingRequestsProvider(token.userId));

      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> bookSlot(int petDaycareId, BookSlotRequest req) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = SlotService();
    final res = await service.bookSlot(token.accessToken, petDaycareId, req);

    switch (res) {
      case Ok<void>():
        state = AsyncData(201);
        ref.invalidate(getBookingRequestsProvider(token.userId));
        ref.invalidate(getPetDaycareByIdProvider(petDaycareId, null, null));

      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
