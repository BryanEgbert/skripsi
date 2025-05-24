import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:web_socket_channel/io.dart';

class VetMainPage extends ConsumerStatefulWidget {
  const VetMainPage({super.key});

  @override
  ConsumerState<VetMainPage> createState() => VetMainPageState();
}

class VetMainPageState extends ConsumerState<VetMainPage> {
  IOWebSocketChannel? _channel;
  StreamSubscription? _webSocketSubscription;

  Object? _error;

  Set<User> users = {};
  List<ChatMessage> _messages = [];

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
          _webSocketSubscription = _channel!.stream.listen(
            (message) {
              log("[VET MAIN PAGE] new message: $message");
              setState(() {
                _fetchData();
              });
            },
            onError: (e) {
              setState(() {
                _error = e;
              });
            },
          );
          log("connected to websocket");
        },
      );
    } catch (e) {
      if (e.toString() == jwtExpired && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeWidget()),
          (route) => false,
        );
      }
    }
  }

  void _fetchData() {
    ref.read(getUserChatListProvider.future).then((newData) {
      log("[VET MAIN PAGE] fetchData: ${newData.data}");
      setState(() {
        users = newData.data.toSet();
      });
    }).catchError((e) {
      setState(() {
        _error = e;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(getUserChatListProvider);

    if (_error != null) {
      handleError(
          AsyncValue.error(_error.toString(), StackTrace.current), context);
    }

    return Scaffold(
        appBar: AppBar(
          actions: appBarActions(),
        ),
        body: switch (chatList) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () async {
                _fetchData();
              },
            ),
          AsyncData(:final value) => (value.data.isNotEmpty)
              ? RefreshIndicator(
                  onRefresh: () async {
                    _fetchData();
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var item = users.elementAt(index);
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(userId: item.id),
                          ));
                        },
                        tileColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Constants.secondaryBackgroundColor
                                : null,
                        leading: DefaultCircleAvatar(imageUrl: item.imageUrl),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryTextColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chat,
                          color: Colors.orange,
                        ),
                      );
                    },
                  ),
                )
              : ErrorText(
                  errorText: "pet owners who chat you will appear here",
                  onRefresh: () => ref.refresh(getUserChatListProvider.future),
                ),
          _ => Center(
              child: CircularProgressIndicator.adaptive(),
            )
        });
  }
}
