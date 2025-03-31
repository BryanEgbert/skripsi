import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';

abstract interface class ILocationService {
  Future<Result<SuggestResponse>> getSuggestedLocation(
      String sessionId, String query);
  Future<Result<RetrieveResponse>> retrieveSuggestedLocation(
      String sessionId, String mapboxId);
}

class LocationService implements ILocationService {
  @override
  Future<Result<SuggestResponse>> getSuggestedLocation(
      String sessionId, String query) async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String mapboxToken = dotenv.env["MAPBOX_TOKEN"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "https://api.mapbox.com/search/searchbox/v1/suggest",
        queryParameters: {
          "q": query,
          "access_token": mapboxToken,
          "session_token": sessionId,
          "country": "id",
        },
      );

      return res;
    }, (res) => SuggestResponse.fromJson(res));
  }

  @override
  Future<Result<RetrieveResponse>> retrieveSuggestedLocation(
      String sessionId, String mapboxId) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String mapboxToken = dotenv.env["MAPBOX_TOKEN"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "https://api.mapbox.com/search/searchbox/v1/retrieve/$mapboxId",
        queryParameters: {
          "access_token": mapboxToken,
          "session_token": sessionId,
          "country": "id",
        },
      );
      log("[INFO] retrieve: ${res.data.toString()}");
      return res;
    }, (res) => RetrieveResponse.fromJson(res));
  }
}
