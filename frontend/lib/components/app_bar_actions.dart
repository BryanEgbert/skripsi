import 'package:flutter/material.dart';
import 'package:frontend/pages/account_settings_page.dart';
import 'package:frontend/pages/pet_owner_chat_list_page.dart';

List<Widget> petOwnerAppBarActions(int unreadMessageCount) {
  return [
    Builder(builder: (context) {
      return IconButton(
        icon: Badge.count(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.red[100]
              : null,
          count: unreadMessageCount,
          isLabelVisible: unreadMessageCount != 0,
          child: Icon(
            Icons.chat,
            color: Colors.orange,
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
          color: Colors.orange,
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
          color: Colors.orange,
        ),
      );
    }),
  ];
}
