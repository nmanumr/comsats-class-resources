import 'package:class_resources/components/drawer.dart';
import 'package:class_resources/pages/add-course.dart';
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
  int _index = 0;

  _onSignOut(context) {
    Navigator.pop(context);
    widget.onSignOut();
  }

  initState() {
    super.initState();

    widget.auth.getCurrentUser().then((val) {
      widget.auth.getProfile(val.uid).listen((val) {
        if (val.data != null)
          setState(() {
            userProfile = val.data;
            isLoading = false;
          });
      });
    });
  }

  Widget _getFab(BuildContext ctx) {
    DefaultTabController.of(ctx).addListener(() {
      setState(() {
        _index = DefaultTabController.of(ctx).index;
      });
    });

    List<IconData> icons = [
      Icons.add,
    ];

    if (_index < 0 || _index > icons.length - 1) {
      return Text("");
    }

    return FloatingActionButton.extended(
      icon: Icon(icons[_index]),
      label: Text("Add Course"),
      elevation: 2,
      foregroundColor: Theme.of(ctx).colorScheme.onPrimary,
      backgroundColor: Theme.of(ctx).primaryColorDark,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddCourse(userId: userProfile['id'])),
        );
      },
    );
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
        floatingActionButton: Builder(
          builder: (BuildContext ctx) {
            return _getFab(ctx);
          },
        ),
      ),
    );
  }
}
