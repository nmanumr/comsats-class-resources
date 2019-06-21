import 'package:class_resources/pages/login.dart';
import 'package:class_resources/pages/reset-pass.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:flutter/material.dart';

import './themes.dart';
import './screens/main.dart';

void main() {
  return runApp(
    MyApp(),
  );
}

enum AuthStatus {
  RESET_PASS,
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class MyApp extends StatefulWidget {
  final auth = new AuthService();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _onResetPass(){
    setState(() {
      authStatus = AuthStatus.RESET_PASS;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        screen = _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        screen = new LoginPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          onResetPass: _onResetPass,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          screen = MainScreen(onSignOut: _onSignedOut);
        } else {
          screen = _buildWaitingScreen();
        }
        break;
      case AuthStatus.RESET_PASS:
        screen = ResetPassPage(
          auth: widget.auth,
          toLogin: _onSignedOut,
        );
        break;
      default:
        screen = _buildWaitingScreen();
    }

    return MaterialApp(
      title: 'Dynamic themes demo',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: screen,
      debugShowCheckedModeBanner: false,
    );
  }
}
