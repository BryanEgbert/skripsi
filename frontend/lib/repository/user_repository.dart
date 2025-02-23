import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/user.dart';

abstract interface class IUserRepository {
  Future<User> getUser(String token, int id);
  Future<List<User>> getVets(String token, int id, int lastId, int pageSize);
  Future<void> deleteUser(String token, int id);
  Future<void> updateUser(String token, UpdateUserRequest reqBody);
}

class UserRepository implements IUserRepository {
  @override
  Future<void> deleteUser(String token, int id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUser(String token, int id) {
    // TODO: implement getUser
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
