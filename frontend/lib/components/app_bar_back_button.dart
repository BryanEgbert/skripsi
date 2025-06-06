import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

Widget appBarBackButton(BuildContext context) {
  return IconButton(
    onPressed: () => Navigator.of(context).pop(),
    icon: Icon(
      Icons.arrow_back_ios,
      color: Theme.of(context).brightness == Brightness.light
          ? Constants.primaryTextColor
          : Colors.orange,
    ),
  );
}
