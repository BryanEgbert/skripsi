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
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/message_tracker_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';

class PetOwnerChatListPage extends ConsumerStatefulWidget {
  const PetOwnerChatListPage({super.key});

  @override
  ConsumerState<PetOwnerChatListPage> createState() =>
      PetOwnerChatListPageState();
}

class PetOwnerChatListPageState extends ConsumerState<PetOwnerChatListPage> {
  // final _streamController = StreamController.broadcast();

  // IOWebSocketChannel? _channel;
  Set<User> users = {};
  List<ChatMessage> _unreadMessages = [];
  Object? _error;
  bool _isFetching = false;

  // StreamSubscription? _webSocketSubscription;

  void _fetchData() {
    setState(() {
      _isFetching = true;
    });

    ref.read(getUserChatListProvider.future).then((newData) {
      users = newData.data.toSet();
    }).catchError((e) {
      setState(() {
        _error = e;
      });
    }).whenComplete(() => setState(() => _isFetching = false));

    ref.read(getUnreadChatMessagesProvider.future).then((newData) {
      setState(() {
        _unreadMessages = newData.data;
      });
    });
  }

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          // _channel = value;
          // _streamController.add(_channel!.stream);
          // _webSocketSubscription = _streamController.stream.listen(
          //   (message) {
          //     log("new message");
          //     // Only fetch when new messages arrive
          //     ref.read(getUserChatListProvider.future).then((newData) {
          //       users = newData.data.toSet();
          //     }).catchError((e) {
          //       setState(() {
          //         _error = e;
          //       });
          //     });

          //     ref.read(getUnreadChatMessagesProvider.future).then((newData) {
          //       setState(() {
          //         _unreadMessages = newData.data;
          //       });
          //     });
          //   },
          //   onError: (e) {
          //     setState(() {
          //       log("websocket err: $e");
          //       _error = e;
          //     });
          //   },
          // );
        },
      );
    } catch (e) {
      log("fetchData: $e");
      if (e.toString() == jwtExpired ||
          e.toString() == userDeleted && mounted) {
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
    log("[PET OWNER CHAT LIST] dispose");
    // _webSocketSubscription?.cancel();
    // _streamController.close();
    // _channel?.sink.close();
    // ChatWebsocketChannel().sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = ref.watch(petOwnerChatListTrackerProvider);

    if (_error != null) {
      handleValue(
          AsyncValue.error(_error.toString(), StackTrace.current), this);
    }

    if (tracker.value ?? false) {
      _fetchData();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(petOwnerChatListTrackerProvider.notifier).reset();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Messages",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        actions: appBarActions(),
      ),
      body: (_isFetching)
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : (users.length == 0)
              ? ErrorText(
                  errorText: "Chat history will appear here",
                  onRefresh: () async {
                    ref.read(getUserChatListProvider.future).then((newData) {
                      setState(() {
                        users = newData.data.toSet();
                      });
                    }).catchError((e) {
                      setState(() {
                        _error = e;
                      });
                      // if (!mounted) return;
                      // handleError(
                      //   AsyncValue.error(_error.toString(), StackTrace.current),
                      //   context,
                      // );
                    });
                  })
              : RefreshIndicator.adaptive(
                  onRefresh: () async {
                    ref.read(getUserChatListProvider.future).then((newData) {
                      setState(() {
                        users = newData.data.toSet();
                      });
                    }).catchError((e) {
                      setState(() {
                        _error = e;
                      });
                      // if (!mounted) return;
                      // handleError(
                      //   AsyncValue.error(_error.toString(), StackTrace.current),
                      //   context,
                      // );
                    });
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      log("[PET OWNER CHAT PAGE] unreadMessages: ${_unreadMessages.length}");
                      var item = users.elementAt(index);
                      var unreadCount = _unreadMessages
                          .where(
                            (element) => element.senderId == item.id,
                          )
                          .length;

                      return ListTile(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(userId: item.id),
                            ),
                          );

                          ref
                              .read(getUnreadChatMessagesProvider.future)
                              .then((newData) {
                            setState(() {
                              _unreadMessages = newData.data;
                            });
                          });
                          ref
                              .read(messageTrackerProvider.notifier)
                              .shouldReload();
                          ref
                              .read(petOwnerChatListTrackerProvider.notifier)
                              .shouldReload();
                        },
                        leading: DefaultCircleAvatar(imageUrl: item.imageUrl),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryTextColor,
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
                            color: Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
