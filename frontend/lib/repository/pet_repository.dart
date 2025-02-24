import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:http/http.dart' as http;

abstract interface class IPetRepository {
  Future<Pet> getById(String token, String id);
  Future<List<Pet>> getPets(String token, int lastId, int size);
  Future<void> createPet(String token, PetRequest reqBody);
  Future<void> updatePet(String token, PetRequest reqBody);
  Future<void> deletePet(String token, int id);
}

class PetRepository implements IPetRepository {
  @override
  Future<void> createPet(String token, PetRequest reqBody) {
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
  Future<void> deletePet(String token, int id) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await http.delete(Uri.parse("$host/pets/$id"), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return res;
    });
  }

  @override
  Future<Pet> getById(String token, String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Pet>> getPets(String token, int lastId, int size) {
    // TODO: implement getPets
    throw UnimplementedError();
  }

  @override
  Future<void> updatePet(String token, PetRequest reqBody) {
    // TODO: implement updatePet
    throw UnimplementedError();
  }
}
