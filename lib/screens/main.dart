import 'package:class_resources/components/drawer.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:flutter/material.dart';

import '../components/titlebar.dart';
import './home.dart';
import './notifications.dart';

class MainScreen extends StatefulWidget {
  MainScreen({this.onSignOut});

  final VoidCallback onSignOut;
  final AuthService auth = AuthService();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var userProfile;
  bool isLoading = true;

  _onSignOut(context) {
    Navigator.pop(context);
    widget.onSignOut();
  }

  initState() {
    super.initState();
    widget.auth.getUserProfile().then((val) {
      setState(() {
        userProfile = val.data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: titleBar(context),
        drawer: AppDrawer(
            onSignOut: () => _onSignOut(context), userProfile: userProfile),
        body: TabBarView(
          children: [
            isLoading ? Text("Loading") : HomeScreen(userProfile: userProfile),
            Center(child: Text("Page 2")),
            NotificationsScreen(),
            Center(child: Text("Page 2")),
          ],
        ),
      ),
    );
  }
}
