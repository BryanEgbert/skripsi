import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_provider.g.dart';

@riverpod
class PetState extends _$PetState {
  @override
  Future<Pet?> build() {
    return Future.value(null);
  }

  Future<void> addPet(String token, PetRequest req) async {
    state = AsyncLoading();

    final petService = PetService();
    final res = await petService.createPet(token, req);

    switch (res) {
      case Ok<void>():
        // TODO: Handle this case.
        state = AsyncData(null);
      case Error<void>():
        // TODO: Handle this case.
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
