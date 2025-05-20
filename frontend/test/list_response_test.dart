import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/pet_service.dart';

void main() {
  test("Test list data", () {
    List<Map<String, dynamic>> lookup = [
      Lookup(id: 1, name: "1").toJson(),
      Lookup(id: 2, name: "2").toJson(),
    ];

    Map<String, dynamic> lookupJson = {"data": lookup};
    final listData = ListData<Lookup>.fromJson(lookupJson, Lookup.fromJson);

    expect(listData.data.length, 2);
    for (var i = 0; i < 2; i++) {
      expect(listData.data[i].toJson(), lookup[i]);
    }
  });

  test("Get booked pets", () async {
    var petService = PetService();
    final authService = AuthService();

    final tokenRes = await authService.login("jane@example.com", "test");
    TokenResponse? token;

    switch (tokenRes) {
      case Ok():
        token = tokenRes.value;
        break;
      case Error():
        fail("auth error: ${tokenRes.error}");
    }

    final petRes = await petService.getBookedPets(
        token!.accessToken, CursorBasedPaginationQueryParams());

    switch (petRes) {
      case Ok():
        expect(petRes.value, isNotNull);
        expect(petRes.value!.data, isNotEmpty);
        break;
      case Error():
        fail("get booked pets error: ${petRes.error}");
    }
  });
}
