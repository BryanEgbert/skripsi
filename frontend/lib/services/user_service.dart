import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/create_saved_address_request.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/model/user.dart';

abstract interface class IUserService {
  Future<Result<User>> getUser(String token, int id);
  Future<Result<ListData<User>>> getVets(
      String token, CursorBasedPaginationQueryParams pagination,
      [int specialtyId = 0]);
  Future<void> deleteUser(String token);
  Future<Result<void>> updateUser(String token, UpdateUserRequest reqBody);
  Future<Result<ListData<SavedAddress>>> getSavedAddress(
      String token, OffsetPaginationQueryParams pagination);
  Future<Result<void>> addSavedAddress(
      String token, CreateSavedAddressRequest req);
  Future<Result<void>> editSavedAddress(
      String token, CreateSavedAddressRequest req);
  Future<Result<void>> deleteSavedAddress(String token, int addressId);
  Future<Result<ListData<User>>> getUserChatList(String token);
  Future<Result<ListData<ChatMessage>>> getChatMessages(
      String token, int receiverId);
  Future<Result<void>> updateChatReads(String token, int receiverId);
}

class UserService implements IUserService {
  @override
  Future<Result<void>> deleteUser(String token) async {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "$host/users",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return res;
    });
  }

  @override
  Future<Result<User>> getUser(String token, int id) async {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/users/$id",
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
      final String host = dotenv.env["HOST"]!;

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
        "$host/users/vets",
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
      final String host = dotenv.env["HOST"]!;

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
        "$host/users",
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
  Future<Result<void>> addSavedAddress(
      String token, CreateSavedAddressRequest req) {
    return makeRequest(201, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.post(
        "$host/saved-address",
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
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.delete(
        "$host/saved-address/$addressId",
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
      String token, CreateSavedAddressRequest req) {
    return makeRequest(201, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.put(
        "$host/saved-address",
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
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/users/saved-address",
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
  Future<Result<ListData<User>>> getUserChatList(String token) {
    return makeRequest(200, () async {
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/chat/user",
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
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "$host/chat-messages",
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
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.patch(
        "$host/chat/read",
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
}
