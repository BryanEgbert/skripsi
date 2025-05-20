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
  Future<Result<RetrieveResponse>> reverseLookup(
      double latitude, double longitude);
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

  @override
  Future<Result<RetrieveResponse>> reverseLookup(
      double latitude, double longitude) {
    return makeRequest(200, () async {
      final mockData = {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "coordinates": [13.3295589, 52.5125463],
              "type": "Point"
            },
            "properties": {
              "name": "Straße Des 17. Juni 115",
              "mapbox_id":
                  "dXJuOm1ieGFkcjo2YjU1MDMxMy1iNzM0LTQxNjYtYjk0MC0zZTU1MTE4MmQwOGY",
              "feature_type": "address",
              "address": "Straße Des 17. Juni 115",
              "full_address": "Straße Des 17. Juni 115, 10623 Berlin, Germany",
              "place_formatted": "10623 Berlin, Germany",
              "context": {
                "country": {
                  "id": "dXJuOm1ieHBsYzpJam8",
                  "name": "Germany",
                  "country_code": "DE",
                  "country_code_alpha_3": "DEU"
                },
                "postcode": {"id": "dXJuOm1ieHBsYzpVYTQ2", "name": "10623"},
                "place": {"id": "dXJuOm1ieHBsYzpBY1E2", "name": "Berlin"},
                "locality": {
                  "id": "dXJuOm1ieHBsYzpBd1pxT2c",
                  "name": "Charlottenburg"
                },
                "address": {
                  "id":
                      "dXJuOm1ieGFkcjo2YjU1MDMxMy1iNzM0LTQxNjYtYjk0MC0zZTU1MTE4MmQwOGY",
                  "name": "Straße Des 17. Juni 115",
                  "address_number": "Straße",
                  "street_name": "Des 17. Juni 115"
                },
                "street": {"name": "Des 17. Juni 115"}
              },
              "coordinates": {
                "latitude": 52.5125463,
                "longitude": 13.3295589,
                "accuracy": "rooftop",
                "routable_points": [
                  {
                    "name": "default",
                    "latitude": 52.51264818693428,
                    "longitude": 13.32955240836938
                  }
                ]
              },
              "language": "en",
              "maki": "marker",
              "external_ids": {},
              "metadata": {}
            }
          }
        ],
        "attribution":
            "© 2023 Mapbox and its suppliers. All rights reserved. Use of this data is subject to the Mapbox Terms of Service. (https://www.mapbox.com/about/maps/)"
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

      return res;
    }, (res) => RetrieveResponse.fromJson(res));
  }

  @override
  Future<Result<RetrieveResponse>> reverseLookup(
      double latitude, double longitude) {
    return makeRequest(200, () async {
      final String mapboxToken = dotenv.env["MAPBOX_TOKEN"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "https://api.mapbox.com/search/searchbox/v1/reverse",
        queryParameters: {
          "access_token": mapboxToken,
          "latitude": latitude,
          "longitude": longitude,
          "country": "id",
        },
      );

      return res;
    }, (res) => RetrieveResponse.fromJson(res));
  }
}
