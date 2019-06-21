import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback onSignOut;

  AppDrawer({this.onSignOut});

  final AuthService auth = AuthService();

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  Animatable<Offset> _drawerDetailsTween;
  bool _showDrawerContents = true;

  String name = "";
  String rollNum = "";

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _drawerContentsOpacity =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);
    _drawerDetailsTween = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero.translate(0, .2),
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    _drawerDetailsPosition = controller.drive(_drawerDetailsTween);

    widget.auth.getCurrentUser().then((val) {
      setState(() {
        name = val.displayName;
        rollNum = val.email.substring(0, 12);
      });
    });
  }

  Widget userActions() {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("Profile"), leading: Icon(Icons.person)),
        ListTile(
          title: Text("Logout"),
          leading: Icon(Icons.exit_to_app),
          onTap: widget.onSignOut,
        ),
        Divider(),
      ],
    );
  }

  Widget appActions() {
    return ListView(
      children: <Widget>[
        ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
        ListTile(leading: Icon(Icons.apps), title: Text("More Apps")),
        ListTile(leading: Icon(Icons.code), title: Text("Source Code")),
      ],
    );
  }

  Widget accountHeader() {
    if (rollNum.isEmpty) return Text("");
    return UserAccountsDrawerHeader(
      accountName: Text(name ?? ""),
      accountEmail: Text(rollNum ?? ""),
      currentAccountPicture: textCircularAvatar(name.isEmpty ? rollNum: name),
      onDetailsPressed: () {
        _showDrawerContents = !_showDrawerContents;
        if (_showDrawerContents)
          controller.reverse();
        else
          controller.forward();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          accountHeader(),
          Expanded(
            child: Stack(
              children: <Widget>[
                FadeTransition(
                  opacity: _drawerContentsOpacity,
                  child: userActions(),
                ),
                SlideTransition(
                  position: _drawerDetailsPosition,
                  child: appActions(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
