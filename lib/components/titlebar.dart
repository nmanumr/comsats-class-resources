import 'package:flutter/material.dart';

AppBar titleBar(BuildContext context) {
  return new AppBar(
    title: const Text('Class Resources'),
    elevation: 1.5,
    actions: <Widget>[
      // overflow menu
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
    ],
    bottom: TabBar(
      isScrollable: true,
      tabs: [
        Tab(text: "HOME"),
        Tab(text: "TIME TABLE"),
        Tab(text: "NOTIFICATIONS"),
        Tab(text: "LIBRARY"),
      ],
    ),
  );
}