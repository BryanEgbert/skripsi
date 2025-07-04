import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
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
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:web_socket_channel/io.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget>
    with WidgetsBindingObserver {
  // final _streamController = StreamController.broadcast();

  int _selectedIndex = 0;
  IOWebSocketChannel? _channel;
  Stream? _websocketStream;
  // StreamSubscription? _webSocketSubscription;
  int _messageCount = 0;
  bool _hasInitialized = false;
  bool _isPaused = true;

  bool _isSocketReady = true;
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
    if (!_isPaused) return;
    setState(() {
      _isSocketReady = false;
    });

    try {
      ChatWebsocketChannel().instance.then((value) {
        _channel = value;
        _websocketStream = value.stream.asBroadcastStream();
        setState(() {
          _isSocketReady = true;
          _isPaused = false;
        });
      }).catchError((e) {
        log("[_setupWebSocket] err: $e");
        setState(() {
          _error = e;
        });
      });
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
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    ChatWebsocketChannel().close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("[APP LIFECYCLE STATE] state changed: $state", name: "home.dart");
    if (state == AppLifecycleState.resumed) {
      _setupWebSocket();
    } else if (state == AppLifecycleState.paused) {
      _channel?.sink.close();
      ChatWebsocketChannel().close();
      _channel = null;
      _websocketStream = null;
      _isPaused = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // log("[HOME] build");
    final messageTracker = ref.watch(messageTrackerProvider);

    if (_error != null) {
      handleError(AsyncError(_error!, StackTrace.empty), context);
      _error = null;
    }

    if (messageTracker.value ?? false) {
      _fetchData();
      _messageCount = 0;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(messageTrackerProvider.notifier).reset();
      });
    }

    return Scaffold(
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
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.orange,
        // backgroundColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.orange
        //     : null,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.orange
            : Constants.primaryTextColor,

        // unselectedItemColor: const Color.fromARGB(255, 91, 73, 73),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.pets),
            label: AppLocalizations.of(context)!.petsNav,
            tooltip: AppLocalizations.of(context)!.petsNav,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.explore),
            label: AppLocalizations.of(context)!.exploreNav,
            tooltip: AppLocalizations.of(context)!.exploreNav,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.medical_services),
            label: AppLocalizations.of(context)!.vetsNav,
            tooltip: AppLocalizations.of(context)!.vetsNav,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.menu_book_rounded),
            label: AppLocalizations.of(context)!.bookingsNav,
            tooltip: AppLocalizations.of(context)!.bookingsNav,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
