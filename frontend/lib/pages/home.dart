import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/pages/booking_history_view.dart';
import 'package:frontend/pages/pet_daycares_view.dart';
import 'package:frontend/pages/pets_view.dart';
import 'package:frontend/pages/vets_view.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/chat_tracker_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/message_tracker_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:web_socket_channel/io.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  // final _streamController = StreamController.broadcast();

  int _selectedIndex = 0;
  IOWebSocketChannel? _channel;
  late Stream _websocketStream;
  // StreamSubscription? _webSocketSubscription;
  int _messageCount = 0;
  bool _hasInitialized = false;

  bool _isSocketReady = false;
  Object? _error;

  List<ChatMessage> _messages = [];

  void _fetchData() {
    final unreadChatMessages = ref.read(getUnreadChatMessagesProvider.future);
    unreadChatMessages.then((newData) {
      setState(() {
        _messages = newData.data;
        _messageCount = _messages.length;
      });
    });
  }

  void _setupWebSocket() {
    setState(() {
      _isSocketReady = false;
    });

    try {
      ChatWebsocketChannel().instance.then((value) {
        _channel = value;
        _websocketStream = value.stream.asBroadcastStream();
        // _streamController.addStream(value.stream);
        // _webSocketSubscription = value.stream.listen(
        //   (message) {
        //     log("[HOME PAGE] new message: ${message.length}");
        //     _fetchData();
        //   },
        // );
        setState(() {
          _isSocketReady = true;
        });
      }).catchError((e) {
        log("[_setupWebSocket] err: $e");
        // handleError(AsyncError(e, StackTrace.current), context);
        setState(() {
          _error = e;
        });
      });
    } catch (e) {
      if (e.toString() == jwtExpired ||
          e.toString() == userDeleted && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeWidget()),
          (route) => false,
        );
      }
    }
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    log("[HOME] init");
    if (_hasInitialized) return;
    _hasInitialized = true;
    _setupWebSocket();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("update token");
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  void dispose() {
    log("[HOME PAGE] dispose");
    // _webSocketSubscription?.cancel();
    // _streamController.close();
    _channel?.sink.close();
    ChatWebsocketChannel().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("[HOME PAGE] build");

    final messageTracker = ref.watch(messageTrackerProvider);

    if (_error != null) {
      handleError(AsyncError(_error!, StackTrace.empty), context);
      _error = null;
    }

    log("[HOME PAGE] messageTracker: $messageTracker");
    if (messageTracker.value ?? false) {
      log("[HOME PAGE] running message tracker");
      _fetchData();
      _messageCount = 0;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(messageTrackerProvider.notifier).reset();
      });
    }

    return Scaffold(
      key: const Key("home"),
      body: _isSocketReady
          ? StreamBuilder(
              stream: _websocketStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(chatTrackerProvider.notifier).shouldReload();
                  });

                  var unreadMsg = ListData<ChatMessage>.fromJson(
                          jsonDecode(snapshot.data), ChatMessage.fromJson)
                      .data
                      .where((e) => !e.isRead);

                  log("[INFO] append unread message count, unread msg: ${unreadMsg.length}, message count: $_messageCount");
                  if (unreadMsg.length > _messageCount) {
                    _messageCount = unreadMsg.length;
                    final unreadChatMessages =
                        ref.read(getUnreadChatMessagesProvider.future);
                    unreadChatMessages.then((newData) {
                      setState(() {
                        _messages = newData.data;
                      });
                    });
                  }
                }

                final List<Widget> pages = [
                  PetsView(_messages),
                  PetDaycaresView(_messages),
                  VetsView(_messages),
                  BookingHistoryView(_messages),
                ];

                return pages[_selectedIndex];
              })
          : Center(child: CircularProgressIndicator.adaptive()),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,

        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.pets),
            label: "Pets",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.house),
            label: "Pet Daycares",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.medical_services),
            label: "Vets",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.menu_book_rounded),
            label: "Booking History",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
