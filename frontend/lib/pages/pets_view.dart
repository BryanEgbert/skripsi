import 'package:flutter/material.dart';

class PetsView extends StatefulWidget {
  const PetsView({super.key});

  @override
  State<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends State<PetsView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("View pets page"),
    );
  }
}
