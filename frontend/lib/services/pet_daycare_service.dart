import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/model/coordinate.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/model/request/reduce_slot_request.dart';
import 'package:frontend/model/request/update_pet_daycare_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/reviews.dart';
import 'package:frontend/model/user.dart';

abstract interface class IPetDaycareService {
  Future<Result<PetDaycareDetails>> getMy(String token);
  Future<Result<PetDaycareDetails>> getById(
      String token, int petDaycareId, Coordinate coord);
  Future<Result<ListData<PetDaycare>>> getPetDaycares(
      String token,
      Coordinate coord,
      PetDaycareFilters filters,
      OffsetPaginationQueryParams pagination);
  // Future<Result<void>> createPetDaycare(String token, )
  Future<Result<void>> updatePetDaycare(
      String token, int petDaycareId, UpdatePetDaycareRequest req);
  Future<Result<void>> deletePetDaycare(String token, int petDaycareId);
  Future<Result<ListData<Reviews>>> getReviews(
      String token, int petDaycareId, OffsetPaginationQueryParams pagination);
  Future<Result<ListData<BookingRequest>>> getBookingRequests(
      String token, OffsetPaginationQueryParams pagination);
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest req);
  Future<Result<ListData<User>>> getBookedPetOwners(
      String token, OffsetPaginationQueryParams pagination);
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
      OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      var res = await Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      )).get("$host/daycare", queryParameters: {
        ...pagination.toMap(),
        ...filters.toMap(),
        ...coord.toMap(),
      });

      return res;
    }, (res) => ListData.fromJson(res, PetDaycare.fromJson));
  }

  @override
  Future<Result<PetDaycareDetails>> getMy(String token) {
    return makeRequest(200, () async {
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

  @override
  Future<Result<ListData<Reviews>>> getReviews(
      String token, int petDaycareId, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/$petDaycareId/review",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Reviews.fromJson));
  }

  @override
  Future<Result<void>> updatePetDaycare(
      String token, int petDaycareId, UpdatePetDaycareRequest req) {
    return makeRequest(204, () async {
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> mapReq = req.toMap();

      if (req.thumbnails.isNotEmpty) {
        mapReq["thumbnails[]"] = await Future.wait(
          req.thumbnails
              .map((file) async => await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last))
              .toList(),
        );
      }
      FormData formData = FormData.fromMap(mapReq);

      final res = await dio.put(
        "$host/daycare/$petDaycareId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          Headers.contentTypeHeader: Headers.multipartFormDataContentType,
        }),
        data: formData,
      );

      return res;
    });
  }

  @override
  Future<Result<ListData<BookingRequest>>> getBookingRequests(
      String token, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/booking-requests",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => ListData.fromJson(res, BookingRequest.fromJson));
  }

  @override
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest req) {
    return makeRequest(201, () async {
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.post("$host/daycare/slot/$slotId",
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: req.toJson());

      return res;
    });
  }

  @override
  Future<Result<ListData<User>>> getBookedPetOwners(
      String token, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/booked-pet-owners",
        queryParameters: pagination.toMap(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => ListData.fromJson(res, User.fromJson));
  }
}
