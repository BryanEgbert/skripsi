import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:http/http.dart' as http;

abstract interface class IPetService {
  Future<Result<Pet>> getById(String token, String id);
  Future<Result<ListData<Pet>>> getPets(
      String token, PaginationQueryParams pagination);
  Future<Result<ListData<Pet>>> getBookedPets(
      String token, int petDaycareId, PaginationQueryParams pagination);

  Future<Result<void>> createPet(String token, PetRequest reqBody);
  Future<Result<void>> updatePet(String token, int id, PetRequest reqBody);
  Future<Result<void>> deletePet(String token, int id);
}

class PetService implements IPetService {
  @override
  Future<Result<void>> createPet(String token, PetRequest reqBody) {
    return makeRequest(201, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      // Map<String, String> headers = {
      //   HttpHeaders.contentTypeHeader: "multipart/form-data",
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      // };

      // var req = http.MultipartRequest("POST", Uri.parse("$host/pets"))
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

      // final res = await req.send();
      // var response = await http.Response.fromStream(res);

      FormData formData = FormData.fromMap({
        ...reqBody.toMap(),
        "image": MultipartFile.fromFile(reqBody.image.path,
            filename: reqBody.image.path.split('/').last),
      });

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
    });
  }

  @override
  Future<Result<void>> deletePet(String token, int id) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().delete(
        "$host/pets/$id",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          Headers.contentTypeHeader: Headers.jsonContentType,
        }),
      );

      return res;
    });
  }

  @override
  Future<Result<Pet>> getById(String token, String id) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().get(
        "$host/pets/$id",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => Pet.fromJson(res));
  }

  @override
  Future<Result<ListData<Pet>>> getPets(
      String token, PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().get(
        "$host/pets",
        queryParameters: pagination.toMap(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Pet.fromJson));
  }

  @override
  Future<Result<void>> updatePet(String token, int id, PetRequest reqBody) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      // Map<String, String> headers = {
      //   HttpHeaders.contentTypeHeader: "multipart/form-data",
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      // };

      // var req = http.MultipartRequest("PUT", Uri.parse("$host/pets/$id"))
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

      // final res = await req.send();
      // var response = await http.Response.fromStream(res);

      FormData formData = FormData.fromMap({
        ...reqBody.toMap(),
        "image": MultipartFile.fromFile(reqBody.image.path,
            filename: reqBody.image.path.split('/').last),
      });

      final response = await Dio().put(
        "$host/pets/$id",
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

  @override
  Future<Result<ListData<Pet>>> getBookedPets(
      String token, int petDaycareId, PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().get(
        "$host/daycare/$petDaycareId/pets",
        queryParameters: pagination.toMap(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => ListData.fromJson(res, Pet.fromJson));
  }
}
