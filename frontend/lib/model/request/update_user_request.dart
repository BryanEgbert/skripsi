import 'dart:io';

class UpdateUserRequest {
  final String name;
  final String email;
  final int roleId;
  final List<int> vetSpecialtyId;
  final File? image;

  UpdateUserRequest({
    required this.name,
    required this.email,
    required this.roleId,
    required this.vetSpecialtyId,
    this.image,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "roleId": roleId.toString(),
      "vetSpecialtyId[]": vetSpecialtyId,
    };

    return map;
  }

  @override
  String toString() {
    return "UpdateUserRequest(name: $name, email: $email), roleId: $roleId, vetSpecialtyId: $vetSpecialtyId";
  }
}
