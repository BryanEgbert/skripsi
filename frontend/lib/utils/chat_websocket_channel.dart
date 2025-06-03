import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:web_socket_channel/io.dart';

class ChatWebsocketChannel {
  static final ChatWebsocketChannel _singleton =
      ChatWebsocketChannel._internal();
  factory ChatWebsocketChannel() => _singleton;

  static IOWebSocketChannel? _instance;

  ChatWebsocketChannel._internal();

  Stream<dynamic> get stream {
    if (_instance == null) {
      throw Exception("WebSocket not connected");
    }

    return _instance!.stream.asBroadcastStream();
  }

  void close() {
    if (_instance == null) {
      throw Exception("WebSocket not connected");
    }

    _instance!.sink.close();

    _instance = null;
  }

  Future<IOWebSocketChannel> get instance async {
    final String host = FirebaseRemoteConfig.instance.getString("backend_host");

    TokenResponse? token;
    try {
      token = await refreshAccessToken();
    } catch (e) {
      return Future.error(jwtExpired);
    }

    _instance ??=
        IOWebSocketChannel.connect(Uri.parse("ws://$host/chat"), headers: {
      "Authorization": "Bearer ${token.accessToken}",
    });
    return _instance!;
  }
}
