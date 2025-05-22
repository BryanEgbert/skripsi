import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/pages/booking_history_view.dart';
import 'package:frontend/pages/pet_daycares_view.dart';
import 'package:frontend/pages/pets_view.dart';
import 'package:frontend/pages/vets_view.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:web_socket_channel/io.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  int _selectedIndex = 0;
  IOWebSocketChannel? _channel;
  StreamSubscription? _webSocketSubscription;

  List<ChatMessage> messages = [];

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
          _webSocketSubscription = _channel!.stream.listen(
            (message) {
              final unreadChatMessages =
                  ref.read(getUnreadChatMessagesProvider);
              if (unreadChatMessages.hasError && !unreadChatMessages.hasValue) {
                log("[ERROR] fetching unread messages: ${unreadChatMessages.error.toString()}");
              } else {
                setState(() {
                  messages = unreadChatMessages.value!.data;
                });
              }
            },
            onError: (e) {
              setState(() {});
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
    _setupWebSocket();
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      PetsView(messages),
      PetDaycaresView(messages),
      VetsView(messages),
      BookingHistoryView(messages),
    ];

    return Scaffold(
      key: const Key("home"),
      body: _pages[_selectedIndex],
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
