import 'package:flutter/material.dart';
import 'package:frontend/pages/booking_history_view.dart';
import 'package:frontend/pages/pet_daycares_view.dart';
import 'package:frontend/pages/pets_view.dart';
import 'package:frontend/pages/vets_view.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PetsView(),
    PetDaycaresView(),
    VetsView(),
    BookingHistoryView(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Change based on roles
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
