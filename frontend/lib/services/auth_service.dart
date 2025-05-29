import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/response/token_response.dart';

abstract interface class IAuthService {
  Future<Result<TokenResponse>> login(String email, String password);
  Future<Result<TokenResponse>> register(CreateUserRequest req);
  Future<Result<TokenResponse>> refreshToken(String token);
  Future<Result<TokenResponse>> createPetOwner(CreateUserRequest userReq,
      PetRequest petReq, VaccinationRecordRequest vaccineReq);
  Future<Result<TokenResponse>> createPetDaycareProvider(
      CreateUserRequest userReq, CreatePetDaycareRequest petDaycareReq);
}

class AuthService implements IAuthService {
  @override
  Future<Result<TokenResponse>> login(String email, String password) async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");
      log("host: $host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.post(
        "http://$host/login",
        options: Options(contentType: Headers.jsonContentType),
        data: {
          "email": email,
          "password": password,
        },
      );

      return res;
    }, (res) => TokenResponse.fromJson(res));
  }

  @override
  Future<Result<TokenResponse>> refreshToken(String refreshToken) async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.post(
        "http://$host/refresh",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
        data: {"refreshToken": refreshToken},
      );

      return res;
    }, (res) => TokenResponse.fromJson(res));
  }

  @override
  Future<Result<TokenResponse>> register(CreateUserRequest reqBody) async {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> reqMap = reqBody.toMap();

      if (reqBody.userImage != null) {
        reqMap["userProfilePicture"] = await MultipartFile.fromFile(
            reqBody.userImage!.path,
            filename: reqBody.userImage!.path.split('/').last);
      }

      final response = await dio.post(
        "http://$host/users",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          },
        ),
        data: FormData.fromMap(reqMap),
      );

      return response;
    }, (res) => TokenResponse.fromJson(res));
  }

  @override
  Future<Result<TokenResponse>> createPetOwner(CreateUserRequest userReq,
      PetRequest petReq, VaccinationRecordRequest vaccineReq) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> req = {
        ...userReq.toMap(),
        ...petReq.toMap(),
        ...vaccineReq.toMap(),
      };

      if (userReq.userImage != null) {
        req["userProfilePicture"] = await MultipartFile.fromFile(
            userReq.userImage!.path,
            filename: userReq.userImage!.path.split('/').last);
      }

      if (petReq.petImage != null) {
        req["petProfilePicture"] = await MultipartFile.fromFile(
            petReq.petImage!.path,
            filename: petReq.petImage!.path.split('/').last);
      }

      if (vaccineReq.vaccineRecordImage != null) {
        req["vaccineRecordImage"] = await MultipartFile.fromFile(
            vaccineReq.vaccineRecordImage!.path,
            filename: vaccineReq.vaccineRecordImage!.path.split('/').last);
      }

      FormData formData = FormData.fromMap(req);

      final response = await dio.post(
        "http://$host/pet-owner",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          },
        ),
        data: formData,
      );

      return response;
    }, (res) => TokenResponse.fromJson(res));
  }

  @override
  Future<Result<TokenResponse>> createPetDaycareProvider(
      CreateUserRequest userReq, CreatePetDaycareRequest petDaycareReq) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> req = {
        ...userReq.toMap(),
        ...petDaycareReq.toMap(),
        "thumbnails[]": await Future.wait(
          petDaycareReq.thumbnails
              .map((file) async => await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last))
              .toList(),
        )
      };

      FormData formData = FormData.fromMap(req);

      final response = await dio.post(
        "http://$host/pet-daycare-provider",
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          },
        ),
        data: formData,
      );

      return response;
    }, (res) => TokenResponse.fromJson(res));
  }
}
