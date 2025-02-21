import 'dart:io';

class CreateUserRequest {
  final String name;
  final String email;
  final String password;
  final int roleId;
  final List<int> vetSpecialtyId;
  final File image;

  CreateUserRequest(
    this.vetSpecialtyId,
    this.image, {
    required this.name,
    required this.email,
    required this.password,
    required this.roleId,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {
      "name": name,
      "email": email,
      "password": password,
      "roleId": roleId.toString(),
      "vetSpecialtyId": vetSpecialtyId.join(','),
    };

    return map;
  }
}
