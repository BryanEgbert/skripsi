import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:web_socket_channel/io.dart';

class ChatWebsocketChannel {
  IOWebSocketChannel? _instance;

  // ChatWebsocketChannel._internal();
  Future<IOWebSocketChannel> get instance async {
    final String host = dotenv.env["WS_HOST"]!;

    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      return Future.error(jwtExpired);
    }

    _instance = IOWebSocketChannel.connect(Uri.parse("$host/chat"), headers: {
      "Authorization": "Bearer ${token.accessToken}",
    });
    return _instance!;
  }
}
