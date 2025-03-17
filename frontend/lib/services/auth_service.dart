import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/response/token_response.dart';

abstract interface class IAuthService {
  Future<Result<TokenResponse>> login(String email, String password);
  Future<Result<TokenResponse>> register(CreateUserRequest req);
  Future<Result<TokenResponse>> refreshToken(String token);
}

class AuthService implements IAuthService {
  @override
  Future<Result<TokenResponse>> login(String email, String password) async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await Dio().post(
        "$host/login",
        options: Options(contentType: Headers.jsonContentType),
        data: {
          "email": email,
          "password": password,
        },
      );

      return res;
    }, (res) => TokenResponse.fromJson(res));
  }

  @override
  Future<Result<TokenResponse>> refreshToken(String token) async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await Dio().post(
        "$host/refresh",
        options: Options(contentType: Headers.jsonContentType),
        data: {"refreshToken": token},
      );

      return res;
    }, (res) => TokenResponse.fromJson(res));
  }

  @override
  Future<Result<TokenResponse>> register(CreateUserRequest reqBody) async {
    return makeRequest(201, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      // Map<String, String> headers = {"Content-Type": "multipart/form-data"};

      // var req = http.MultipartRequest("POST", Uri.parse("$host/users"))
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

      // return response;

      FormData formData = FormData.fromMap({
        ...reqBody.toMap(),
        "image": reqBody.image != null
            ? await MultipartFile.fromFile(reqBody.image!.path,
                filename: reqBody.image!.path.split('/').last)
            : null,
      });

      log("Image filename: ${reqBody.image!.path.split('/').last}");

      log("create user req: ${formData.files}");

      final response = await Dio().post(
        "$host/users",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          },
        ),
        data: formData,
      );

      return response;
    }, (res) => TokenResponse.fromJson(res));
  }
}
