import 'package:flutter/material.dart';

AppBar titleBar(BuildContext context) {
  return new AppBar(
    title: const Text('Class Resources'),
    elevation: 1.5,
    actions: <Widget>[
      // overflow menu
      PopupMenuButton<Choice>(
        onSelected: (Choice choice) {},
        itemBuilder: (BuildContext context) {
          return choices.skip(2).map((Choice choice) {
            return PopupMenuItem<Choice>(
                value: choice,
                child: Row(
                  children: <Widget>[
                    Icon(choice.icon),
                    Text(choice.title),
                  ],
                ));
          }).toList();
        },
      ),
    ],
    bottom: TabBar(
      isScrollable: true,
      indicatorWeight: 3,
      tabs: [
        Tab(text: "HOME"),
        Tab(text: "TIME TABLE"),
        Tab(text: "NOTIFICATIONS"),
        Tab(text: "LIBRARY"),
      ],
    ),
  );
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Toggle Dark', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
