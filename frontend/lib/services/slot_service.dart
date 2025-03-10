import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/request/reduce_slot_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/slot.dart';
import 'package:http/http.dart' as http;

abstract interface class ISlotService {
  Future<Result<ListData<Slot>>> getSlots(String token, int speciesId,
      int petDaycareId, int year, int month, PaginationQueryParams pagination);
  Future<Result<void>> bookSlot(
      String token, int petDaycareId, BookSlotRequest reqBody);
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest reqBody);
}

class SlotService implements ISlotService {
  @override
  Future<Result<void>> bookSlot(
      String token, int petDaycareId, BookSlotRequest reqBody) {
    return makeRequest(201, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().post(
        "$host/daycare/$petDaycareId/slot",
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
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest reqBody) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().patch(
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
  Future<Result<ListData<Slot>>> getSlots(String token, int speciesId,
      int petDaycareId, int year, int month, PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final res = await Dio().get(
        "$host/daycare/$petDaycareId/slot",
        queryParameters: {
          "year": year,
          "month": month,
          "species": speciesId,
          ...pagination.toMap(),
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
}
