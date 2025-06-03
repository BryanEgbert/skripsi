import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/account_settings_page.dart';
import 'package:frontend/pages/pet_owner_chat_list_page.dart';

List<Widget> petOwnerAppBarActions(int unreadMessageCount) {
  return [
    Builder(builder: (context) {
      return IconButton(
        icon: Badge.count(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.red[100]
              : Constants.primaryTextColor,
          count: unreadMessageCount,
          textColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : null,
          isLabelVisible: unreadMessageCount != 0,
          child: Icon(
            Icons.chat,
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PetOwnerChatListPage(),
          ));
        },
      );
    }),
    Builder(builder: (context) {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountSettingsPage(),
          ));
        },
        icon: Icon(
          Icons.settings,
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.primaryTextColor
              : Colors.orange,
        ),
      );
    }),
  ];
}

List<Widget> appBarActions() {
  return [
    Builder(builder: (context) {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountSettingsPage(),
          ));
        },
        icon: Icon(
          Icons.settings,
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.primaryTextColor
              : Colors.orange,
        ),
      );
    }),
  ];
}
