import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/timetable.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/pages/auth/update-profile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './courses/courses.dart';
import './notifications.dart';
import './timetable/timetable.dart';
import './menu/library.dart';

class Dashboard extends StatefulWidget {
  Dashboard(this.user);

  final UserModel user;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  final wantKeepAlive = true;

  TimeTableModel timeTableModel;
  int _cIndex = 0;

  List tabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.user.profile.service.close();
  }

  List<BottomNavigationBarItem> initTabs() {
    List<BottomNavigationBarItem> bottomNavItems = [];
    tabs = [
      {
        "name": "Courses",
        "icon": Icons.book,
        "page": CoursesPage(model: widget.user.profile),
      },
      {
        "name": "Time Table",
        "icon": Icons.calendar_today,
        "page": TimeTablePage(timetableModel: timeTableModel),
      },
      {
        "name": "Notifications",
        "icon": Icons.notifications,
        "page": NotificationPage(timetableModel: timeTableModel),
      },
      {
        "name": "Menu",
        "icon": Icons.menu,
        "page": LibraryPage(widget.user),
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

  Widget buildDashboard(BuildContext context) {
    var bottomNavItems = initTabs();

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
      model: widget.user,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
          // Model not loaded yet
          if (userModel.status == AccountStatus.Loading) {
            return Loader();
          }

          if (userModel.status == AccountStatus.AuthError) {
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

          return ScopedModel(
            model: userModel.profile,
            child: ScopedModelDescendant<ProfileModel>(
              builder: (context, child, profileModel) {

                if (profileModel == null || profileModel.status == ProfileStatus.Loading) {
                  return Loader();
                }

                if (profileModel.status == ProfileStatus.Error) {
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UpdateProfile(
                                  navigateToDashboard: true,
                                  profile: ProfileModel(userModel),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }

                // build dashboard layout
                return buildDashboard(context);
              },
            ),
          );
        },
      ),
    );
  }
}
