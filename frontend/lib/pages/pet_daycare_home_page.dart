import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/pages/view_booked_pets_page.dart';
import 'package:frontend/pages/view_booking_requests_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/chat_tracker_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/message_tracker_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';

class PetDaycareHomePage extends ConsumerStatefulWidget {
  const PetDaycareHomePage({super.key});

  @override
  ConsumerState<PetDaycareHomePage> createState() => _PetDaycareHomePageState();
}

class _PetDaycareHomePageState extends ConsumerState<PetDaycareHomePage> {
  int _selectedIndex = 0;
  // IOWebSocketChannel? _channel;
  StreamSubscription? _webSocketSubscription;
  Object? _error;
  bool _hasInitialized = false;

  List<ChatMessage> messages = [];

  void _fetchMessages() {
    log("fetch message");
    final unreadChatMessages = ref.read(getUnreadChatMessagesProvider.future);
    unreadChatMessages.then((newData) {
      setState(() {
        messages = newData.data;
        log("message: ${messages.length}");
      });
    });
  }

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          // _channel = value;
          // _websocketStream = value.stream.asBroadcastStream();
          _webSocketSubscription = ChatWebsocketChannel().stream.listen(
            (message) {
              _fetchMessages();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(chatTrackerProvider.notifier).shouldReload();
              });
            },
            onError: (e) {
              if (e.toString() == jwtExpired ||
                  e.toString() == userDeleted && mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WelcomeWidget()),
                  (route) => false,
                );
              }
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

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    log("[PET DAYCARE HOME] init");
    if (_hasInitialized) return;
    _hasInitialized = true;
    _setupWebSocket();
    _fetchMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("update token");
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    ChatWebsocketChannel().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final unreadMessages = ref.watch(getUnreadChatMessagesProvider);
    final tracker = ref.watch(petDaycareChatListTrackerProvider);

    if (_error != null) {
      handleError(
          AsyncValue.error(_error.toString(), StackTrace.current), context);
    }

    if (tracker.value ?? false) {
      log("[PET DAYCARE HOME PAGE] tracker: ${tracker.value}");
      _fetchMessages();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(petDaycareChatListTrackerProvider.notifier).reset();
      });
    }

    final List<Widget> pages = [
      ViewBookedPetsPage(messages),
      ViewBookingRequestsPage(messages),
      // ViewSlotsPage(),
      PetDaycareDetailsPage.my(),
    ];

    return Scaffold(
      key: const Key("home"),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.orange
            : null,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.orange
            : null,

        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.pets),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.book_rounded),
            label: "Booking Requests",
          ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.orangeAccent,
          //   icon: Icon(Icons.calendar_month_rounded),
          //   label: "Slots",
          // ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.house),
            label: "My Pet Daycare",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
