import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_saved_address_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/services/saved_address_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_address_provider.g.dart';

@riverpod
class SavedAddressState extends _$SavedAddressState {
  @override
  Future<int> build() async {
    return Future.value(0);
  }

  Future<void> reset() async {
    state = AsyncData(0);
  }

  Future<void> addSavedAddress(CreateSavedAddressRequest req) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

    final service = SavedAddressService();
    final res = await service.addSavedAddress(token.accessToken, req);
    switch (res) {
      case Ok<void>():
        state = AsyncData(201);
        ref.invalidate(savedAddressProvider);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> editSavedAddress(
      int addressId, CreateSavedAddressRequest req) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

    final service = SavedAddressService();
    final res =
        await service.editSavedAddress(token.accessToken, addressId, req);
    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(savedAddressProvider);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> deleteSavedAddress(int addressId) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      state = AsyncError(LocalizationService().jwtExpired, StackTrace.current);
      return;
    }

    final service = SavedAddressService();
    final res = await service.deleteSavedAddress(token.accessToken, addressId);
    switch (res) {
      case Ok<void>():
        state = AsyncData(204);
        ref.invalidate(savedAddressProvider);
      case Error<void>():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
