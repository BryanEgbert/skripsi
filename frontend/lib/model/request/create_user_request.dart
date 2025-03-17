import 'dart:io';

class CreateUserRequest {
  final String name;
  final String email;
  final String password;
  final int roleId;
  final List<int> vetSpecialtyId;
  final File? image;

  CreateUserRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.roleId,
    required this.vetSpecialtyId,
    this.image,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "password": password,
      "roleId": roleId.toString(),
      "vetSpecialtyId[]": vetSpecialtyId,
    };

    return map;
  }
}
