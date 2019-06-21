import 'package:class_resources/components/text-avatar.dart';
import 'package:flutter/material.dart';

Drawer drawer(String name, String rollNum) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(name),
          accountEmail: Text(rollNum),
          currentAccountPicture: textCircularAvatar(name),
        ),
        ListTile(title: Text("Item 1")),
        ListTile(title: Text("Item 2")),
        ListTile(title: Text("Item 3")),
        ListTile(title: Text("Item 4")),
        Divider(),
        ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
        ListTile(leading: Icon(Icons.apps), title: Text("More Apps")),
        ListTile(leading: Icon(Icons.code), title: Text("Source Code")),
      ],
    ),
  );
}
