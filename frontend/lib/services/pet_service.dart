import 'dart:io';

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

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        HttpHeaders.authorizationHeader: "Bearer $token",
      };

      var req = http.MultipartRequest("POST", Uri.parse("$host/pets"))
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

      final res = await req.send();
      var response = await http.Response.fromStream(res);

      return response;
    });
  }

  @override
  Future<Result<void>> deletePet(String token, int id) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await http.delete(Uri.parse("$host/pets/$id"), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
      });

      return res;
    });
  }

  @override
  Future<Result<Pet>> getById(String token, String id) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await http.get(Uri.parse("$host/pets/$id"), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return res;
    }, (res) => Pet.fromJson(res));
  }

  @override
  Future<Result<ListData<Pet>>> getPets(
      String token, PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await http.get(
          Uri.parse("$host/pets").replace(
            queryParameters: pagination.toMap(),
          ),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          });

      return res;
    }, (res) => ListData.fromJson(res, Pet.fromJson));
  }

  @override
  Future<Result<void>> updatePet(String token, int id, PetRequest reqBody) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        HttpHeaders.authorizationHeader: "Bearer $token",
      };

      var req = http.MultipartRequest("PUT", Uri.parse("$host/pets/$id"))
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

      final res = await req.send();
      var response = await http.Response.fromStream(res);

      return response;
    });
  }

  @override
  Future<Result<ListData<Pet>>> getBookedPets(
      String token, int petDaycareId, PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await http.get(
          Uri.parse("$host/daycare/$petDaycareId/pets").replace(
            queryParameters: pagination.toMap(),
          ),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          });

      return res;
    }, (res) => ListData.fromJson(res, Pet.fromJson));
  }
}
