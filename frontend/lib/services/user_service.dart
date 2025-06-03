import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/user.dart';

abstract interface class IUserService {
  Future<Result<User>> getUser(String token, int id);
  Future<Result<ListData<User>>> getVets(
      String token, CursorBasedPaginationQueryParams pagination,
      [int specialtyId = 0]);
  Future<void> deleteUser(String token);
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody);
  Future<Result<ListData<User>>> getUserChatList(String token);
  Future<Result<ListData<ChatMessage>>> getChatMessages(
      String token, int receiverId);
  Future<Result<void>> updateChatReads(String token, int receiverId);
  Future<Result<void>> updateDeviceToken(String token, String deviceToken);
}

class UserService implements IUserService {
  @override
  Future<Result<void>> deleteUser(String token) async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "http://$host/users",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return res;
    });
  }

  @override
  Future<Result<User>> getUser(String token, int id) async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/users/$id",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
      );

      return res;
    }, (res) => User.fromJson(res));
  }

  @override
  Future<Result<ListData<User>>> getVets(
      String token, CursorBasedPaginationQueryParams pagination,
      [int specialtyId = 0]) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, String> queryParams = {
        "specialty-id": specialtyId.toString(),
        ...pagination.toMap(),
      };

      final res = await dio.get(
        "http://$host/users/vets",
        queryParameters: queryParams,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
      );

      return res;
    }, (res) => ListData.fromJson(res, User.fromJson));
  }

  @override
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      Map<String, dynamic> reqMap = reqBody.toMap();

      if (reqBody.image != null) {
        reqMap["userProfilePicture"] = await MultipartFile.fromFile(
            reqBody.image!.path,
            filename: reqBody.image!.path.split('/').last);
      }

      FormData formData = FormData.fromMap(reqMap);

      final response = await dio.put(
        "http://$host/users",
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
  Future<Result<ListData<User>>> getUserChatList(String token) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/chat/user",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, User.fromJson));
  }

  @override
  Future<Result<ListData<ChatMessage>>> getChatMessages(
      String token, int receiverId) async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/chat-messages",
        queryParameters: {"receiver-id": receiverId},
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, ChatMessage.fromJson));
  }

  @override
  Future<Result<void>> updateChatReads(String token, int receiverId) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "http://$host/chat/read",
        queryParameters: {"receiver-id": receiverId},
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
  Future<Result<void>> updateDeviceToken(String token, String? deviceToken) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "http://$host/users/device-token",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: {
          "deviceToken": deviceToken,
        },
      );

      return res;
    });
  }
}
