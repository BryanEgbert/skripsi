import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/reduced_slot.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/request/reduce_slot_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/slot.dart';

abstract interface class ISlotService {
  Future<Result<ListData<Slot>>> getSlots(
      String token, List<int> petCategoryId, int petDaycareId);
  Future<Result<void>> bookSlot(
      String token, int petDaycareId, BookSlotRequest reqBody);
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest reqBody);
  Future<Result<ListData<ReducedSlot>>> getReducedSlots(
      String token, OffsetPaginationQueryParams pagination);
  Future<Result<void>> deleteReduceSlot(String token, int slotId);
  Future<Result<void>> acceptSlot(String token, int slotId);
  Future<Result<void>> rejectSlot(String token, int slotId);
  Future<Result<void>> cancelSlot(String token, int slotId);
}

class SlotService implements ISlotService {
  @override
  Future<Result<void>> bookSlot(
      String token, int petDaycareId, BookSlotRequest reqBody) {
    return makeRequest(201, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.post(
        "$host/daycare/$petDaycareId/slot",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: Headers.jsonContentType,
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
        data: jsonEncode(reqBody.toJson()),
      );

      return res;
    });
  }

  @override
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest reqBody) {
    return makeRequest(204, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "$host/daycare/slot/$slotId",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "applicaton/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
        data: reqBody.toJson(),
      );

      return res;
    });
  }

  @override
  Future<Result<ListData<Slot>>> getSlots(
    String token,
    List<int> petCategoryId,
    int petDaycareId,
  ) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/$petDaycareId/slot",
        queryParameters: {
          "pet-category": petCategoryId.join(","),
          // ...pagination.toMap(),
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Slot.fromJson));
  }

  @override
  Future<Result<void>> acceptSlot(String token, int slotId) {
    return makeRequest(204, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "$host/slots/$slotId/accept",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    });
  }

  @override
  Future<Result<void>> cancelSlot(String token, int slotId) {
    return makeRequest(204, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "$host/slots/$slotId/cancel",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    });
  }

  @override
  Future<Result<void>> rejectSlot(String token, int slotId) {
    return makeRequest(204, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "$host/slots/$slotId/reject",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    });
  }

  @override
  Future<Result<ListData<ReducedSlot>>> getReducedSlots(
      String token, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/daycare/reduced-slot",
        queryParameters: pagination.toMap(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, ReducedSlot.fromJson));
  }

  @override
  Future<Result<void>> deleteReduceSlot(String token, int slotId) {
    return makeRequest(204, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "$host/daycare/slot/$slotId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    });
  }
}
