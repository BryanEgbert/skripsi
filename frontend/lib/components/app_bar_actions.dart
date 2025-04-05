import 'package:flutter/material.dart';
import 'package:frontend/pages/edit/edit_user_page.dart';
import 'package:frontend/provider/auth_provider.dart';

List<Widget> appBarActions(Auth auth) {
  return [
    IconButton(
      icon: Icon(Icons.inbox_rounded),
      onPressed: () {},
    ),
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
            },
          ),
        ];
      },
    )
  ];
}
