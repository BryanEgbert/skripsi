// import 'package:frontend/model/error_handler/error_handler.dart';
// import 'package:frontend/model/pagination_query_params.dart';
// import 'package:frontend/model/pet.dart';
// import 'package:frontend/model/response/list_response.dart';
// import 'package:frontend/model/response/token_response.dart';
// import 'package:frontend/services/pet_service.dart';
// import 'package:frontend/utils/refresh_token.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'pet_state_provider.g.dart';

// @riverpod
// class PetState extends _$PetState {
//   Future<ListData<Pet>> _getPets() async {
//     TokenResponse token = await refreshToken();

//     final petService = PetService();

//     final res =
//         await petService.getPets(token.accessToken, PaginationQueryParams());

//     switch (res) {
//       case Ok():
//         return res.value!;
//       case Error():
//         return Future.error(res.error);
//     }
//   }

//   @override
//   Future<int> build() async {
//     return Future.value(0);
//   }

//   Future<void> delete(int petId) async {
//     state = AsyncLoading();

//     final petService = PetService();

//     TokenResponse token = await refreshToken();

//     final res = await petService.deletePet(token.accessToken, petId);
//     switch (res) {
//       case Ok():
//         state = AsyncData(204);
//       // return res.value!;
//       case Error():
//         state = AsyncError(res.error, StackTrace.current);
//     }
//   }
// }
