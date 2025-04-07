import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/coordinate.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/model/response/list_response.dart';

abstract interface class IPetDaycareService {
  Future<Result<PetDaycareDetails>> getMy(String token);
  Future<Result<PetDaycareDetails>> getById(
      String token, int petDaycareId, Coordinate coord);
  Future<Result<ListData<PetDaycare>>> getPetDaycares(
      String token,
      Coordinate coord,
      PetDaycareFilters filters,
      PaginationQueryParams pagination);
  // Future<Result<void>> createPetDaycare(String token, )
  Future<Result<void>> deletePetDaycare(String token, int petDaycareId);
}

class PetDaycareService implements IPetDaycareService {
  @override
  Future<Result<void>> deletePetDaycare(String token, int petDaycareId) {
    // TODO: implement deletePetDaycare
    throw UnimplementedError();
  }

  @override
  Future<Result<PetDaycareDetails>> getById(
      String token, int petDaycareId, Coordinate coord) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/$petDaycareId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => PetDaycareDetails.fromJson(res));
  }

  @override
  Future<Result<ListData<PetDaycare>>> getPetDaycares(
      String token,
      Coordinate coord,
      PetDaycareFilters filters,
      PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      // TODO: add query params for filters and coords
      var res = await Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      )).get("$host/daycare", queryParameters: {
        ...pagination.toMap(),
        // ...filters.toMap(),
        ...coord.toMap(),
      });

      return res;
    }, (res) => ListData.fromJson(res, PetDaycare.fromJson));
  }

  @override
  Future<Result<PetDaycareDetails>> getMy(String token) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/my",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => PetDaycareDetails.fromJson(res));
  }
}
