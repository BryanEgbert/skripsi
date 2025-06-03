import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/create_saved_address_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/saved_address.dart';

abstract interface class ISavedAddressService {
  Future<Result<ListData<SavedAddress>>> getSavedAddress(
      String token, OffsetPaginationQueryParams pagination);
  Future<Result<SavedAddress>> getSavedAddressById(String token, int addressId);
  Future<Result<void>> addSavedAddress(
      String token, CreateSavedAddressRequest req);
  Future<Result<void>> editSavedAddress(
      String token, int addressId, CreateSavedAddressRequest req);
  Future<Result<void>> deleteSavedAddress(String token, int addressId);
}

class SavedAddressService implements ISavedAddressService {
  @override
  Future<Result<void>> addSavedAddress(
      String token, CreateSavedAddressRequest req) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.post(
        "http://$host/saved-address",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: jsonEncode(req.toJson()),
      );

      return res;
    });
  }

  @override
  Future<Result<void>> deleteSavedAddress(String token, int addressId) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "http://$host/saved-address/$addressId",
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
  Future<Result<void>> editSavedAddress(
      String token, int addressId, CreateSavedAddressRequest req) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.put(
        "http://$host/saved-address/$addressId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: req.toJson(),
      );

      return res;
    });
  }

  @override
  Future<Result<ListData<SavedAddress>>> getSavedAddress(
      String token, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/saved-address",
        queryParameters: pagination.toMap(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, SavedAddress.fromJson));
  }

  @override
  Future<Result<SavedAddress>> getSavedAddressById(
      String token, int addressId) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/saved-address/$addressId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => SavedAddress.fromJson(res));
  }
}
