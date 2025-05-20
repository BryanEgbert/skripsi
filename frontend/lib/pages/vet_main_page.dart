import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:web_socket_channel/io.dart';

class VetMainPage extends ConsumerStatefulWidget {
  const VetMainPage({super.key});

  @override
  ConsumerState<VetMainPage> createState() => VetMainPageState();
}

class VetMainPageState extends ConsumerState<VetMainPage> {
  IOWebSocketChannel? _channel;

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
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

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(getUserChatListProvider);

    return Scaffold(
        appBar: AppBar(
          actions: appBarActions(ref.read(authProvider.notifier)),
        ),
        body: switch (chatList) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(getUserChatListProvider.future),
            ),
          AsyncData(:final value) => (value.data.isNotEmpty)
              ? StreamBuilder(
                  stream: _channel?.stream,
                  builder: (context, snapshot) {
                    Set<User> users = value.data.toSet();

                    // if (snapshot.hasData) {
                    //   log("new message: ${snapshot.data}");
                    // }
                    return RefreshIndicator(
                      onRefresh: () =>
                          ref.refresh(getUserChatListProvider.future),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var item = users.elementAt(index);
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(userId: item.id)));
                            },
                            leading:
                                DefaultCircleAvatar(imageUrl: item.imageUrl),
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
                    );
                  })
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
