import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/create_user_request.dart';
import 'package:frontend/model/error_response.dart';
import 'package:frontend/model/token_response.dart';
import 'package:http/http.dart' as http;

abstract interface class IAuthRepository {
  Future<TokenResponse> login(String email, String password);
  Future<TokenResponse> register(CreateUserRequest req);
  Future<TokenResponse> refreshToken(String token);
}

class AuthRepository implements IAuthRepository {
  @override
  Future<TokenResponse> login(String email, String password) async {
    try {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await http.post(
        Uri.parse("$host/login"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      if (res.statusCode == 200) {
        return TokenResponse.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
      } else {
        ErrorResponse errorRes = ErrorResponse.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);

        throw Exception(errorRes.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TokenResponse> refreshToken(String token) async {
    await dotenv.load();
    final String host = dotenv.env["HOST"]!;

    var res = await http.post(
      Uri.parse("$host/refresh"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        {"refreshToken": token},
      ),
    );

    if (res.statusCode == 200) {
      return TokenResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>);
    } else {
      ErrorResponse errorRes =
          ErrorResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);

      throw Exception(errorRes.message);
    }
  }

  @override
  Future<TokenResponse> register(CreateUserRequest reqBody) async {
    await dotenv.load();
    final String host = dotenv.env["HOST"]!;

    Map<String, String> headers = {"Content-Type": "multipart/form-data"};

    var req = http.MultipartRequest("POST", Uri.parse("$host/users"))
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

    if (res.statusCode == 201) {
      return TokenResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      ErrorResponse errorRes = ErrorResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorRes.message);
    }
  }
}
