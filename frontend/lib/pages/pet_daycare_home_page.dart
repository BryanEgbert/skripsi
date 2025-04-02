import 'package:flutter/material.dart';

class PetDaycareHomePage extends StatefulWidget {
  const PetDaycareHomePage({super.key});

  @override
  State<PetDaycareHomePage> createState() => _PetDaycareHomePageState();
}

class _PetDaycareHomePageState extends State<PetDaycareHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            label: "Booked Pets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: "Booking Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.healing_rounded),
            label: "Slots",
          ),
          BottomNavigationBarItem(
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
