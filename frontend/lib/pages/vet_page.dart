import 'package:flutter/material.dart';

class VetMainPage extends StatefulWidget {
  const VetMainPage({super.key});

  @override
  State<VetMainPage> createState() => VetMainPageState();
}

class VetMainPageState extends State<VetMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Vett main page"),
      ),
    );
  }
}
