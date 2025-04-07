import 'package:flutter/material.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/pages/view_booked_pets_page.dart';
import 'package:frontend/pages/view_booking_requests_page.dart';
import 'package:frontend/pages/view_slots_page.dart';

class PetDaycareHomePage extends StatefulWidget {
  const PetDaycareHomePage({super.key});

  @override
  State<PetDaycareHomePage> createState() => _PetDaycareHomePageState();
}

class _PetDaycareHomePageState extends State<PetDaycareHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ViewBookedPetsPage(),
    ViewBookingRequestsPage(),
    ViewSlotsPage(),
    PetDaycareDetailsPage.my(),
  ];

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
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.house),
            label: "Booking Requests",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.calendar_month_rounded),
            label: "Slots",
          ),
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
