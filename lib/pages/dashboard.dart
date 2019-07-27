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

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  final wantKeepAlive = true;

  ProfileModel _profileModel;
  int _cIndex = 0;

  List tabs = [];
  List<BottomNavigationBarItem> bottomNavItems = [];

  @override
  void initState() {
    super.initState();
    _profileModel = ProfileModel();
  }

  initTabs(BuildContext context, ProfileModel model) {
    if (tabs.isNotEmpty) return;

    tabs = [
      {
        "name": "Courses",
        "icon": Icons.book,
        "page": CoursesPage(model: model),
      },
      {
        "name": "Time Table",
        "icon": Icons.calendar_today,
        "page": TimeTablePage(),
      },
      {
        "name": "My Tasks",
        "icon": Icons.playlist_add_check,
        "page": NotificationPage(),
      },
      {
        "name": "Menu",
        "icon": Icons.menu,
        "page": LibraryPage(),
      }
    ];

    bottomNavItems = [];

    for (var tab in tabs) {
      bottomNavItems.add(BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColorDark,
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
  }

  Widget buildDashboard(BuildContext context, ProfileModel model) {
    initTabs(context, model);

    return Scaffold(
      key: PageStorageKey('BottomNavigationBar'),
      body: Builder(
        builder: (context) => tabs[_cIndex]["page"],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cIndex,
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
    super.build(context);

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
          return buildDashboard(context, model);
        },
      ),
    );
  }
}

//
