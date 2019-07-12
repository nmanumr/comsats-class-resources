import 'package:flutter/material.dart';

import './courses.dart';
import './notifications.dart';
import './timetable.dart';
import './library.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _cIndex = 0;

  final tabs = [
    {
      "name": "Courses",
      "icon": Icons.book,
      "page": CoursesPage(),
    },
    {
      "name": "Time Table",
      "icon": Icons.calendar_today,
      "page": TimeTablePage(),
    },
    {
      "name": "Notifications",
      "icon": Icons.add_alert,
      "page": NotificationPage(),
    },
    {
      "name": "Library",
      "icon": Icons.folder,
      "page": LibraryPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavItems = [];

    for (var tab in tabs) {
      bottomNavItems.add(BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColorLight,
        icon: Opacity(
          opacity: 0.5,
          child: Icon(tab['icon']),
        ),
        activeIcon: Icon(tab['icon']),
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(tab['name']),
        ),
      ));
    }

    return Scaffold(
      body: Builder(
        builder: (context) => tabs[_cIndex]["page"],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cIndex,
        backgroundColor: Theme.of(context).primaryColorLight,
        type: BottomNavigationBarType.shifting,
        selectedFontSize: 12,
        selectedItemColor: Theme.of(context).accentColor,
        items: bottomNavItems,
        onTap: (index) {
          setState(() {
            _cIndex = index;
          });
        },
      ),
    );
  }
}
