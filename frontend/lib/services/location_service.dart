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

class MockLocationService implements ILocationService {
  @override
  Future<Result<SuggestResponse>> getSuggestedLocation(
      String sessionId, String query) {
    return makeRequest(200, () async {
      final mockData = {
        "suggestions": [
          {
            "name": "Mock Place 1",
            "mapbox_id": "mock-id-1",
            "feature_type": "poi",
            "address": "123 Mock St",
            "full_address": "123 Mock St, Mock City, ID",
            "place_formatted": "Mock City, ID",
            "context": {
              "country": {
                "name": "Indonesia",
                "code": "ID",
                "country_code": "ID",
                "country_code_alpha_3": "id"
              },
              "region": null,
              "postcode": {"name": "10110"},
              "district": {"name": "Central Jakarta"},
              "place": {"name": "Jakarta"},
              "locality": null,
              "neighborhood": {"name": "Mock Neighborhood"},
              "address": {
                "name": "123 Mock St",
                "address_number": "mock addr num",
                "street_name": "mock street name"
              },
              "street": {"name": "Mock Street"}
            }
          },
          {
            "name": "Mock Place 2",
            "mapbox_id": "mock-id-2",
            "feature_type": "address",
            "address": "456 Fake Ave",
            "full_address": "456 Fake Ave, Mock Town, ID",
            "place_formatted": "Mock Town, ID",
            "context": {
              "country": {
                "name": "Indonesia",
                "code": "ID",
                "country_code": "ID",
                "country_code_alpha_3": "id"
              },
              "region": null,
              "postcode": {"name": "20220"},
              "district": {"name": "West Jakarta"},
              "place": {"name": "Jakarta"},
              "locality": null,
              "neighborhood": {"name": "Fake Neighborhood"},
              "address": {
                "name": "456 Fake Ave",
                "address_number": "mock addr num",
                "street_name": "mock street name"
              },
              "street": {"name": "Fake Avenue"}
            }
          }
        ],
        "attribution": "Mock Data Attribution"
      };

      final res = Response(
          data: mockData, requestOptions: RequestOptions(), statusCode: 200);

      return res;
    }, (res) => SuggestResponse.fromJson(res));
  }

  @override
  Future<Result<RetrieveResponse>> retrieveSuggestedLocation(
      String sessionId, String mapboxId) {
    return makeRequest(200, () async {
      final mockData = {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "coordinates": [106.8456, -6.2088],
              "type": "Point"
            },
            "properties": {
              "name": "Mock Location 1",
              "name_preferred": "Preferred Mock Location 1",
              "mapbox_id": "mock-id-1",
              "feature_type": "poi",
              "address": "123 Mock St",
              "full_address": "123 Mock St, Mock City, ID",
              "place_formatted": "Mock City, ID",
              "context": {
                "country": {
                  "id": "dXJuOm1ieHBsYzpJdXc",
                  "name": "Indonesia",
                  "country_code": "ID",
                  "country_code_alpha_3": "id"
                },
                "region": null,
                "postcode": {"id": "dXJuOm1ieHBsYzpJdXc", "name": "10110"},
                "district": {
                  "id": "dXJuOm1ieHBsYzpJdXc",
                  "name": "Central Jakarta"
                },
                "place": {"id": "dXJuOm1ieHBsYzpJdXc", "name": "Jakarta"},
                "locality": {"id": "dXJuOm1ieHBsYzpJdXc", "name": "Grogol"},
                "neighborhood": {
                  "id": "dXJuOm1ieHBsYzpJdXc",
                  "name": "Mock Neighborhood"
                },
                "address": {
                  "id": "dXJuOm1ieHBsYzpJdXc",
                  "name": "123 Mock St",
                  "address_number": "mock addr num",
                  "street_name": "mock street name"
                },
                "street": {"id": "dXJuOm1ieHBsYzpJdXc", "name": "Mock Street"}
              },
              "coordinates": {"longitude": 106.8456, "latitude": -6.2088},
              "language": "id"
            }
          }
        ],
        "attribution": "Mock Data Attribution"
      };

      final res = Response(
          data: mockData, requestOptions: RequestOptions(), statusCode: 200);

      return res;
    }, (res) => RetrieveResponse.fromJson(res));
  }
}

class LocationService implements ILocationService {
  @override
  Future<Result<SuggestResponse>> getSuggestedLocation(
      String sessionId, String query) async {
    return makeRequest(200, () async {
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
