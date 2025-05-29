import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/list_response.dart';

abstract interface class IChatService {
  Future<Result<ListData<ChatMessage>>> getUnreadChatMessages(String token);
}

class ChatService implements IChatService {
  @override
  Future<Result<ListData<ChatMessage>>> getUnreadChatMessages(String token) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/chat/unread",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, ChatMessage.fromJson));
  }
}
