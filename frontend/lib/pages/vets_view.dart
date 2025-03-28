import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VetsView extends StatefulWidget {
  const VetsView({super.key});

  @override
  State<VetsView> createState() => _VetsViewState();
}

class _VetsViewState extends State<VetsView> {
  // TODO: Complete view vet page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vets"),
      ),
      body: Text("Vets page"),
    );
  }
}
