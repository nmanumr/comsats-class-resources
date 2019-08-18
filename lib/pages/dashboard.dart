import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './courses/courses.dart';
import './notifications.dart';
import './timetable/timetable.dart';
import './menu/library.dart';

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

  List tabs;

  @override
  void initState() {
    super.initState();
    _profileModel = ProfileModel();
  }

  @override
  void dispose() {
    super.dispose();
    _profileModel.close();
  }

  List<BottomNavigationBarItem> initTabs(ProfileModel model) {
    List<BottomNavigationBarItem> bottomNavItems = [];
    tabs = [
      {
        "name": "Courses",
        "icon": Icons.book,
        "page": CoursesPage(model: model),
      },
      {
        "name": "Time Table",
        "icon": Icons.calendar_today,
        "page": TimeTablePage(userModel: model),
      },
      {
        "name": "Notifications",
        "icon": Icons.notifications,
        "page": NotificationPage(),
      },
      {
        "name": "Menu",
        "icon": Icons.menu,
        "page": LibraryPage(),
      }
    ];

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

    return bottomNavItems;
  }

  Widget buildDashboard(BuildContext context, ProfileModel model) {
    var bottomNavItems = initTabs(model);

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
          if (model.profileStatus == ProfileStatus.Loading) {
            return Loader();
          }

          if (model.profileStatus == ProfileStatus.AuthError) {
            return Scaffold(
              appBar: centeredAppBar(context, ""),
              body: IllustartedPage(
                imagePath: "assets/images/warning.png",
                headingText: "Account not found",
                subheadingText:
                    "You account not found may be deleted or disabled by admin.",
                centerButton: RaisedButton(
                  child: Text("Goto Home"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/welcome", (_) => false);
                  },
                ),
              ),
            );
          }

          if (model.profileStatus == ProfileStatus.ProfileError) {
            return Scaffold(
              appBar: centeredAppBar(context, ""),
              body: Center(
                child: IllustartedPage(
                  imagePath: "assets/images/warning.png",
                  headingText: "Profile not found",
                  subheadingText:
                      "No profile found corresponding your ID. Either its deleted or hadn't created yet.",
                  centerButton: RaisedButton(
                    child: Text("Create Profile"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/create-profile");
                    },
                  ),
                ),
              ),
            );
          }

          // build dashboard layout
          return buildDashboard(context, model);
        },
      ),
    );
  }
}
