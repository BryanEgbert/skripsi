import 'package:flutter/material.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/pages/booking_history_view.dart';
import 'package:frontend/pages/pet_daycares_view.dart';
import 'package:frontend/pages/pets_view.dart';
import 'package:frontend/pages/vets_view.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:web_socket_channel/io.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  IOWebSocketChannel? _channel;

  final List<Widget> _pages = [
    PetsView(),
    PetDaycaresView(),
    VetsView(),
    BookingHistoryView(),
  ];

  Future<void> _setupWebSocket() async {
    try {
      _channel = await ChatWebsocketChannel().instance;
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
  Widget build(BuildContext context) {
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
