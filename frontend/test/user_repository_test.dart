import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/user_service.dart';

void main() {
  group("User repository test", () {
    test("Should return vet list data on 200", () async {
      final userRepository = UserService();
      final authRepository = AuthService();

      final auth = await authRepository.login("john@example.com", "test");
      TokenResponse? token;

      switch (auth) {
        case Ok():
          token = auth.value;
          break;
        case Error():
          fail("Fail to login");
      }

      final vetsRes = await userRepository.getVets(
          token!.accessToken, PaginationQueryParams());

      ListData<User>? vets;

      switch (vetsRes) {
        case Ok():
          vets = vetsRes.value;
          break;
        case Error():
          fail("Failed to fetch vets");
      }

      ListData<User> expected = ListData(data: [
        User(
            id: 4,
            name: "Dr. Vet",
            email: "vet@example.com",
            imageUrl: "test.com/image/test.jpeg",
            role: Lookup(id: 3, name: "vet"),
            vetSpecialties: [
              Lookup(id: 1, name: "General Practice"),
              Lookup(id: 2, name: "Preventive Medicine"),
              Lookup(id: 3, name: "Emergency & Critical Care"),
            ],
            createdAt: vets!.data[0].createdAt)
      ]);

      expect(vets.data, isNotEmpty);
      expect(vets.data[0], expected.data[0]);
    });

    test("Should return 204 on update user", () async {
      final userRepository = UserService();
      final authRepository = AuthService();

      final auth = await authRepository.login("john@example.com", "test");
      TokenResponse? token;

      switch (auth) {
        case Ok():
          token = auth.value;
          break;
        case Error():
          fail("Fail to login");
      }

      final res = await userRepository.updateUser(
        token!.accessToken,
        UpdateUserRequest(
          File("${Directory.current.path}/test/test.jpeg"),
          name: "updated_user",
          email: "update@email.com",
          roleId: 1,
          vetSpecialtyId: [],
        ),
      );

      switch (res) {
        case Ok():
          break;
        case Error():
          fail("Failed to update user ${res.error}");
      }
    });
  });
}
