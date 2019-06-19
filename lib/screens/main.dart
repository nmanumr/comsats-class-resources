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
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Nauman Umer"),
                accountEmail: Text("FA18-BCS-162"),
                currentAccountPicture: CircleAvatar(
                  child: Text("NU"),
                ),
              ),
              ListTile(title: Text("Item 1")),
              ListTile(title: Text("Item 2")),
              ListTile(title: Text("Item 3")),
              ListTile(title: Text("Item 4")),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings")),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text("More Apps")),
              ListTile(
                leading: Icon(Icons.code),
                title: Text("Source Code")),
            ],
          ),
        ),
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
