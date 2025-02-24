import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/user.dart';
import 'package:http/http.dart' as http;

abstract interface class IUserRepository {
  Future<User> getUser(String token, int id);
  Future<List<User>> getVets(String token, int id, int lastId, int pageSize);
  Future<void> deleteUser(String token);
  Future<void> updateUser(String token, UpdateUserRequest reqBody);
}

class UserRepository implements IUserRepository {
  @override
  Future<void> deleteUser(String token) async {
    try {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;
      final res = await http.delete(Uri.parse("$host/users"),
          headers: {"Authorization": "Bearer $token"});

      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception("Something's went wrong");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUser(String token, int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getVets(String token, int id, int lastId, int pageSize) {
    // TODO: implement getVets
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(String token, UpdateUserRequest reqBody) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
