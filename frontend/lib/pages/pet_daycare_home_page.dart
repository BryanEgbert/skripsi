import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/pages/view_booked_pets_page.dart';
import 'package:frontend/pages/view_booking_requests_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/chat_tracker_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/message_tracker_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';

class PetDaycareHomePage extends ConsumerStatefulWidget {
  const PetDaycareHomePage({super.key});

  @override
  ConsumerState<PetDaycareHomePage> createState() => _PetDaycareHomePageState();
}

class _PetDaycareHomePageState extends ConsumerState<PetDaycareHomePage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  // IOWebSocketChannel? _channel;
  StreamSubscription? _webSocketSubscription;
  Object? _error;
  bool _hasInitialized = false;
  bool _isPaused = true;

  List<ChatMessage> messages = [];

  void _fetchMessages() {
    final unreadChatMessages = ref.read(getUnreadChatMessagesProvider.future);
    unreadChatMessages.then((newData) {
      setState(() {
        messages = newData.data;
      });
    });
  }

  void _setupWebSocket() {
    if (!_isPaused) return;
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          // _channel = value;
          // _websocketStream = value.stream.asBroadcastStream();
          _isPaused = false;
          _webSocketSubscription ??= ChatWebsocketChannel().stream.listen(
            (message) {
              _fetchMessages();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(chatTrackerProvider.notifier).shouldReload();
              });
            },
            onError: (e) {
              if (e.toString() == LocalizationService().jwtExpired ||
                  e.toString() == LocalizationService().userDeleted &&
                      mounted) {
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
      if (e.toString() == LocalizationService().jwtExpired && mounted) {
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

    if (_hasInitialized) return;

    _hasInitialized = true;
    _setupWebSocket();
    _fetchMessages();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    ChatWebsocketChannel().close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("[APP LIFECYCLE STATE] state changed: $state",
        name: "pet_daycare_home_page.dart");
    if (state == AppLifecycleState.resumed) {
      _setupWebSocket();
    } else if (state == AppLifecycleState.paused) {
      _webSocketSubscription?.cancel();
      ChatWebsocketChannel().close();
      _webSocketSubscription = null;
      _isPaused = true;
    }
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
        // backgroundColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.orange
        //     : null,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.orange
            : Constants.primaryTextColor,

        // unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.room_service),
            label: AppLocalizations.of(context)!.customers,
            tooltip: AppLocalizations.of(context)!.customers,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.pending_actions),
            label: AppLocalizations.of(context)!.bookingQueue,
            tooltip: AppLocalizations.of(context)!.bookingQueue,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.house),
            label: AppLocalizations.of(context)!.myPetDaycare,
            tooltip: AppLocalizations.of(context)!.myPetDaycare,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
