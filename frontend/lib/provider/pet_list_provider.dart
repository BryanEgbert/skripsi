import 'dart:developer';

import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/database_service.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_list_provider.g.dart';

@riverpod
class PetList extends _$PetList {
  Future<ListData<Pet>> _getPets() async {
    final dbService = DatabaseService();
    final authService = AuthService();
    var token = await dbService.get();
    log("token: $token");

    if (token.expiryDate <= DateTime.now().millisecondsSinceEpoch / 1000) {
      final refreshRes = await authService.refreshToken(token.refreshToken);
      switch (refreshRes) {
        case Ok<TokenResponse>():
          token = refreshRes.value!;
          break;
        case Error<TokenResponse>():
          return Future.error(jwtExpired);
      }
    }

    final petService = PetService();

    final res =
        await petService.getPets(token.accessToken, PaginationQueryParams());

    switch (res) {
      case Ok():
        return res.value!;
      case Error():
        return Future.error(res.error);
    }
  }

  @override
  Future<ListData<Pet>> build() async {
    return _getPets();
  }

  Future<void> delete(int petId) async {
    state = AsyncLoading();

    final dbService = DatabaseService();
    final authService = AuthService();
    final petService = PetService();

    var token = await dbService.get();

    if (token.expiryDate <= DateTime.now().millisecondsSinceEpoch / 1000) {
      final refreshRes = await authService.refreshToken(token.refreshToken);
      switch (refreshRes) {
        case Ok<TokenResponse>():
          token = refreshRes.value!;
          break;
        case Error<TokenResponse>():
          state = AsyncError(refreshRes.error, StackTrace.current);
      }
    }

    final res = await petService.deletePet(token.accessToken, petId);
    switch (res) {
      case Ok():
        ref.invalidateSelf();
        await future;
      // return res.value!;
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
