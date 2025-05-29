import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/response/list_response.dart';

abstract interface class IPetService {
  Future<Result<Pet>> getById(String token, int id);
  Future<Result<ListData<Pet>>> getPets(
      String token, CursorBasedPaginationQueryParams pagination);
  Future<Result<ListData<Pet>>> getBookedPets(
      String token, CursorBasedPaginationQueryParams pagination);
  Future<Result<void>> createPet(String token, PetRequest petReqBody,
      VaccinationRecordRequest? vaccineReqBody);
  Future<Result<void>> updatePet(String token, int id, PetRequest reqBody);
  Future<Result<void>> deletePet(String token, int id);
}

class PetService implements IPetService {
  @override
  Future<Result<void>> createPet(String token, PetRequest petReqBody,
      VaccinationRecordRequest? vaccineReqBody) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> reqMap = petReqBody.toMap();

      if (petReqBody.petImage != null) {
        reqMap["petProfilePicture"] = await MultipartFile.fromFile(
            petReqBody.petImage!.path,
            filename: petReqBody.petImage!.path.split('/').last);
      }

      if (vaccineReqBody != null) {
        if (vaccineReqBody.vaccineRecordImage != null) {
          reqMap["vaccineRecordImage"] = await MultipartFile.fromFile(
              petReqBody.petImage!.path,
              filename: petReqBody.petImage!.path.split('/').last);
        }

        reqMap = {...reqMap, ...vaccineReqBody.toMap()};
      }

      FormData formData = FormData.fromMap(reqMap);

      final response = await dio.post(
        "http://$host/pets",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          },
        ),
        data: formData,
      );

      return response;
    });
  }

  @override
  Future<Result<void>> deletePet(String token, int id) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "http://$host/pets/$id",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    });
  }

  @override
  Future<Result<Pet>> getById(String token, int id) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/pets/$id",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => Pet.fromJson(res));
  }

  @override
  Future<Result<ListData<Pet>>> getPets(
      String token, CursorBasedPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/pets",
        queryParameters: pagination.toMap(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Pet.fromJson));
  }

  @override
  Future<Result<void>> updatePet(String token, int id, PetRequest reqBody) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> reqMap = reqBody.toMap();

      if (reqBody.petImage != null) {
        reqMap["petProfilePicture"] = await MultipartFile.fromFile(
            reqBody.petImage!.path,
            filename: reqBody.petImage!.path.split('/').last);
      }

      FormData formData = FormData.fromMap(reqMap);

      final response = await dio.put(
        "http://$host/pets/$id",
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
  Future<Result<ListData<Pet>>> getBookedPets(
      String token, CursorBasedPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/daycare/pets",
        queryParameters: pagination.toMap(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }),
      );

      return res;
    }, (res) => ListData.fromJson(res, Pet.fromJson));
  }

  // @override
  // Future<Result<ListData<VaccineRecord>>> getVaccineRecords(
  //     String token, int petId, OffsetPaginationQueryParams pagination) {
  //   return makeRequest(200, () async {
  //     final String host = FirebaseRemoteConfig.instance.getString("backend_host");

  //     final dio = Dio(BaseOptions(
  //       validateStatus: (status) {
  //         return status != null; // Accept all HTTP status codes
  //       },
  //     ));

  //     final res = await dio.get(
  //       "http://$host/pets/$petId/vaccination-record",
  //       queryParameters: pagination.toMap(),
  //       options: Options(headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $token",
  //       }),
  //     );

  //     return res;
  //   }, (res) => ListData.fromJson(res, VaccineRecord.fromJson));
  // }
}
