import 'dart:io';

class UpdateUserRequest {
  final String name;
  final String email;
  final int roleId;
  final List<int> vetSpecialtyId;
  final File image;

  UpdateUserRequest(
    this.image, {
    required this.name,
    required this.email,
    required this.roleId,
    required this.vetSpecialtyId,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {
      "name": name,
      "email": email,
      "roleId": roleId.toString(),
      "vetSpecialtyId": vetSpecialtyId.join(','),
    };

    return map;
  }
}
