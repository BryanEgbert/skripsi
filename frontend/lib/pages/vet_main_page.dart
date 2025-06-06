import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/message_tracker_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/services/localization_service.dart';
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
  late Stream _websocketStream;
  StreamSubscription? _webSocketSubscription;

  bool _hasInitialized = false;

  Object? _error;

  Set<User> users = {};
  List<ChatMessage> _messages = [];

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
          _websocketStream = value.stream.asBroadcastStream();
          _webSocketSubscription = _websocketStream.listen(
            (message) {
              log("[VET MAIN PAGE] new message");
              _fetchData();

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ref.read(vetChatListTrackerProvider.notifier).reset();
                ref.invalidate(getUserChatListProvider);
                // ref.read(chatTrackerProvider.notifier).shouldReload();
              });
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
      if (e.toString() == LocalizationService().jwtExpired ||
          e.toString() == LocalizationService().userDeleted && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeWidget()),
          (route) => false,
        );
      }
    }
  }

  void _fetchData() {
    // ref.invalidate(getUserChatListProvider);
    // ref.read(getUserChatListProvider.future).then((newData) {
    //   users = newData.data.toSet();
    // }).catchError((e) {
    //   setState(() {
    //     _error = e;
    //   });
    // });

    ref.read(getUnreadChatMessagesProvider.future).then((newData) {
      setState(() {
        _messages = newData.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (_hasInitialized) return;
    _hasInitialized = true;

    if (_channel == null) _setupWebSocket();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _channel?.sink.close();
    ChatWebsocketChannel().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(getUserChatListProvider);
    final tracker = ref.watch(vetChatListTrackerProvider);

    if (_error != null) {
      handleError(
          AsyncValue.error(_error.toString(), StackTrace.current), context);
    }

    if (tracker.value ?? false) {
      _fetchData();
      ref.invalidate(getUserChatListProvider);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(vetChatListTrackerProvider.notifier).reset();
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.messages,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          actions: appBarActions(),
        ),
        body: switch (chatList) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () async {
                _fetchData();
                return ref.refresh(getUserChatListProvider.future);
              },
            ),
          AsyncData(:final value) => (value.data.isNotEmpty)
              ? RefreshIndicator.adaptive(
                  onRefresh: () async {
                    _fetchData();
                    return ref.refresh(getUserChatListProvider.future);
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: value.data.toSet().toList().length,
                    itemBuilder: (context, index) {
                      User item = value.data.toSet().toList().elementAt(index);
                      int unreadCount = _messages
                          .where(
                            (element) => element.senderId == item.id,
                          )
                          .length;

                      return ListTile(
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(userId: item.id),
                          ));

                          _fetchData();
                          ref
                              .read(vetChatListTrackerProvider.notifier)
                              .shouldReload();
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
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                          ),
                        ),
                        trailing: Badge.count(
                          count: unreadCount,
                          isLabelVisible: unreadCount != 0,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.red[100]
                                  : null,
                          child: Icon(
                            Icons.chat,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : ErrorText(
                  errorText: AppLocalizations.of(context)!.petOwnersMessageInfo,
                  onRefresh: () async {
                    _fetchData();
                  },
                ),
          _ => Center(
              child: CircularProgressIndicator.adaptive(),
            )
        });
  }
}
