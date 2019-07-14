import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.dart';
import 'package:class_resources/pages/update-profile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './courses.dart';
import './notifications.dart';
import './timetable.dart';
import './library.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ProfileModel _profileModel;
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
      "name": "Menu",
      "icon": Icons.menu,
      "page": LibraryPage(),
    },
  ];

  @override
  void initState() {
    _profileModel = ProfileModel();
    super.initState();
  }

  Widget build_dashboard(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _profileModel,
      child: ScopedModelDescendant<ProfileModel>(
        builder: (context, child, model) {
          // Model not loaded yet
          if (model.isLoading) {
            return Loader();
          }
          // Profile not created
          else if (!model.isProfileComplete) {
            return UpdateProfile();
          }
          // build dashboard layout

          return build_dashboard(context);
        },
      ),
    );
  }
}

//
