import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/vaccine_record.dart';

abstract interface class IVaccinationRecordService {
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
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

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
        "$host/$petId/vaccination-record",
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
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "$host/vaccination-record/$vaccineRecordId",
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
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

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

      final res = await dio.put(
        "$host/vaccination-record/$vaccineRecordId",
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
        await dotenv.load();
        final String host = dotenv.env["HOST"]!;

        final dio = Dio(BaseOptions(
          validateStatus: (status) {
            return status != null; // Accept all HTTP status codes
          },
        ));

        final res = await dio.get(
          "$host/vaccination-record/$vaccineRecordId",
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          }),
        );

        return res;
      },
      (res) => VaccineRecord.fromJson(res),
    );
  }
}
