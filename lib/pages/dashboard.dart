import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/pages/auth/update-profile.dart';
import 'package:class_resources/pages/home/home.dart';
import 'package:class_resources/screen_widgets/timetable/timeTableScreenWidget.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './courses/courses.dart';
import './timetable/timetable.dart';
import './menu/library.dart';

class Dashboard extends StatefulWidget {
  Dashboard(this.user, this.observer){

    // Call native screen-widget to hard update
    TimeTableScreenWidget.refreshWidget();
  }

  final UserModel user;
  final FirebaseAnalyticsObserver observer;

  @override
  _DashboardState createState() => _DashboardState(observer);
}

class _DashboardState extends State<Dashboard>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        RouteAware {
  _DashboardState(this.observer);

  @override
  final wantKeepAlive = true;

  final FirebaseAnalyticsObserver observer;

  bool timeTableServiceStarted = false;

  // TimeTableModel timeTableModel;
  int _cIndex = 0;

  List tabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    observer.unsubscribe(this);
    super.dispose();
  }

  List<BottomNavigationBarItem> initTabs() {
    List<BottomNavigationBarItem> bottomNavItems = [];
    tabs = [
      {
        "name": "Home",
        "icon": Icons.home,
        "page": HomePage(userProfile: widget.user.profile)
      },
      {
        "name": "Courses",
        "path": "courses",
        "icon": Icons.book,
        "page": CoursesPage(model: widget.user.profile),
      },
      {
        "name": "Time Table",
        "path": "timetable",
        "icon": Icons.calendar_today,
        "page": TimeTablePage(userProfile: widget.user.profile),
      },
      {
        "name": "Menu",
        "path": "menu",
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

    if(!timeTableServiceStarted){
      timeTableServiceStarted = true;
      widget.user.service.timeTableService.update();
    }

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
          if (_cIndex == index) return;
          setState(() {
            _cIndex = index;
          });
          observer.analytics.setCurrentScreen(
            screenName: 'dashboard/${tabs[index]["path"]}',
          );
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
        builder: (context, _, userModel) {
          // Model not loaded yet
          if (userModel.status == AccountStatus.Loading) {
            return Loader();
          }

          if (userModel.status == AccountStatus.AuthError) {
            widget.user.service.timeTableService.update();
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
                if (profileModel == null ||
                    profileModel.status == ProfileStatus.Loading) {
                  return Loader();
                }

                if (profileModel.status == ProfileStatus.Error) {
                  widget.user.service.timeTableService.update();
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
