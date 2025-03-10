import 'package:flutter/material.dart';
import 'package:frontend/widgets/pet_daycares_view.dart';
import 'package:frontend/widgets/pets_view.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final int _selectedIndex = 1;

  final List<Widget> _pages = [
    PetDaycaresView(),
    PetsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("home"),
      appBar: AppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: "Pets",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.house),
          label: "Pet Daycares",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ]),
    );
  }
}
