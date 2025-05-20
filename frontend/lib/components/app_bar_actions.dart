import 'package:flutter/material.dart';
import 'package:frontend/pages/edit/edit_user_page.dart';
import 'package:frontend/pages/pet_owner_chat_list_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/auth_provider.dart';

List<Widget> petOwnerAppBarActions(Auth auth) {
  return [
    Builder(builder: (context) {
      return IconButton(
        icon: Icon(
          Icons.chat_bubble_rounded,
          color: Colors.orange,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PetOwnerChatListPage(),
          ));
        },
      );
    }),
    PopupMenuButton(
      icon: Icon(Icons.person),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text("Edit Profile"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditUserPage()));
            },
          ),
          PopupMenuItem(
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              auth.logOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WelcomeWidget()),
                (route) => false,
              );
            },
          ),
        ];
      },
    )
  ];
}

List<Widget> appBarActions(Auth auth) {
  return [
    PopupMenuButton(
      icon: Icon(Icons.person),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text("Edit Profile"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditUserPage()));
            },
          ),
          PopupMenuItem(
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              auth.logOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WelcomeWidget()),
                (route) => false,
              );
            },
          ),
        ];
      },
    )
  ];
}
