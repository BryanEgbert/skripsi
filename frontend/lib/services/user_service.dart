import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/user.dart';
import 'package:http/http.dart' as http;

abstract interface class IUserService {
  Future<User> getUser(String token, int id);
  Future<Result<ListData<User>>> getVets(
      String token, PaginationQueryParams pagination,
      [int specialtyId = 0]);
  Future<void> deleteUser(String token);
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody);
}

class UserService implements IUserService {
  @override
  Future<Result<void>> deleteUser(String token) async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;
      final res = await Dio().delete(
        "$host/users",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

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

      final res = await Dio().get(
        "$host/users/vets",
        queryParameters: queryParams,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
      );

      return res;
    }, (res) => ListData.fromJson(res, User.fromJson));
  }

  @override
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      // Map<String, String> headers = {
      //   HttpHeaders.contentTypeHeader: "multipart/form-data",
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      // };

      // var req = http.MultipartRequest("PUT", Uri.parse("$host/users"))
      //   ..headers.addAll(headers)
      //   ..fields.addAll(reqBody.toMap());

      // req.files.add(
      //   http.MultipartFile(
      //     "image",
      //     reqBody.image.readAsBytes().asStream(),
      //     reqBody.image.lengthSync(),
      //     filename: reqBody.image.path,
      //   ),
      // );

      // var res = await req.send();
      // var response = await http.Response.fromStream(res);

      FormData formData = FormData.fromMap({
        ...reqBody.toMap(),
        "image": MultipartFile.fromFile(reqBody.image.path,
            filename: reqBody.image.path.split('/').last),
      });

      final response = await Dio().put(
        "$host/users",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
        data: formData,
      );

      return response;
    });
  }
}
