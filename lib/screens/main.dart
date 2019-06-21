import 'package:class_resources/components/drawer.dart';
import 'package:flutter/material.dart';

import '../components/titlebar.dart';
import './home.dart';
import './notifications.dart';

class MainScreen extends StatefulWidget {
  MainScreen({this.onSignOut});

  final VoidCallback onSignOut;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: titleBar(context),
        drawer: AppDrawer(onSignOut: widget.onSignOut),
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
