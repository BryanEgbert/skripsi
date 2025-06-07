import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/vaccine_record.dart';

abstract interface class IVaccinationRecordService {
  Future<Result<ListData<VaccineRecord>>> getAll(
      String token, int petId, OffsetPaginationQueryParams pagination);
  Future<Result<void>> update(
      String token, int vaccineRecordId, VaccinationRecordRequest req);
  Future<Result<void>> create(
      String token, int petId, VaccinationRecordRequest req);
  Future<Result<void>> delete(String token, int vaccineRecordId);
  Future<Result<VaccineRecord>> getById(String token, int vaccineRecordId);
}

class VaccinationRecordService implements IVaccinationRecordService {
  @override
  Future<Result<void>> create(
      String token, int petId, VaccinationRecordRequest req) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      FormData formData = FormData.fromMap({
        ...req.toMap(),
        "vaccineRecordImage": req.vaccineRecordImage != null
            ? await MultipartFile.fromFile(req.vaccineRecordImage!.path,
                filename: req.vaccineRecordImage!.path.split('/').last)
            : null,
      });

      final response = await dio.post(
        "http://$host/$petId/vaccination-record",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
        data: formData,
      );

      return response;
    });
  }

  @override
  Future<Result<void>> delete(String token, int vaccineRecordId) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "http://$host/vaccination-record/$vaccineRecordId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    });
  }

  @override
  Future<Result<void>> update(
      String token, int vaccineRecordId, VaccinationRecordRequest req) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> reqMap = req.toMap();

      if (req.vaccineRecordImage != null) {
        reqMap["vaccineRecordImage"] = await MultipartFile.fromFile(
            req.vaccineRecordImage!.path,
            filename: req.vaccineRecordImage!.path.split('/').last);
      }

      FormData formData = FormData.fromMap(reqMap);
      final res = await dio.put(
        "http://$host/vaccination-record/$vaccineRecordId",
        options: Options(headers: {
          Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
        data: formData,
      );

      return res;
    });
  }

  @override
  Future<Result<VaccineRecord>> getById(String token, int vaccineRecordId) {
    return makeRequest(
      200,
      () async {
        final String host =
            FirebaseRemoteConfig.instance.getString("backend_host");

        final dio = Dio(BaseOptions(
          validateStatus: (status) {
            return status != null; // Accept all HTTP status codes
          },
        ));

        final res = await dio.get(
          "http://$host/vaccination-record/$vaccineRecordId",
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          }),
        );

        return res;
      },
      (res) => VaccineRecord.fromJson(res),
    );
  }

  @override
  Future<Result<ListData<VaccineRecord>>> getAll(
      String token, int petId, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/pets/$petId/vaccination-record",
        queryParameters: pagination.toMap(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => ListData.fromJson(res, VaccineRecord.fromJson));
  }
}
