import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/app_bar_back_button.dart';
import 'package:frontend/provider/auth_provider.dart';

class EditPetDaycarePage extends ConsumerStatefulWidget {
  const EditPetDaycarePage({super.key});

  @override
  ConsumerState<EditPetDaycarePage> createState() => _EditPetDaycarePageState();
}

class _EditPetDaycarePageState extends ConsumerState<EditPetDaycarePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: appBarBackButton(context),
          title: Text(
            "Edit Pet Daycare",
            style: TextStyle(color: Colors.orange),
          ),
          centerTitle: false,
          // TODO: update pet daycare info
          actions: [
            TextButton(
                onPressed: () {},
                child: Text(
                  "SAVE",
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold),
                ))
          ],
          bottom: TabBar(tabs: [
            Tab(
              child: Text(
                "Details",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Images",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Slots",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Services",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          Text(
            "Details",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Images",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Slots",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Services",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}
