import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
    final String host = dotenv.env["WS_HOST"]!;

    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      return Future.error(jwtExpired);
    }

    _instance ??= IOWebSocketChannel.connect(Uri.parse("$host/chat"), headers: {
      "Authorization": "Bearer ${token.accessToken}",
    });
    return _instance!;
  }
}
