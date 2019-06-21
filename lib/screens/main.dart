import 'package:class_resources/components/drawer.dart';
import 'package:flutter/material.dart';

import '../components/titlebar.dart';
import './home.dart';
import './notifications.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
  //   CustomTheme.instanceOf(buildContext).changeTheme(key);
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: titleBar(context),
        drawer: drawer("Nauman Umer", "FA18-BCS-162"),
        body: TabBarView(
          children: [
            HomeScreen(),
            Center(child: Text("Page 2")),
            NotificationsScreen(),
            Center(child: Text("Page 2")),
          ],
        ),
      ),
    );
  }
}
