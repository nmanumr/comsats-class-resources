import 'package:class_resources/pages/menu/privacy-policy.dart';
import 'package:class_resources/pages/courses/add-courses.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './themes.dart';
import './pages/dashboard.dart';
import './pages/welcome.dart';
import './pages/auth/signup.dart';
import './pages/auth/login.dart';
import './pages/auth/update-profile.dart';
import './pages/courses/create-course.dart';
import 'pages/menu/license.dart';

void main() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? "";
    return runApp(AppMain(uid: uid));
  } catch (_) {
    return runApp(AppMain(uid: ""));
  }
}

class AppMain extends StatelessWidget {
  AppMain({@required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Resources',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      routes: {
        '/': (ctx) => this.uid == "" ? WelcomePage() : Dashboard(),
        '/welcome': (ctx) => WelcomePage(),
        '/dashboard': (ctx) => Dashboard(),
        '/signup': (ctx) => SignupPage(),
        '/login': (ctx) => LoginPage(),
        '/edit-profile': (ctx) => UpdateProfile(),
        '/add-course': (ctx) => AddCourses(),
        '/create-course': (ctx) => CreateCourse(),
        '/license': (ctx) => AppLicensePage(),
        '/privacypolicy': (ctx) => PrivacyPolicyPage()
      },
    );
  }
}
