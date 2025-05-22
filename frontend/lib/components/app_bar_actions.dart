import 'package:flutter/material.dart';
import 'package:frontend/pages/account_settings_page.dart';
import 'package:frontend/pages/pet_owner_chat_list_page.dart';
import 'package:frontend/provider/auth_provider.dart';

List<Widget> petOwnerAppBarActions(int unreadMessageCount) {
  return [
    Builder(builder: (context) {
      return IconButton(
        icon: (unreadMessageCount == 0)
            ? Icon(
                Icons.chat,
                color: Colors.orange,
              )
            : Badge.count(
                count: unreadMessageCount,
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

List<Widget> appBarActions(Auth auth) {
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
