import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:web_socket_channel/io.dart';

class PetOwnerChatListPage extends ConsumerStatefulWidget {
  const PetOwnerChatListPage({super.key});

  @override
  ConsumerState<PetOwnerChatListPage> createState() =>
      PetOwnerChatListPageState();
}

class PetOwnerChatListPageState extends ConsumerState<PetOwnerChatListPage> {
  IOWebSocketChannel? _channel;
  Set<User> users = {};
  Object? _error;
  bool _isFetching = false;

  StreamSubscription? _webSocketSubscription;

  void _fetchData() {
    setState(() {
      _isFetching = true;
    });

    ref.read(getUserChatListProvider.future).then((newData) {
      users = newData.data.toSet();
    }).catchError((e) {
      _error = e;
    }).whenComplete(() => setState(() => _isFetching = false));
  }

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
          _webSocketSubscription = _channel!.stream.listen(
            (message) {
              // Only fetch when new messages arrive
              _fetchData();
            },
            onError: (e) {
              setState(() {
                _error = e;
              });
            },
          );
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

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
    _fetchData();
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      handleError(
          AsyncValue.error(_error.toString(), StackTrace.current), context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: TextStyle(color: Constants.primaryTextColor),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: (_isFetching)
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(getUserChatListProvider.future).then((newData) {
                  users = newData.data.toSet();
                }).catchError((e) {
                  _error = e;
                });
              },
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var item = users.elementAt(index);
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(userId: item.id)));
                    },
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
            ),
    );
  }
}
