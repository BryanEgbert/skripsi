import 'package:flutter/material.dart';

Widget appBarBackButton(BuildContext context) {
  return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back_ios));
}
