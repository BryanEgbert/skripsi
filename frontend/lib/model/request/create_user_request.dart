import 'dart:io';

class CreateUserRequest {
  final String name;
  final String email;
  final String password;
  final int roleId;
  final List<int> vetSpecialtyId;
  final String? deviceToken;
  final File? userImage;

  CreateUserRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.roleId,
    required this.vetSpecialtyId,
    required this.deviceToken,
    this.userImage,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "displayName": name,
      "email": email,
      "password": password,
      "roleId": roleId.toString(),
      "vetSpecialtyId[]": vetSpecialtyId,
    };

    if (deviceToken != null) {
      map["deviceToken"] = deviceToken;
    }

    return map;
  }

  @override
  String toString() {
    return "CreateUserRequest(name: $name, email: $email, password: $password, roleId: $roleId, vetSpecialtyId: $vetSpecialtyId)";
  }
}
