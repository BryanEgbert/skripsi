import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/user.dart';
import 'package:http/http.dart' as http;

abstract interface class IUserRepository {
  Future<User> getUser(String token, int id);
  Future<Result<ListData<User>>> getVets(
      String token, PaginationQueryParams pagination,
      [int specialtyId = 0]);
  Future<void> deleteUser(String token);
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody);
}

class UserRepository implements IUserRepository {
  @override
  Future<Result<void>> deleteUser(String token) async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;
      final res = await http.delete(Uri.parse("$host/users"),
          headers: {"Authorization": "Bearer $token"});

      return res;
    });
  }

  @override
  Future<User> getUser(String token, int id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<ListData<User>>> getVets(
      String token, PaginationQueryParams pagination,
      [int specialtyId = 0]) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      Map<String, String> queryParams = {
        "specialty-id": specialtyId.toString(),
        ...pagination.toMap(),
      };

      final res = await http.get(
        Uri.parse("$host/users/vets").replace(queryParameters: queryParams),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );

      return res;
    }, (res) => ListData.fromJson(res, User.fromJson));
  }

  @override
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        HttpHeaders.authorizationHeader: "Bearer $token",
      };

      var req = http.MultipartRequest("PUT", Uri.parse("$host/users"))
        ..headers.addAll(headers)
        ..fields.addAll(reqBody.toMap());

      req.files.add(
        http.MultipartFile(
          "image",
          reqBody.image.readAsBytes().asStream(),
          reqBody.image.lengthSync(),
          filename: reqBody.image.path,
        ),
      );

      var res = await req.send();
      var response = await http.Response.fromStream(res);

      return response;
    });
  }
}
